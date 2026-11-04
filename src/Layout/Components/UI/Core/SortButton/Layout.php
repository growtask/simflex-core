<?php

namespace Simflex\Core\Layout\Components\UI\Core\SortButton;

use Simflex\Core\Layout\LayoutBase;

/**
 * Сортировка (Figma Switches/sort-button и Switches/sort, design-ui-switches.md): кнопка направления (стрелка
 * вверх или вниз) и заголовок столбца — название и две кнопки друг над другом. Атрибут aria-sort ставится
 * на th таблицы: значение — SortDirection::value
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

        return static::draw(['view' => 'button'] + $data + [
            'style' => $style->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }

    /**
     * Заголовок столбца с сортировкой: название и кнопки «по возрастанию» и «по убыванию»
     * @param string $text Название столбца (экранируется)
     * @param string $linkAscending Адрес сортировки по возрастанию
     * @param string $linkDescending Адрес сортировки по убыванию
     */
    public static function drawSort(
        string          $text,
        string          $linkAscending,
        string          $linkDescending,
        SortDirection   $direction = SortDirection::None,
        SortButtonStyle $style = SortButtonStyle::Solid,
        SortButtonTheme $theme = SortButtonTheme::Light,
        string          $className = '',
    ): string {
        $buttons = static::drawSortButton(
            true,
            "$text: по возрастанию",
            $linkAscending,
            $direction === SortDirection::Ascending,
            $style,
            theme: $theme,
        ) . static::drawSortButton(
            false,
            "$text: по убыванию",
            $linkDescending,
            $direction === SortDirection::Descending,
            $style,
            theme: $theme,
        );

        return static::draw(['view' => 'sort'] + compact('text', 'buttons', 'className') + [
            'theme' => $theme->value,
            'direction' => $direction->value,
        ]);
    }
}
