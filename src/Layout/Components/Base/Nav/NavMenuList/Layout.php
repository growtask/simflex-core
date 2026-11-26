<?php

namespace Simflex\Core\Layout\Components\Base\Nav\NavMenuList;

use Simflex\Core\Layout\LayoutBase;

/**
 * Список пунктов меню (Figma nav/menu-list, design-base-nav.md): вертикальный список вкладок soft s; пункт с
 * подменю — кнопка с aria-expanded, подменю раскрывается на месте (не больше двух уровней), текущая страница —
 * aria-current="page"
 */
class Layout extends LayoutBase
{
    /**
     * @param list<array{
     *     text: string, link?: string, current?: bool, open?: bool,
     *     children?: list<array{text: string, link: string, current?: bool}>
     * }> $items Пункты; текст экранируется; пункт с children — раскрывающийся (open — раскрыт сразу)
     * @return string HTML; пустая строка, если пунктов нет
     */
    public static function drawNavMenuList(
        array            $items,
        NavMenuListTheme $theme = NavMenuListTheme::Light,
        string           $label = 'Меню',
        string           $className = '',
    ): string {
        $items = array_values($items);
        if ($items === []) {
            return '';
        }

        return static::draw(compact('items', 'label', 'className') + ['theme' => $theme->value]);
    }
}
