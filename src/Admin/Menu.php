<?php

namespace Simflex\Core\Admin;

use Simflex\Core\System\CodeRegistry;
use Simflex\Core\System\Container;
use Simflex\Core\System\ExtensionConfig;
use Simflex\Core\System\Privilege;

/**
 * Меню админки, объявленное в коде. Пункт определяется своей ссылкой.
 *
 * Приложение добавляет свои разделы в подклассе, указанном в конфиге (adminMenuClass): init() с вызовом
 * parent::init() и add() / remove(). Пункты идут в порядке добавления, add(..., before: link) ставит пункт
 * перед другим.
 */
class Menu extends CodeRegistry
{
    /** @var array<string, MenuItem>|null ссылка => пункт, подпункты в $parents */
    private static ?array $items = null;

    /** @var array<string, string> ссылка => ссылка родителя, '' для корневых пунктов */
    private static array $parents = [];

    /**
     * Объявляет разделы ядра. Подкласс приложения вызывает parent::init() и добавляет или удаляет свои
     */
    protected static function init(): void
    {
        static::add(new MenuItem('Аккаунт', '/account', handler: Handlers\Account::class, icon: 'user', hidden: true));
        // витрина компонентов для сверки с макетами: только в режиме разработки
        if (Container::getConfig()->devMode ?? false) {
            static::add(
                new MenuItem('Витрина UI', '/ui', handler: Handlers\Ui::class, privilege: Privilege::DEV, hidden: true)
            );
        }

        static::add(new MenuItem('Управление', '/admin', icon: 'home', privilege: Privilege::DEV, children: [
            new MenuItem('Привилегии', '/admin/privilege', handler: Handlers\Privilege::class, icon: 'lock-on'),
            new MenuItem('Роли', '/admin/role', handler: Handlers\UserRole::class, icon: 'users'),
            new MenuItem(
                'Привилегии ролей',
                '/admin/role_privilege',
                handler: Handlers\UserRolePrivilege::class,
                icon: 'shield-check',
                privilege: Privilege::DEV,
            ),
            new MenuItem('Пользователи', '/admin/user', handler: Handlers\User::class, icon: 'user'),
            new MenuItem(
                'Персональные привилегии',
                '/admin/privilege_personal',
                handler: Handlers\UserPrivilegePersonal::class,
                icon: 'fingerprint',
                privilege: Privilege::DEV,
            ),
            new MenuItem('Cron', '/cron', handler: Handlers\Cron::class, icon: 'calendar'),
        ]));

        static::add(new MenuItem('Настройки сайта', '/site', icon: 'setting', children: [
            new MenuItem('Меню', '/site/menu', handler: Handlers\Menu::class, icon: 'layout-list'),
            new MenuItem('Модули', '/site/module', handler: Handlers\ModuleItem::class, icon: 'puzzle'),
            new MenuItem('Настройки', '/site/settings', handler: Handlers\Settings::class, icon: 'setting'),
            new MenuItem('SEO', '/site/seo', handler: Handlers\Seo::class, icon: 'trending-up'),
        ]));

        static::add(new MenuItem('Контент', '/content', icon: 'notepad-text', children: [
            new MenuItem('Редактор страниц', '/content/page', handler: Handlers\Content::class, icon: 'layout-template'),
        ]));

        // пункты расширений; сайт может переставить, заменить или убрать их в своём наследнике после parent::init()
        foreach (ExtensionConfig::getAll() as $config) {
            foreach ($config->getAdminMenu() as $item) {
                static::add($item);
            }
        }
    }

    /**
     * Добавляет пункт с подпунктами. Пункт с той же ссылкой заменяется. Меню двухуровневое: группа и её пункты,
     * пункт третьего уровня - исключение
     *
     * @param string $parent Ссылка родительского пункта, '' для корневого
     * @param string|null $before Ссылка соседнего пункта, перед которым поставить пункт, null — после остальных
     */
    protected static function add(MenuItem $item, string $parent = '', ?string $before = null): void
    {
        if ($parent !== '' && !isset(self::$items[$parent])) {
            throw new \LogicException("Admin menu: no parent item $parent for $item->link");
        }
        if ($parent !== '' && self::$parents[$parent] !== '') {
            throw new \LogicException(
                "Admin menu: $item->link is on the third level (parent $parent); the menu has groups and items only"
            );
        }

        if ($before !== null && isset(self::$items[$before])) {
            unset(self::$items[$item->link]);
            $items = [];
            foreach (self::$items as $link => $existing) {
                if ($link === $before) {
                    $items[$item->link] = $item;
                }
                $items[$link] = $existing;
            }
            self::$items = $items;
        } else {
            self::$items[$item->link] = $item;
        }
        self::$parents[$item->link] = $parent;

        foreach ($item->children as $child) {
            static::add($child, $item->link);
        }
    }

    /**
     * Задаёт пункту другой обработчик, остальное в пункте не меняется: например, подкласс раздела ядра
     * из приложения
     *
     * @param class-string<Handler> $handler
     */
    protected static function setHandler(string $link, string $handler): void
    {
        $item = self::$items[$link] ?? throw new \LogicException("Admin menu: no item $link");
        self::$items[$link] = new MenuItem(
            $item->name,
            $item->link,
            $handler,
            $item->icon,
            $item->privilege,
            $item->hidden,
        );
    }

    /**
     * Удаляет пункт с подпунктами
     */
    protected static function remove(string $link): void
    {
        foreach (array_keys(self::$parents, $link, true) as $child) {
            static::remove($child);
        }
        unset(self::$items[$link], self::$parents[$link]);
    }

    /**
     * @return array<string, MenuItem> ссылка => пункт, ядра и приложения, по порядку
     */
    public static function getItems(): array
    {
        if (self::$items === null) {
            self::$items = self::$parents = [];
            $class = static::registryClass();
            $class::init();
        }

        return self::$items;
    }

    /**
     * Ссылка родительского пункта, '' для корневого
     */
    public static function getParent(string $link): string
    {
        static::getItems();
        return self::$parents[$link] ?? '';
    }

    protected static function configProperty(): string
    {
        return 'adminMenuClass';
    }

    public static function reset(): void
    {
        self::$items = null;
        self::$parents = [];
    }
}
