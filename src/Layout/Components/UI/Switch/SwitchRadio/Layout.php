<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchRadio;

use Simflex\Core\Layout\LayoutBase;

class Layout extends LayoutBase
{
    public static function drawRadio(
        string        $className = '',
        string        $text = '',
        string        $id = '',
        string        $value = '',
        RadioSize     $size = RadioSize::Small,
        RadioTheme    $theme = RadioTheme::Light,
        RadioPosition $position = RadioPosition::Left,
        array         $attributes = []
    ): string {
        return static::draw(
            compact(
                'className',
                'text',
                'id',
                'value',
                'attributes'
            ) + [
                'size' => $size->value,
                'theme' => $theme->value,
                'position' => $position->value,
            ]
        );
    }
}
