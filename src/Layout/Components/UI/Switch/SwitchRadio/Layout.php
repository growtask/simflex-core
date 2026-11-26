<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchRadio;

use Simflex\Core\Layout\LayoutBase;

class Layout extends LayoutBase
{
    public static function drawSwitchRadio(
        string        $className = '',
        string        $text = '',
        string        $id = '',
        string        $value = '',
        SwitchRadioSize     $size = SwitchRadioSize::Small,
        SwitchRadioTheme    $theme = SwitchRadioTheme::Light,
        SwitchRadioPosition $position = SwitchRadioPosition::Left,
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
