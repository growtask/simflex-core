<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchSort;

use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\Layout as SortButton;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SortButtonStyle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SortButtonTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Переключатель направления сортировки (набор Figma Switches/sort): название и две кнопки SwitchSortButton друг над другом. Атрибут aria-sort ставится на th таблицы: значение — SortDirection::value
 */
class Layout extends LayoutBase
{
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
        $buttons = SortButton::drawSortButton(
            true,
            "$text: по возрастанию",
            $linkAscending,
            $direction === SortDirection::Ascending,
            $style,
            theme: $theme,
        ) . SortButton::drawSortButton(
            false,
            "$text: по убыванию",
            $linkDescending,
            $direction === SortDirection::Descending,
            $style,
            theme: $theme,
        );

        return static::draw(compact('text', 'buttons', 'className') + [
            'theme' => $theme->value,
            'direction' => $direction->value,
        ]);
    }
}
