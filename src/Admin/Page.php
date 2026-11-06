<?php

namespace Simflex\Core\Admin;

use Simflex\Core\Models\AdminWidget;
use Simflex\Core\Admin\Notify\Collection;
use Simflex\Core\Admin\Handlers\Group;
use Simflex\Core\Http\Assets;
use Simflex\Core\Http\View;
use Simflex\Core\Layout\LayoutManager;
use Simflex\Core\Layout\Components\UI\Core\Logo\Layout as LogoLayout;
use Simflex\Core\Layout\Components\UI\Core\Logo\LogoTheme;
use Simflex\Core\Layout\Components\UI\Core\Logo\LogoType;
use Simflex\Core\System\Container;
use Simflex\Core\Http\Html\HtmlRequest;
use Simflex\Core\Http\Html\HtmlResponse;
use Simflex\Core\System\Privilege;

/**
 * Страница админки: обработка запроса к админке.
 *
 * init() - запрос и ответ в контейнере, вход и выход, меню разделов, доступных пользователю, содержимое раздела
 * (Handler пункта меню) и модули админки; execute() - вывод макета админки (theme/tpl/index.tpl), формы входа
 * или отказа в доступе. Объект страницы - в контейнере (Container::getPage(), в коде админки - Page::get()).
 *
 * Адреса админки строятся статическими методами root(), url(), они не зависят от запроса
 */
class Page
{
    /** Cookie с темой админки: light или dark (пишет переключатель темы в меню) */
    public const THEME_COOKIE = 'sf_admin_theme';
    /** Свёрнутость меню на десктопе: «0» — меню раскрыто, иначе (и без cookie) свёрнуто */
    public const MENU_COLLAPSED_COOKIE = 'sf_admin_menu_collapsed';
    public const THEME_LIGHT = 'light';
    public const THEME_DARK = 'dark';

    /** Ajax-запрос: в ответе только содержимое раздела, без макета админки */
    protected bool $ajax = false;
    /** @var list<string> сегменты пути относительно корня админки */
    protected array $uri = [];
    protected string $path = '';
    /** @var array<string, array<string, array>> id родителя => id => пункт меню */
    protected array $menuTree = [];
    /** @var array<string, array> id => пункт меню */
    protected array $menuById = [];
    protected array|false $menuCur = false;
    /** @var list<array{link: string, name: string}> */
    protected array $crumbs = [];

    protected string $content = '';
    /** @var bool Раздел вывел свой page-head (drawPageHead()): макет не выводит заголовок по умолчанию */
    protected bool $pageHeadDrawn = false;
    /** @var array<string, list<string>> позиция => HTML модулей */
    protected array $positions = [];
    /** @var array<string, string> */
    protected array $modules = [];
    /** @var bool Стили админки и компонентов Layout уже собраны (LayoutManager::init()) */
    protected bool $layoutReady = false;
    protected array $css = [];
    /** @var array<string, int> Скрипты-модули (script type="module"): url => приоритет */
    protected array $jsModules = [];
    protected array $cssCheck = [];
    protected array $js = [];
    protected array $jsCheck = [];

    /**
     * Страница админки из контейнера; если её там нет (консоль, тесты) - новая, она же кладётся в контейнер
     */
    public static function get(): static
    {
        $page = Container::getPage();
        if (!$page instanceof static) {
            $page = new static();
            Container::set('page', $page);
        }

        return $page;
    }

    /**
     * Корень админки без завершающего слеша, задаётся в конфиге (adminPath)
     * @return string например /admin
     */
    public static function root(): string
    {
        $path = trim(Container::getConfig()->adminPath, '/');
        if ($path === '') {
            throw new \LogicException('Config adminPath must not be empty');
        }

        return '/' . $path;
    }

    /**
     * Адрес внутри админки
     * @param string $path Путь относительно корня админки, например 'content/'
     * @return string например /admin/content (без завершающего слеша)
     */
    public static function url(string $path = ''): string
    {
        $url = static::root() . '/' . ltrim($path, '/');
        $query = strpos($url, '?');
        $base = $query === false ? $url : substr($url, 0, $query);

        return rtrim($base, '/') . ($query === false ? '' : substr($url, $query));
    }

    /**
     * Относится ли путь запроса к админке
     */
    public static function isAdminPath(string $path): bool
    {
        return $path === static::root() || str_starts_with($path, static::root() . '/');
    }

    /**
     * Url опубликованной статики админки ядра (см. Assets::publish)
     * @return string например /cache/assets/1a2b3c4d5e6f7a8b/Admin
     */
    public static function webVendorPath(): string
    {
        return Assets::publish(Container::getPaths()->getCore()) . '/Admin';
    }

    public static function vendorPath(): string
    {
        return __DIR__;
    }

