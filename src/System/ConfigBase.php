<?php

namespace Simflex\Core\System;

use Simflex\Core\DB\MySQL;

/**
 * Базовый класс конфигурации
 */
abstract class ConfigBase
{
    /**
     * @var array{
     *     adapter: string,
     *     host: string,
     *     user: string,
     *     password: string,
     *     name: string
     * }
     *     Параметры базы данных
     */
    public array $db = [
        'adapter' => MySQL::class,
        'host' => '127.0.0.1',
        'user' => 'simflex',
        'password' => 'simflex',
        'name' => 'simflex',
    ];

    /**
     * @var array{
     *     transport: string,
     *     host: string,
     *     port: string,
     *     security: string,
     *     username: string,
     *     password: string,
     * } Параметры почты. Значение поля "security" зависит от транспорта, проверьте, что именно ожидает
     * нужный транспорт. Для PHPMailer подходят эти:
     * https://phpmailer.github.io/PHPMailer/classes/PHPMailer-PHPMailer-PHPMailer.html#property_SMTPSecure
     *
     * В поле "transport" указывается класс. Он ОБЯЗАН реализовывать интерфейс Transport.
     */
    public array $mail = [
        'transport' => null,
        'host' => 'localhost',
        'port' => '25',
        'security' => '',
        'username' => '',
        'password' => '',
    ];

    /**
     * @var array{
     *     token: string
     * } Параметры Telegram
     */
    public array $telegram = [
        'token' => '',
    ];

    /**
     * @var string Компонент, загружаемый по умолчанию
     */
    public string $defaultComponent = '\Simflex\Core\Extensions\Content\Content';

    /**
     * @var string Класс, объявляющий привилегии пользователей: \Simflex\Core\System\Privilege или подкласс приложения
     */
    public string $privilegeClass = Privilege::class;

    /**
     * @var string Класс, объявляющий меню админки: \Simflex\Core\Admin\Menu или подкласс приложения
     */
    public string $adminMenuClass = \Simflex\Core\Admin\Menu::class;

    /**
     * @var string Класс, объявляющий модули макета админки: \Simflex\Core\Admin\AdminModules или подкласс приложения
     */
    public string $adminModulesClass = \Simflex\Core\Admin\AdminModules::class;

    /**
     * @var string Привилегия, без которой файловый менеджер админки недоступен (вдобавок к входу в админку,
     *      Privilege::ADMIN); сайт может сузить доступ, например до Privilege::DEV
     */
    public string $fileManagerPrivilege = Privilege::ADMIN;

    /**
     * @var string Тема по умолчанию
     */
    public string $theme = 'default';

    /**
     * @var bool Включить инструменты разработчика
     */
    public bool $devMode = false;

    /**
     * @var bool Включить логирование независимо от инструментов разработчика
     */
    public bool $enableLogging = false;

    /**
     * @var string Префикс URL админки, например /admin. Ссылки меню админки задаются относительно него
     */
    public string $adminPath = '/admin';

    /**
     * @var bool Писать лог еще и в файл в $logPath (по умолчанию лог идет только в stdout)
     */
    public bool $logToFile = false;

    /**
     * @var string Путь к логу, используется при включенном $logToFile; пусто - log/ в корне сайта
     */
    public string $logPath = '';

    /**
     * @var array<string, string> Файлы объявлений сайта (routes, events, services, commands), если они не в
     *      provider/<имя>.php; отсутствующий файл - пустой список
     */
    public array $files = [];

    /**
     * @var array Дополнительные пользовательские данные конфига
     */
    public array $extra = [];

    /**
     * Получение пользовательских данных
     */
    public function __get(string $name): mixed
    {
        return $this->extra[$name] ?? null;
    }

    /**
     * Маршруты расширений и сайта; маршрут сайта с тем же путём главнее
     */
    public function getRoutes(): array
    {
        $routes = [];
        foreach (ExtensionConfig::getAll() as $config) {
            $routes = array_merge($routes, $config->getRoutes());
        }

        return array_merge($routes, $this->includeFile('routes'));
    }

    /**
     * Подписчики событий расширений и сайта: событие => слушатели всех
     */
    public function getEvents(): array
    {
        $lists = array_map(fn(ExtensionConfig $config) => $config->getEvents(), ExtensionConfig::getAll());
        $lists[] = $this->includeFile('events');

        $events = [];
        foreach ($lists as $list) {
            foreach ($list as $event => $listeners) {
                $events[$event] = array_merge($events[$event] ?? [], $listeners);
            }
        }

        return $events;
    }

    /**
     * Сервисы расширений и сайта по окружениям (all, web, api, cli, dev); сервисы сайта загружаются последними
     * и заменяют сервис расширения с тем же именем в контейнере
     */
    public function getServices(): array
    {
        $lists = array_map(fn(ExtensionConfig $config) => $config->getServices(), ExtensionConfig::getAll());
        $lists[] = $this->includeFile('services');

        $services = [];
        foreach ($lists as $list) {
            foreach ($list as $group => $classes) {
                $services[$group] = array_values(array_unique(array_merge($services[$group] ?? [], $classes)));
            }
        }

        return $services;
    }

    /**
     * Консольные команды ядра, расширений и сайта; провайдер сайта с тем же именем главнее
     */
    public function getCommands(): array
    {
        $commands = [
            'migrate' => \Simflex\Core\DB\Cli\Migrator::class,
            'layout' => \Simflex\Core\Layout\ConsoleLayout::class,
            'cron' => \Simflex\Core\Cron\ConsoleCron::class,
        ];
        foreach (ExtensionConfig::getAll() as $config) {
            $commands = array_merge($commands, $config->getCommands());
        }

        return array_merge($commands, $this->includeFile('commands'));
    }

    /**
     * Список из файла объявлений сайта ($files), пустой, если файла нет
     */
    /**
     * Путь к логу: $logPath или log/ в корне сайта
     */
    public function getLogPath(): string
    {
        return $this->logPath ?: Container::getPaths()->getRoot('log');
    }

    protected function includeFile(string $name): array
    {
        $file = $this->files[$name] ?? Container::getPaths()->getRoot("provider/$name.php");
        return is_file($file) ? (array)include $file : [];
    }

    /**
     * Загружает данные конфига
     */
    abstract public function load(): void;
}
