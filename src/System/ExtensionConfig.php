<?php

namespace Simflex\Core\System;

use Simflex\Core\Admin\HeadSlot;
use Simflex\Core\Admin\Handler;
use Simflex\Core\Admin\MenuItem;
use Simflex\Core\Cron\CronJob;

/**
 * Настройки расширения (composer-пакета Simflex): файл `provider/extensions/<имя>.php` сайта возвращает
 * объект-наследник. Установщик пакетов копирует этот файл из `src/provider/extensions` пакета.
 *
 * Расширение объявляет маршруты, события, сервисы, консольные команды, а также свои компоненты, модули, задачи cron,
 * разделы админки, пункты меню админки и привилегии. Ядро объединяет их с объявлениями сайта; сайт главнее:
 * его наследник класса расширения заменяет сам класс (компонент, модуль, раздел), задача cron с тем же ключом —
 * задачу расширения, а пункты меню и привилегии он меняет в своих `Menu` и `Privilege`.
 */
abstract class ExtensionConfig
{
    public string $name;
    public int $loadOrder;

    protected array $routes = [];
    protected array $services = [];
    protected array $events = [];
    protected array $commands = [];

    /** @var list<class-string<ComponentBase>> компоненты, как в provider/components.php сайта */
    protected array $components = [];

    /** @var list<class-string<ModuleBase>> модули, как в provider/modules.php сайта */
    protected array $modules = [];

    /** @var list<class-string<Handler>> разделы админки, как в Admin/handlers.php сайта */
    protected array $adminHandlers = [];

    /** @var list<class-string<HeadSlot>> слоты верхней части админки (page-head и topbar) */
    protected array $adminHeadSlots = [];

    /** @var list<self>|null загруженные расширения сайта */
    private static ?array $all = null;

    public function getRoutes(): array
    {
        return $this->routes;
    }

    public function getServices(): array
    {
        return $this->services;
    }

    public function getEvents(): array
    {
        return $this->events;
    }

    public function getCommands(): array
    {
        return $this->commands;
    }

    /**
     * @return list<class-string<ComponentBase>>
     */
    public function getComponents(): array
    {
        return $this->components;
    }

    /**
     * @return list<class-string<ModuleBase>>
     */
    public function getModules(): array
    {
        return $this->modules;
    }

    /**
     * @return list<class-string<Handler>>
     */
    public function getAdminHandlers(): array
    {
        return $this->adminHandlers;
    }

    /**
     * @return list<class-string<HeadSlot>>
     */
    public function getAdminHeadSlots(): array
    {
        return $this->adminHeadSlots;
    }

    /**
     * Задачи cron, как в provider/cron.php сайта
     *
     * @return array<string, CronJob> ключ задачи => задача
     */
    public function getCronJobs(): array
    {
        return [];
    }

    /**
     * Привилегии расширения: добавляются в реестр после привилегий ядра
     *
     * @return array<string, PrivilegeParams> имя => параметры
     */
    public function getPrivileges(): array
    {
        return [];
    }

    /**
     * Пункты меню админки: добавляются в корень меню после пунктов ядра, с подпунктами
     *
     * @return list<MenuItem>
     */
    public function getAdminMenu(): array
    {
        return [];
    }

    /**
     * Расширения сайта (provider/extensions/*.php) в порядке загрузки (loadOrder)
     *
     * @return list<self>
     */
    public static function getAll(): array
    {
        if (self::$all === null) {
            $configs = [];
            foreach (glob(Container::getPaths()->getRoot('provider/extensions/*.php')) ?: [] as $file) {
                $config = include $file;
                if ($config instanceof self) {
                    $configs[] = $config;
                }
            }
            self::$all = static::sort($configs);
        }

        return self::$all;
    }

    /**
     * Сбрасывает загруженные расширения; с аргументом — подменяет их (тесты)
     *
     * @param list<self>|null $configs
     */
    public static function reset(?array $configs = null): void
    {
        self::$all = $configs === null ? null : static::sort($configs);
    }

    /**
     * Классы расширений и сайта одного реестра: класс расширения, который сайт расширил наследником, заменяется им
     *
     * @param list<string> $extension классы из расширений
     * @param list<string> $app классы сайта
     * @return list<string>
     */
    public static function mergeClasses(array $extension, array $app): array
    {
        $extension = array_filter($extension, function (string $class) use ($app) {
            foreach ($app as $appClass) {
                if (is_subclass_of($appClass, $class)) {
                    return false;
                }
            }
            return true;
        });

        return array_values(array_unique(array_merge($extension, $app)));
    }

    /**
     * @param list<self> $configs
     * @return list<self>
     */
    private static function sort(array $configs): array
    {
        usort($configs, fn(self $a, self $b) => ($a->loadOrder ?? 0) <=> ($b->loadOrder ?? 0));
        return $configs;
    }
}
