<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchToggle;

use Simflex\Core\Layout\LayoutBase;

/**
 * Переключатель (набор Figma Switches/toggle): включает настройку сразу, без кнопки «Сохранить»;
 * input type="checkbox" role="switch" с подписью.
 */
class Layout extends LayoutBase
{
    /**
     * @param string              $className Дополнительные CSS-классы
     * @param string              $text Подпись (HTML)
     * @param bool                $icon Галочка на бегунке
     * @param SwitchToggleSize          $size Размер
     * @param SwitchToggleTheme         $theme Тема
     * @param SwitchTogglePosition      $position Переключатель слева или справа от подписи
     * @param array<string,mixed> $attributes Атрибуты input: name, value, checked, disabled
     */
    public static function drawSwitchToggle(
        string         $className = '',
        string         $text = '',
        bool           $icon = true,
        SwitchToggleSize     $size = SwitchToggleSize::Medium,
        SwitchToggleTheme    $theme = SwitchToggleTheme::Light,
        SwitchTogglePosition $position = SwitchTogglePosition::Left,
        array          $attributes = []
    ): string {
        return static::draw(
            compact(
                'className',
                'text',
                'icon',
                'attributes'
            ) + [
                'size' => $size->value,
                'theme' => $theme->value,
                'position' => $position->value,
            ]
        );
    }
}
