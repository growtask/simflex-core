<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputDate;

use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputKind;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Поле даты с календарём (набор Figma Inputs/date): TextInput вида Date, календарь раскрывается под полем; разметка и стили общие с InputMain
 */
class Layout extends LayoutBase
{
    /**
     * @param array<string,string> $attributes Атрибуты input (name, required, disabled и т. д.)
     */
    public static function drawInputDate(
        string            $placeholder = '',
        string            $labelText = '',
        TextInputLabelPos $labelPos = TextInputLabelPos::Hidden,
        TextInputStyle    $style = TextInputStyle::Filled,
        TextInputSize     $size = TextInputSize::Medium,
        TextInputTheme    $theme = TextInputTheme::Light,
        string            $value = '',
        string            $error = '',
        bool              $success = false,
        string            $id = '',
        array             $attributes = [],
        string            $className = '',
    ): string {
        return TextInput::drawInput(
            className: $className,
            placeholder: $placeholder,
            labelText: $labelText,
            labelPos: $labelPos,
            style: $style,
            size: $size,
            theme: $theme,
            id: $id,
            attributes: $attributes,
            kind: TextInputKind::Date,
            value: $value,
            error: $error,
            success: $success,
        );
    }
}
