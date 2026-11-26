<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonMenu;

use Simflex\Core\Layout\LayoutBase;

class Layout extends LayoutBase
{
    public static function drawButtonMenu(
        string          $className = '',
        string          $text = '',
        string          $link = '',
        string          $icon = 'true',
        string          $badge = '',
        ButtonMenuStyle $style = ButtonMenuStyle::Flat,
        ButtonMenuSize  $size = ButtonMenuSize::Medium,
        ButtonMenuTheme $theme = ButtonMenuTheme::Light,
        array           $attributes = [],
        ButtonMenuDirection $direction = ButtonMenuDirection::Vertical
    ): string {
        return static::draw(
            compact(
                'className',
                'text',
                'link',
                'icon',
                'badge',
                'attributes'
            ) + [
                'style' => $style->value,
                'direction' => $direction->value,
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }
}
