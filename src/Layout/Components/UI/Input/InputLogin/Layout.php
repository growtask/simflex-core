<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputLogin;

use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Поле логина (Figma Inputs/login): поле ввода с иконкой пользователя слева и кнопкой очистки справа.
 * Размеры, стили, темы и положение подписи те же, что у TextInput (его enum'ы), состояния — ошибка и успех
 */
class Layout extends LayoutBase
{
    /**
     * @param string $name Атрибут name поля
     * @param string $error Текст ошибки под полем
     * @param string $id Идентификатор поля; пусто — вычисляется
     * @param array<string,string> $attributes Атрибуты input (required, disabled и т. д.)
     */
    public static function drawInputLogin(
        string            $name = 'login',
        string            $value = '',
        string            $placeholder = 'Логин',
        string            $labelText = '',
        InputMainLabelPos $labelPos = InputMainLabelPos::Hidden,
        InputMainStyle    $style = InputMainStyle::Filled,
        InputMainSize     $size = InputMainSize::Medium,
        InputMainTheme    $theme = InputMainTheme::Light,
        string            $error = '',
        bool              $success = false,
        string            $id = '',
        string            $className = '',
        array             $attributes = [],
    ): string {
        return TextInput::drawInputMain(
            className: trim('login-input ' . $className),
            placeholder: $placeholder,
            labelText: $labelText,
            labelPos: $labelPos,
            style: $style,
            size: $size,
            theme: $theme,
            icon: 'user',
            id: $id,
            attributes: $attributes + [
                'name' => $name,
                'autocomplete' => 'username',
                'autocapitalize' => 'off',
                'spellcheck' => 'false',
            ],
            value: $value,
            error: $error,
            success: $success,
        );
    }
}
