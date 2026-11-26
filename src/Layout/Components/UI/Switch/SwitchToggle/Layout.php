<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchToggle;

use Simflex\Core\Layout\LayoutBase;

class Layout extends LayoutBase
{
    public static function drawToggle(
        string         $className = '',
        string         $text = '',
        bool           $icon = true,
        ToggleSize     $size = ToggleSize::Medium,
        ToggleTheme    $theme = ToggleTheme::Light,
        TogglePosition $position = TogglePosition::Left,
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
