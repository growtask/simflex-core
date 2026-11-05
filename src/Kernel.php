<?php

namespace Simflex\Core;

use Dotenv\Dotenv;
use Simflex\Core\Admin\Page as AdminPage;
use Simflex\Core\Auth\Auth\BasicAuthMiddleware;
use Simflex\Core\Auth\Auth\Chain;
use Simflex\Core\Auth\Auth\CookieMiddleware;
use Simflex\Core\Auth\Auth\SessionMiddleware;
use Simflex\Core\Auth\Bootstrap;
use Simflex\Core\System\ConfigBase;
use Simflex\Core\Console\Cli;
use Simflex\Core\System\Container;
use Simflex\Core\System\Events\Event;
use Simflex\Core\System\Events\Events;
use Simflex\Core\Logger\Log;
use Simflex\Core\Logger\FileLogger;
use Simflex\Core\Logger\StdLogger;
use Simflex\Core\Http\Html\HtmlRequest;
use Simflex\Core\Http\Page;
use Simflex\Core\System\Location;
use Simflex\Core\System\Paths;
use Simflex\Core\System\Settings;

/**
 * Ядро (kernel): загрузка и запуск сайта.
 *
 * Точки входа сайта подключают автозагрузчик composer, создают ядро с корнем сайта и вызывают один метод:
 * public/index.php - new Kernel(dirname(__DIR__))->runHttp(), консоль ./sf - exit(new Kernel(__DIR__)->runConsole()).
 * Пути (корень сайта, public/, ядро) - Container::getPaths(), окружение (сайт, админка, API, консоль) -
 * Container::getLocation().
 *
 * Загрузка (init()): конфиг сайта (config.php, .env), настройки PHP, сервисы, события, логгер, авторизация
 * и страница. Каждый этап окружён событиями Events::Pre* / Post* (provider/events.php): чтобы дополнить загрузку,
 * подпишитесь на событие, а не переопределяйте класс
 */
class Kernel
{
    protected ConfigBase $cfg;

    /**
     * @param string $root Корень сайта
     */
    public function __construct(string $root)
    {
        Container::set('paths', new Paths($root));

        // функции сайта
        if (is_file($file = Container::getPaths()->getRoot('functions.php'))) {
            require_once $file;
        }
    }

    /**
     * Обрабатывает HTTP-запрос: сайт, админку (адрес - конфиг adminPath) или API файлового менеджера админки
     */
    public function runHttp(): void
    {
        Container::set('request', new HtmlRequest());
        $path = Container::getRequest()->getPath();

        if (!$this->isAdminPath($path)) {
            $this->init(Location::Site);
            echo $this->prepareOutput($this->execute(true));
            return;
        }

        $this->init(Location::Admin);
        if ($path === AdminPage::url('fm')) {
            $this->executeFileManager();
        } else {
            $this->execute(false);
        }
    }

    /**
     * Выполняет консольную команду из аргументов командной строки: ./sf provider/method [args]
     * @return int Код завершения процесса (Cli::SUCCESS, Cli::FAILURE): ./sf передаёт его в exit()
     */
    public function runConsole(): int
    {
        $this->init(Location::Cli);
        return Cli::run(Container::getRequest());
    }

    /**
     * Относится ли путь запроса к админке (её URL-префикс задан в конфиге: adminPath)
     */
    public function isAdminPath(string $path): bool
    {
        $this->initConfig();
        return AdminPage::isAdminPath($path);
    }

    /**
     * Загружает приложение
     * @param Location $location Где выполняется код, см. Container::getLocation()
     */
    public function init(Location $location): void
    {
        Container::set('location', $location);

        // базовая инициализация
        $this->initConfig();
        $this->initPhp();

        if ($location === Location::Cli) {
            $this->initPhpCli();
        }

        $this->initExceptionHandler();
        $this->initServices();
        $this->initEvents();
        $this->initLogger();

        Log::debug('Simflex Framework v' . getSimflexVersion());

        // подсистемы ядра
        $this->initAuth();
        $this->initPage();

        $ev = Container::getEvents();
        $ev->dispatch(new Event(Events::PreInit, static::class));

        if ($location->isWeb()) {
            Container::getPage()->init();
        }

        $ev->dispatch(new Event(Events::PostInit, static::class));
    }

    /**
     * Выполняет приложение: выводит страницу темы сайта или админки
     * @param bool $asString Вернуть вывод строкой, иначе - отправить в браузер
     * @return string|null Содержимое страницы или null, если $asString равен false
     */
    public function execute(bool $asString): ?string
    {
        if ($asString) {
            ob_start();
        }

        $ev = Container::getEvents();
        $ev->dispatch(new Event(Events::PreExecute, static::class));

        Container::getPage()->execute();

        $ev->dispatch(new Event(Events::PostExecute, static::class));
        return $asString ? ob_get_clean() : null;
    }

    /**
     * Обрабатывает запрос к API файлового менеджера админки. Доступ - canUseFileManager()
     */
    public function executeFileManager(): void
    {
        $mgr = new \Simflex\FileManager\Manager(Container::getPaths()->getPublic('uf'), $this->canUseFileManager(...));

        $mgr->handleRequest();
    }

    /**
     * Может ли текущий пользователь работать с файловым менеджером: пользователь админки (Privilege::ADMIN)
     * с привилегией из конфига fileManagerPrivilege
     */
    public function canUseFileManager(): bool
    {
        $user = Container::getUser();
        return $user !== null
            && $user->ican(\Simflex\Core\System\Privilege::ADMIN)
            && $user->ican(Container::getConfig()->fileManagerPrivilege);
    }

