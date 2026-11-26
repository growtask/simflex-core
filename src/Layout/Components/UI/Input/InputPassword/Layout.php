<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputPassword;

use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainKind;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Поле пароля с кнопкой «показать» (набор Figma Inputs/password): TextInput вида Password; разметка, стили и скрипт общие с InputMain
 */
class Layout extends LayoutBase
{
    /**
     * @param array<string,string> $attributes Атрибуты input (name, required, disabled и т. д.)
     */
    public static function drawInputPassword(
        string            $placeholder = '',
        string            $labelText = '',
        InputMainLabelPos $labelPos = InputMainLabelPos::Hidden,
        InputMainStyle    $style = InputMainStyle::Filled,
        InputMainSize     $size = InputMainSize::Medium,
        InputMainTheme    $theme = InputMainTheme::Light,
        string            $value = '',
        string            $error = '',
        bool              $success = false,
        string            $id = '',
        array             $attributes = [],
        string            $className = '',
    ): string {
        return TextInput::drawInputMain(
            className: $className,
            placeholder: $placeholder,
            labelText: $labelText,
            labelPos: $labelPos,
            style: $style,
            size: $size,
            theme: $theme,
            id: $id,
            attributes: $attributes,
            kind: InputMainKind::Password,
            value: $value,
            error: $error,
            success: $success,
        );
    }
}
