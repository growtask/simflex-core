<?php

namespace Simflex\Core\Http;

use Simflex\Core\System\Container;
use Simflex\Core\System\ExtensionRegistry;
use Simflex\Core\System\DI\Injector;
use Simflex\Core\DB\AQ;
use Simflex\Core\Models\ModuleItem;
use Simflex\Core\Models\Seo;
use Simflex\Core\Http\Html\HtmlRequest;
use Simflex\Core\Http\Html\HtmlResponse;
use Simflex\Core\Http\Routing\Resolver;
use Simflex\Core\Layout\LayoutManager;

/**
 * Страница сайта: обработка запроса к сайту (не к админке).
 *
 * init() - запрос и ответ в контейнере, SEO страницы из раздела «SEO», ajax-запрос модуля (sf_module_id), затем
 * модули и компонент страницы (getComponent() - по маршрутам и меню сайта); execute() - вывод темы сайта. В шаблоне
 * темы страница - переменная $page: $page->getContent(), getPosition(), getMeta() (заголовок, мета-теги, стили),
 * getMetaJs() (скрипты). Объект страницы - в контейнере (Container::getPage()).
 *
 * Заголовок и мета-теги - PageSeo, стили и скрипты - PageAssets, настройки сайта - System\Settings, меню - Menu
 */
class Page
{
    /** Выводить только содержимое компонента, без темы (ajax-запрос) */
    protected bool $layoutReady = false;
    protected bool $contentOnly = false;
    protected string $content = '';
    /** @var array<string, list<string>> позиция => HTML модулей */
    protected array $positions = [];

    /**
     * Выполняет модули и компонент страницы. Модули с modulePostexec() выполняются после компонента,
     * остальные - до; {position_<имя>} в HTML компонента заменяется модулями позиции
     */
    public function init(): void
    {
        $this->initRequest();

        $component = $this->getComponent();

        $rows = static::moduleRows(static::getModuleQuery()->orderBy('npp, item_id')->all());
        $menuId = (int)(Menu::getCurrent()['menu_id'] ?? 0);
        $rows = array_filter($rows, fn(array $row) => empty($row['menu_id']) || (int)$row['menu_id'] === $menuId);

        $this->executeModules(array_filter($rows, fn(array $row) => !$row['postexec']));

        $this->content = $component->execute();
        if (str_contains($this->content, '{position_')) {
            foreach ($this->positions as $name => $html) {
                $this->content = str_replace('{position_' . $name . '}', implode("\n", $html), $this->content);
            }
        }

        $this->executeModules(array_filter($rows, fn(array $row) => $row['postexec']));
    }

    /**
     * Запрос и ответ в контейнере, SEO страницы; ajax-запрос модуля (sf_module_id) выводит модуль и завершает работу
     */
    public function initRequest(): void
    {
        if (!Container::isSet('request')) {
            Container::set('request', new HtmlRequest());
        }
        if (!Container::isSet('response')) {
            Container::set('response', new HtmlResponse());
        }

        $request = Container::getRequest();
        if (!$request->isAjax()) {
            $row = Seo::findAdv()
                ->asArray()
                ->select(['title', 'description', 'keywords', 'metatags'])
                ->where(['link' => $request->getPath()])
                ->fetchOne();
            if ($row) {
                PageSeo::seo($row['title'], $row['description'], $row['keywords'], true, $row['metatags']);
            }
            return;
        }

        $this->contentOnly = true;
        $moduleId = (int)$request->request('sf_module_id', 0);
        if ($moduleId > 0) {
            $content = $this->getModuleById($moduleId);
            Container::getResponse()->outputHeaders();
            echo $content;
            exit;
        }
    }

    /**
     * Компонент страницы: маршрут из provider/routes.php (ядра, расширений, сайта) или пункт меню сайта
     * с компонентом. Маршрут запоминается в Request::$route
     */
    public function getComponent(): ComponentBase
    {
        $menu = array_filter(Menu::getByLink(), fn(array $item) => !empty($item['class']));
        $route = new Resolver()
            ->setMenu($menu)
            ->resolve(Container::getConfig()->getRoutes());

        Container::getRequest()->route = $route;

        $class = $route->getComponentClassName();
        return new $class(...Injector::resolveClass($class));
    }

    /**
     * Выводит страницу: тему сайта (theme/<тема>/index.tpl, print.tpl для ?print) или, для ajax-запроса,
     * только содержимое компонента
     */
    public function execute(): void
    {
        Container::getResponse()->outputHeaders();
        if ($this->contentOnly) {
            echo $this->getContent();
            return;
        }

        $page = $this;
        $dir = Container::getPaths()->getRoot('theme/' . Container::getConfig()->theme);
        if (Container::getRequest()->get('print') !== null && is_file($dir . '/print.tpl')) {
            include $dir . '/print.tpl';
            return;
        }
        if (is_file($dir . '/index.tpl')) {
            include $dir . '/index.tpl';
        }
    }

    public function getContent(): string
    {
        return $this->content;
    }

    /**
     * HTML модулей позиции
     * @param string $delimiter Разделитель модулей, например '<hr/>'
     */
    public function getPosition(string $name, string $delimiter = ''): string
    {
        return implode($delimiter, $this->positions[$name] ?? []);
    }

    /**
     * HTML активного модуля по id экземпляра (module_item.item_id), для ajax-запросов
     */
    public function getModuleById(int $id): string
    {
        $rows = static::moduleRows(static::getModuleQuery()->andWhere(['item_id' => $id])->all());

        return $rows ? new $rows[0]['class']($rows[0])->execute() : '';
    }

    /**
     * Заголовок, мета-теги и стили страницы для head темы
     */
    public function getMeta(): string
    {
        // стили компонентов собираются здесь, а не при старте: в них попадают и компоненты, нарисованные темой
        // до вывода head
        if (!$this->layoutReady && Container::getLocation()->isWeb()) {
            $this->layoutReady = true;
            LayoutManager::init();
        }

        $html = PageSeo::getHeadHtml() . PageAssets::getCssHtml();
        if (Container::getConfig()->devMode) {
            $html .= Container::get('debugbar')->renderHead();
        }

        return $html;
    }

    /**
     * Скрипты страницы, выводятся в конце body темы
     */
    public function getMetaJs(): string
    {
        $html = PageAssets::getJsHtml();
        if (Container::getConfig()->devMode) {
            $html .= Container::get('debugbar')->render();
        }

        return $html;
    }

    /**
     * Активные экземпляры модулей (module_item)
     */
    protected static function getModuleQuery(): AQ
    {
        return ModuleItem::findAdv()
            ->asArray()
            ->select(['item_id', 'module', 'menu_id', 'posname', 'name', 'params'])
            ->where(['active' => 1]);
    }

    /**
     * Добавляет class и postexec из модулей, объявленных в коде, пропускает записи неизвестных модулей
     */
    protected static function moduleRows(array $rows): array
    {
        $out = [];
        foreach ($rows as $row) {
            $module = ExtensionRegistry::module((string)$row['module']);
            if (!$module) {
                continue;
            }
            $row['class'] = ltrim($row['module'], '\\');
            $row['postexec'] = $module['postexec'];
            $out[] = $row;
        }

        return $out;
    }

    protected function executeModules(array $rows): void
    {
        foreach ($rows as $row) {
            $this->positions[$row['posname']][] = new $row['class']($row)->execute();
        }
    }
}