    /**
     * Готовит страницу сайта к выводу: подставляет настройки сайта ({имя} -> значение, {year} - текущий год),
     * в рабочем режиме сжимает HTML
     */
    public function prepareOutput(string $data): string
    {
        $ev = Container::getEvents();
        $ev->dispatch(new Event(Events::PrePrepareOutput, static::class, $data));

        $params = Settings::getAll();
        $params = is_array($params) ? $params : [];
        $params['year'] = date('Y');

        $data = str_replace(
            array_map(fn(int|string $key) => '{' . $key . '}', array_keys($params)),
            array_map('strval', array_values($params)),
            $data
        );

        if (!$this->cfg->devMode) {
            $data = preg_replace([
                '/>[^\S ]+/', // убираем пробельные символы после тегов, кроме пробела
                '/[^\S ]+</', // убираем пробельные символы перед тегами, кроме пробела
                '/(\s)+/', // сокращаем повторяющиеся пробельные символы
                '/<!--(.|\s)*?-->/', // убираем HTML-комментарии
            ], [
                '>',
                '<',
                '\\1',
                '',
            ], $data);
        }

        $ev->dispatch(new Event(Events::PostPrepareOutput, static::class, $data));
        return $data;
    }

    /**
     * Механизмы авторизации: сессия, cookie, Basic Auth - по очереди, при первом обращении к пользователю
     */
    protected function initAuth(): void
    {
        $ev = Container::getEvents();
        $ev->dispatch(new Event(Events::PreAuthInit, static::class));

        Container::setAuthHandler(function () {
            Bootstrap::authByMiddlewareChain(
                new Chain([
                    new SessionMiddleware(),
                    new CookieMiddleware(),
                    new BasicAuthMiddleware(),
                ])
            );
        });

        $ev->dispatch(new Event(Events::PostAuthInit, static::class));
    }

    /**
     * Страница: сайта или админки. В консоли не создаётся
     */
    protected function initPage(): void
    {
        $ev = Container::getEvents();
        $ev->dispatch(new Event(Events::PrePageInit, static::class));

        $location = Container::getLocation();
        if ($location === Location::Admin) {
            Container::set('page', new AdminPage());
        } elseif ($location === Location::Site || $location === Location::Api) {
            Container::set('page', new Page());
        }

        $ev->dispatch(new Event(Events::PostPageInit, static::class));
    }

    /**
     * Конфиг сайта: .env и класс App\Config из config.php
     */
    protected function initConfig(): void
    {
        if (isset($this->cfg)) {
            return;
        }

        $paths = Container::getPaths();
        Dotenv::createImmutable($paths->getRoot())->safeLoad();

        require_once $paths->getRoot('config.php');
        $this->cfg = new \App\Config();
        $this->cfg->load();

        Container::set('config', $this->cfg);
    }

    protected function initExceptionHandler(): void
    {
        // в режиме разработчика ошибки ловит whoops
        if ($this->cfg->devMode) {
            return;
        }

        set_exception_handler(function (\Throwable $ex) {
            Log::emergency("Exception: {ex}\n\nStack trace: {st}", [
                'ex' => $ex->getMessage(),
                'st' => $ex->getTraceAsString(),
            ]);
        });
    }

    protected function initPhp(): void
    {
        date_default_timezone_set($this->cfg->timezone);
        ini_set('default_charset', 'UTF-8');
        // Вне режима разработчика ошибки PHP не выводятся в страницу (пути, устаревший код библиотек),
        // а пишутся в журнал PHP; консоль включает вывод в initPhpCli()
        ini_set('display_errors', $this->cfg->devMode ? '1' : '0');
        ini_set('log_errors', '1');
    }

    protected function initPhpCli(): void
    {
        ini_set('display_errors', 1);
        ini_set('max_execution_time', 600);
        error_reporting(E_ALL & ~E_NOTICE & ~E_DEPRECATED);
    }

    /**
     * Сервисы ядра, расширений и сайта (provider/services.php): общие (all) и для текущего окружения
     */
    protected function initServices(): void
    {
        $services = $this->cfg->getServices();
        $toLoad = $services['all'] ?? [];

        $groups = match (Container::getLocation()) {
            Location::Admin, Location::Site => ['web'],
            Location::Api => ['api'],
            Location::Cli => ['cli'],
        };
        if ($this->cfg->devMode) {
            $groups[] = 'dev';
        }
        foreach ($groups as $group) {
            $toLoad = array_merge($toLoad, $services[$group] ?? []);
        }

        foreach ($toLoad as $service) {
            Container::set($service::getServiceName(), new $service());
        }
    }

    protected function initEvents(): void
    {
        Container::getEvents()->subscribeAll($this->cfg->getEvents());
    }

    /**
     * Логгер: DebugBar в режиме разработчика, stdout, файл (конфиг logToFile)
     */
    protected function initLogger(): void
    {
        $ev = Container::getEvents();
        $ev->dispatch(new Event(Events::PreLoggerInit, static::class));

        if (!$this->cfg->devMode && !$this->cfg->enableLogging) {
            return;
        }

        if ($this->cfg->devMode) {
            Log::addLogger(Container::get('debugbar')->getMessages());
        }

        Log::addLogger(new StdLogger());

        if ($this->cfg->logToFile) {
            Log::addLogger(new FileLogger());
        }

        $ev->dispatch(new Event(Events::PostLoggerInit, static::class));
    }
}
