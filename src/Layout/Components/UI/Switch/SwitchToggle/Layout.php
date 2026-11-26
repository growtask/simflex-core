<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchToggle;

use Simflex\Core\Layout\LayoutBase;

class Layout extends LayoutBase
{
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
