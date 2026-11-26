<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchSort;

use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\Layout as SortButton;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SwitchSortButtonStyle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SwitchSortButtonTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Переключатель направления сортировки (набор Figma Switches/sort): название и две кнопки SwitchSortButton друг над другом. Атрибут aria-sort ставится на th таблицы: значение — SwitchSortDirection::value
 */
class Layout extends LayoutBase
{
    /**
     * Заголовок столбца с сортировкой: название и кнопки «по возрастанию» и «по убыванию»
     * @param string $text Название столбца (экранируется)
     * @param string $linkAscending Адрес сортировки по возрастанию
     * @param string $linkDescending Адрес сортировки по убыванию
     */
    public static function drawSwitchSort(
        string          $text,
        string          $linkAscending,
        string          $linkDescending,
        SwitchSortDirection   $direction = SwitchSortDirection::None,
        SwitchSortButtonStyle $style = SwitchSortButtonStyle::Solid,
        SwitchSortButtonTheme $theme = SwitchSortButtonTheme::Light,
        string          $className = '',
    ): string {
        $buttons = SortButton::drawSwitchSortButton(
            true,
            "$text: по возрастанию",
            $linkAscending,
            $direction === SwitchSortDirection::Ascending,
            $style,
            theme: $theme,
        ) . SortButton::drawSwitchSortButton(
            false,
            "$text: по убыванию",
            $linkDescending,
            $direction === SwitchSortDirection::Descending,
            $style,
            theme: $theme,
        );

        return static::draw(compact('text', 'buttons', 'className') + [
            'theme' => $theme->value,
            'direction' => $direction->value,
        ]);
    }
}