    public function init(): void
    {
        if (!Container::isSet('request')) {
            Container::set('request', new HtmlRequest());
        }
        if (!Container::isSet('response')) {
            Container::set('response', new HtmlResponse());
        }

        $request = Container::getRequest();
        $this->path = $request->getPath();
        if (strlen($this->path) > 1 && str_ends_with($this->path, '/') && $request->getRequestMethod() === 'GET') {
            // адреса админки без завершающего слеша: /admin/content/ => /admin/content
            $query = (string)parse_url($request->getUri(), PHP_URL_QUERY);
            $query = $query === '' ? '' : '?' . $query;
            header('Location: ' . rtrim($this->path, '/') . $query, true, 301);
            exit;
        }
        $this->path = rtrim($this->path, '/');
        // сегменты пути относительно корня админки: /admin/content/ => ['content', '']
        $this->uri = explode('/', ltrim(substr($this->path, strlen(static::root())), '/'));

        if ($request->isAjax() || !empty($request->get('ajax'))) {
            $this->ajax = true;
        }

        if ($this->getUri(0) === 'login') {
            $login = (array)$request->request('login', []);
            Auth::login(
                $login['login'] ?? null,
                $login['password'] ?? null,
                isset($login['remember']),
                $request->request('r') ?? static::url()
            );
        } elseif ($this->getUri(0) === 'logout') {
            Auth::logout();
        }

        $user = Container::getUser();
        if (!$user || !$user->ican(Privilege::ADMIN)) {
            return;
        }

        $this->initMenu();
        $this->initContent();
    }

    /**
     * Пункты меню, доступные пользователю, текущий пункт и хлебные крошки
     */
    public function initMenu(): void
    {
        $user = Container::getUser();
        foreach (Menu::getItems() as $key => $item) {
            if (!$user?->ican($item->privilege)) {
                continue;
            }
            $row = [
                'id' => $key,
                'pid' => Menu::getParent($key),
                // ссылки объявлены относительно корня админки
                'link' => str_starts_with($item->link, '/') ? static::url($item->link) : rtrim($item->link, '/'),
                'name' => $item->name,
                'handler' => $item->handler,
                'icon' => $item->icon,
                'hidden' => $item->hidden,
            ];
            $this->menuTree[$row['pid']][$key] = $row;
            $this->menuById[$key] = $row;
            if ($row['link'] === $this->path) {
                $this->menuCur = $row;
            }
        }

        if (!$this->ajax && $this->menuCur) {
            $this->setCrumbs($this->menuCur);
        }
    }

    /**
     * Содержимое: виджет (?sfwidget=id) или раздел текущего пункта меню и модули админки
     */
    protected function initContent(): void
    {
        if ($widgetId = (int)Container::getRequest()->get('sfwidget', 0)) {
            $this->content = $this->getWidgetContent($widgetId);
            return;
        }

        $this->content = $this->getHandler((string)$this->getCurrentMenuItem('handler'))->content();

        if (!$this->ajax) {
            foreach (AdminModules::getForSection((string)$this->getCurrentMenuItem('id')) as $module) {
                $mod = new ($module->class)([
                    'item_id' => 0,
                    'class' => $module->class,
                    'name' => $module->name,
                    'posname' => $module->position,
                    'params' => serialize($module->params),
                ]);
                $this->positions[$module->position][] = $mod->execute();
            }
        }
    }

    /**
     * Виджет по запросу ?sfwidget=id (обновление виджета страницы группы): как на странице группы, только активный
     * и только пользователю с его привилегией. Нет такого виджета - 404, нет привилегии - 403, содержимое пустое
     */
    protected function getWidgetContent(int $widgetId): string
    {
        $row = AdminWidget::findAdv()->asArray()->where(['active' => 1, 'widget_id' => $widgetId])->fetchOne();
        if (!is_array($row) || !is_subclass_of((string)$row['class'], WidgetBase::class)) {
            http_response_code(404);
            return '';
        }
        if ($row['privilege'] && !Container::getUser()?->ican($row['privilege'])) {
            http_response_code(403);
            return '';
        }

        $class = $row['class'];
        return new $class($row)->execute();
    }

    /**
     * Обработчик текущего раздела: указанный в его пункте меню, по умолчанию страница группы
     * (подпункты, виджеты)
     */
    protected function getHandler(string $handler): Handler
    {
        return is_subclass_of($handler, Handler::class) ? new $handler() : new Group();
    }

    public function isAjax(): bool
    {
        return $this->ajax;
    }

    /**
     * Сегмент пути относительно корня админки: для /admin/content/ getUri(0) = 'content'
     */
    public function getUri(int $i = 0): string
    {
        return $this->uri[$i] ?? '';
    }

    /**
     * Путь текущего раздела без завершающего слеша, например /admin/content
     */
    public function getPath(): string
    {
        return $this->path;
    }

