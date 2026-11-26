<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputEmail;

use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputKind;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Поле почты (набор Figma Inputs/email): TextInput вида Email; формат проверяется при потере фокуса; разметка и стили общие с InputMain
 */
class Layout extends LayoutBase
{
    /**
     * @param array<string,string> $attributes Атрибуты input (name, required, disabled и т. д.)
     */
    public static function drawInputEmail(
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
            kind: TextInputKind::Email,
            value: $value,
            error: $error,
            success: $success,
        );
    }
}
