<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton;

use Simflex\Core\Layout\LayoutBase;

/**
 * Сортировка (Figma Switches/sort-button): кнопка направления (стрелка вверх или вниз), в том числе активная.
 * Заголовок столбца из двух кнопок — SwitchSort; SwitchSortDirection — значение aria-sort для th таблицы
 */
class Layout extends LayoutBase
{
    /**
     * @param bool $up Стрелка вверх (по возрастанию), иначе вниз
     * @param string $link Адрес сортировки: с ним выводится ссылка
     * @param string $label Доступное имя кнопки
     * @param array<string,string> $attributes Атрибуты кнопки
     */
    public static function drawSwitchSortButton(
        bool            $up,
        string          $label,
        string          $link = '',
        bool            $active = false,
        SwitchSortButtonStyle $style = SwitchSortButtonStyle::Solid,
        SwitchSortButtonSize  $size = SwitchSortButtonSize::Small,
        SwitchSortButtonTheme $theme = SwitchSortButtonTheme::Light,
        string          $className = '',
        array           $attributes = [],
    ): string {
        $icon = $style === SwitchSortButtonStyle::Solid
            ? ($up ? 'triangle-up' : 'triangle-down')
            : ($up ? 'chevron-s-up' : 'chevron-s-down');

        $data = compact('label', 'link', 'active', 'icon', 'className', 'attributes');

        return static::draw($data + [
            'style' => $style->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}
