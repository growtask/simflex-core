<?php

namespace Simflex\Core\Admin;

use Simflex\Core\System\Privilege;

/**
 * Пункт меню админки, объявленный в коде, см. Menu::init(): группа (без обработчика, с подпунктами) или пункт
 */
readonly class MenuItem
{
    /**
     * @param string $name Название в меню
     * @param string $link Адрес относительно корня админки (/site/menu => /admin/site/menu), ключ пункта.
     *        Ссылка без начального слеша используется как есть
     * @param class-string<\Simflex\Core\Admin\Handler>|'' $handler Обработчик раздела: таблица (Table\Table,
     *        зарегистрированная в Admin/handlers.php) или раздел без таблицы (Handler).
     *        Пусто — группа со списком своих подпунктов
     * @param string $icon ID иконки дизайн-системы из спрайта админки theme/img/icons.svg (renderIcon())
     * @param string $privilege Привилегия, нужная, чтобы видеть пункт, см. \Simflex\Core\System\Privilege
     * @param bool $hidden Не показывается в меню, но раздел доступен по ссылке
     * @param MenuItem[] $children Подпункты группы; у подпунктов своих подпунктов нет (меню двухуровневое)
     */
    public function __construct(
        public string $name,
        public string $link,
        public string $handler = '',
        public string $icon = '',
        public string $privilege = Privilege::ADMIN,
        public bool $hidden = false,
        public array $children = [],
    ) {
        foreach ($children as $child) {
            if ($child->children) {
                throw new \LogicException(
                    "Admin menu: $child->link has children; the menu has groups and items only"
                );
            }
        }
    }
}
