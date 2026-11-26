<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputSearch;

use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Поле поиска (Figma Inputs/search): поле ввода с иконкой лупы слева и кнопкой очистки справа.
 * Размеры, стили, темы и положение подписи те же, что у TextInput (его enum'ы). Поле помечено role="searchbox",
 * на мобильных клавиатура показывает кнопку «Найти»
 */
class Layout extends LayoutBase
{
    /**
     * @param string $name Атрибут name поля
     * @param string $id Идентификатор поля; пусто — вычисляется
     * @param array<string,string> $attributes Атрибуты input (required, disabled и т. д.)
     */
    public static function drawInputSearch(
        string            $name = 'q',
        string            $value = '',
        string            $placeholder = 'Поиск',
        string            $labelText = '',
        InputMainLabelPos $labelPos = InputMainLabelPos::Hidden,
        InputMainStyle    $style = InputMainStyle::Filled,
        InputMainSize     $size = InputMainSize::Medium,
        InputMainTheme    $theme = InputMainTheme::Light,
        string            $id = '',
        string            $className = '',
        array             $attributes = [],
    ): string {
        return TextInput::drawInputMain(
            className: trim('search-input ' . $className),
            placeholder: $placeholder,
            labelText: $labelText,
            labelPos: $labelPos,
            style: $style,
            size: $size,
            theme: $theme,
            icon: 'search',
            id: $id,
            attributes: $attributes + [
                'name' => $name,
                'role' => 'searchbox',
                'inputmode' => 'search',
                'enterkeyhint' => 'search',
                'autocomplete' => 'off',
            ],
            value: $value,
        );
    }
}