    /**
     * Пункты меню, доступные пользователю: id родителя ('' для корня) => id => запись
     * (id, pid, link, name, handler, icon, hidden).
     * id — ссылка пункта, как она объявлена в Menu
     */
    public function getMenu(): array
    {
        return $this->menuTree;
    }

    /**
     * Текущий пункт меню (false - не найден) или его поле (null - пункт не найден)
     */
    public function getCurrentMenuItem(?string $field = null): mixed
    {
        if ($field === null) {
            return $this->menuCur;
        }

        return $this->menuCur ? ($this->menuCur[$field] ?? null) : null;
    }

    /**
     * @return list<array{link: string, name: string}>
     */
    public function getCrumbs(): array
    {
        return $this->crumbs;
    }

    protected function setCrumbs(array $item): void
    {
        if (isset($this->menuById[$item['pid']])) {
            $this->setCrumbs($this->menuById[$item['pid']]);
        }
        $this->crumbs[] = ['link' => $item['link'], 'name' => $item['name']];
    }

    /**
     * Выводит макет админки с содержимым раздела, форму входа или отказ в доступе.
     * В шаблонах макета страница - переменная $page
     */
    public function execute(): void
    {
        $page = $this;
        $user = Container::getUser();
        if ($user && !$user->ican(Privilege::ADMIN)) {
            http_response_code(403);
            include __DIR__ . '/theme/tpl/denied.tpl';
        } elseif ($user) {
            if ($this->ajax) {
                echo $this->getContent();
            } else {
                include __DIR__ . '/theme/tpl/index.tpl';
            }
        } else {
            $back = Container::getRequest()->getUri();
            if (str_contains($back, 'logout')) {
                $back = static::url();
            }
            include __DIR__ . '/theme/tpl/login.tpl';
        }
    }

    public function getContent(): string
    {
        return $this->content;
    }

    public function getPosition(string $posname): string
    {
        if (!$posname || empty($this->positions[$posname])) {
            return '';
        }
        return implode('<hr class="module-separator" />', array_filter($this->positions[$posname], 'strlen'));
    }

    public function getModule(string $modname): string
    {
        return $modname ? ($this->modules[$modname] ?? '') : '';
    }

    public function css(string $file, int $idx = 100): void
    {
        $key = md5($file);
        if (empty($this->css[$idx][$key])) {
            if (isset($this->cssCheck[$key])) {
                unset($this->css[$this->cssCheck[$key]][$key]);
                unset($this->cssCheck[$key]);
            }
            $this->cssCheck[$key] = $idx;
            $this->css[$idx][$key] = $file;
        }
    }

    public function js(string $file, int $idx = 100): void
    {
        $key = md5($file);
        if (empty($this->js[$idx][$key])) {
            if (isset($this->jsCheck[$key])) {
                unset($this->js[$this->jsCheck[$key]][$key]);
                unset($this->jsCheck[$key]);
            }
            $this->jsCheck[$key] = $idx;
            $this->js[$idx][$key] = $file;
        }
    }

    /**
     * Стиль из статики админки ядра
     * @param string $file Путь относительно src/Admin ядра, например '/theme/css/table.css'
     */
    public function coreCss(string $file, int $idx = 100): void
    {
        $this->css(static::webVendorPath() . $file, $idx);
    }

    /**
     * Скрипт из статики админки ядра
     * @param string $file Путь относительно src/Admin ядра, например '/Table/js/moduleitem.js'
     */
    public function coreJs(string $file, int $idx = 100): void
    {
        $this->js(static::webVendorPath() . $file, $idx);
    }

    /**
     * Заголовок страницы (локальный компонент макета page-head): хлебные крошки (на телефоне — «Назад»),
     * название h1, «На сайт» и одна главная кнопка. Раздел, который вывел его сам, отменяет заголовок по умолчанию
     * в макете (theme/tpl/body.tpl)
     *
     * @param string $title Название; пусто — название текущего пункта меню
     * @param string $action HTML главной кнопки (Button primary, «Добавить», «Сохранить»)
     * @param list<array{name: string, link?: string}>|null $crumbs Хлебные крошки; null — путь текущего пункта меню
     */
    public function drawPageHead(string $title = '', string $action = '', ?array $crumbs = null): string
    {
        $this->pageHeadDrawn = true;
        $title = $title !== '' ? $title : ((string)$this->getCurrentMenuItem('name') ?: 'Главная');
        // крошки — если в разделе есть модуль позиции breadcrumbs (сайт может убрать его в AdminModules); раздел
        // выводит page-head раньше, чем выполняются модули, поэтому крошки рисуются здесь
        $hasCrumbs = (bool)array_filter(
            AdminModules::getForSection((string)$this->getCurrentMenuItem('id')),
            fn(AdminModule $module) => $module->position === 'breadcrumbs'
        );
        $crumbsHtml = $hasCrumbs ? Modules\Breadcrumbs\Breadcrumbs::draw($crumbs ?? $this->getCrumbs()) : '';

        return View::render(__DIR__ . '/theme/tpl/partial/page-head.tpl', [
            'page' => $this,
            'title' => $title,
            'action' => $action,
            'crumbs' => $crumbs ?? $this->getCrumbs(),
            'crumbsHtml' => $crumbsHtml,
        ]);
    }

