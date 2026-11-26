<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputEye;

use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;
use Simflex\Core\Layout\LayoutBase;

/**
 * Кнопка «глаз» поля пароля (набор Figma Inputs/eye): показывает или скрывает введённые символы. Это ButtonIconSmall
 * с aria-pressed; внутри поля пароля её ставит InputMain (видом Password)
 */
class Layout extends LayoutBase
{
    /**
     * @param bool $active Пароль показан (aria-pressed)
     */
    public static function drawInputEye(
        bool            $active = false,
        bool            $disabled = false,
        ButtonIconTheme $theme = ButtonIconTheme::Light,
        string          $className = '',
    ): string {
        return ButtonIcon::drawButtonIcon(
            icon: 'eye',
            label: $active ? 'Скрыть пароль' : 'Показать пароль',
            className: trim('text-input__password-toggle ' . $className),
            style: ButtonIconStyle::Flat,
            theme: $theme,
            attributes: ['aria-pressed' => $active ? 'true' : 'false', 'title' => ''],
            disabled: $disabled,
        );
    }
}
