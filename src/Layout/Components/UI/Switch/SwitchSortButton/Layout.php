<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton;

use Simflex\Core\Layout\LayoutBase;

/**
 * Сортировка (Figma Switches/sort-button): кнопка направления (стрелка вверх или вниз), в том числе активная.
 * Заголовок столбца из двух кнопок — SwitchSort; SortDirection — значение aria-sort для th таблицы
 */
class Layout extends LayoutBase
{
    /**
     * @param bool $up Стрелка вверх (по возрастанию), иначе вниз
     * @param string $link Адрес сортировки: с ним выводится ссылка
     * @param string $label Доступное имя кнопки
     * @param array<string,string> $attributes Атрибуты кнопки
     */
    public static function drawSortButton(
        bool            $up,
        string          $label,
        string          $link = '',
        bool            $active = false,
        SortButtonStyle $style = SortButtonStyle::Solid,
        SortButtonSize  $size = SortButtonSize::Small,
        SortButtonTheme $theme = SortButtonTheme::Light,
        string          $className = '',
        array           $attributes = [],
    ): string {
        $icon = $style === SortButtonStyle::Solid
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