    public function isPageHeadDrawn(): bool
    {
        return $this->pageHeadDrawn;
    }

    /**
     * Меню свёрнуто до иконок (72 px): по умолчанию да, раскрытое запоминается в cookie MENU_COLLAPSED_COOKIE
     * (theme/js/menu.js). Сервер сразу выводит меню в нужном виде, без перестройки после загрузки
     */
    public function isMenuCollapsed(): bool
    {
        return Container::getRequest()?->cookie(static::MENU_COLLAPSED_COOKIE) !== '0';
    }

    /**
     * Тема админки из cookie THEME_COOKIE, по умолчанию светлая. Значение совпадает со значением enum темы
     * компонентов Layout (ButtonTheme::from($page->getTheme())) и с атрибутом data-theme на <html>
     */
    public function getTheme(): string
    {
        $theme = Container::getRequest()?->cookie(static::THEME_COOKIE);

        return $theme === static::THEME_DARK ? static::THEME_DARK : static::THEME_LIGHT;
    }

    /**
     * Лого админки из настройки ConfigBase::$adminLogo в текущей теме
     * @param string $className Класс блока лого в месте вывода (topbar__logo, menu__logo, auth__logo)
     * @param string $href Ссылка лого
     * @param bool $isHomeLink true — ссылка на главную админки (подпись «… — главная админки»)
     */
    public function drawLogo(string $className, string $href, bool $isHomeLink = false): string
    {
        $isDark = $this->getTheme() === static::THEME_DARK;
        $logo = Container::getConfig()->adminLogo + ['name' => 'Simflex CMS', 'src' => '', 'srcDark' => ''];
        $siteSrc = $isDark && $logo['srcDark'] !== '' ? $logo['srcDark'] : $logo['src'];
        $src = $siteSrc !== ''
            ? asset($siteSrc, siteOnly: true)
            : asset('img/brand/logo' . ($isDark ? '-dark' : '') . '.svg');

        return LogoLayout::drawLogo(
            className: $className,
            href: $href,
            name: $logo['name'],
            label: $logo['name'] . ($isHomeLink ? ' — главная админки' : ''),
            src: $src,
            type: LogoType::Static,
            theme: $isDark ? LogoTheme::Dark : LogoTheme::Light,
        );
    }

    /**
     * Скрипт-модуль из статики админки ядра (Admin/theme/js): выводится как <script type="module">,
     * модули импортируют друг друга относительными путями
     * @param string $file Путь относительно src/Admin ядра, например '/theme/js/admin.js'
     */
    public function coreJsModule(string $file, int $idx = 100): void
    {
        $this->jsModule(static::webVendorPath() . $file, $idx);
    }

    /**
     * Скрипт-модуль по веб-адресу (например, статика пакета после Http\Assets::publish()): <script type="module">
     */
    public function jsModule(string $url, int $idx = 100): void
    {
        $this->jsModules[$url] = $idx;
    }

    /**
     * Мета-теги, стили и скрипты для head макета админки. Стили админки (Admin/theme/styles) и компонентов Layout
     * собираются здесь: шаблон макета вызывает getMeta() после того, как отрисовал body
     */
    public function getMeta(): string
    {
        if (!$this->layoutReady) {
            $this->layoutReady = true;
            LayoutManager::init();
        }

        $html = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' . "\r\n";

        ksort($this->css);
        foreach ($this->css as $css_arr) {
            foreach ($css_arr as $css) {
                $html .= '<link type="text/css" rel="stylesheet" href="' . $css . '" />' . "\r\n";
            }
        }
        ksort($this->js);
        foreach ($this->js as $js_arr) {
            foreach ($js_arr as $js) {
                $html .= '<script type="text/javascript" src="' . $js . '"></script>' . "\r\n";
            }
        }
        asort($this->jsModules);
        foreach (array_keys($this->jsModules) as $js) {
            $html .= '<script type="module" src="' . $js . '"></script>' . "\r\n";
        }

        if (Container::getConfig()->devMode) {
            $html .= Container::get('debugbar')->renderHead();
        }
        return $html;
    }

    /**
     * @incomplete Подсистема Notify пока не подключена к админке; она будет доработана и использована позже.
     */
    public function getNotifications(): string
    {
        return Collection::getInstance()->content();
    }
}
