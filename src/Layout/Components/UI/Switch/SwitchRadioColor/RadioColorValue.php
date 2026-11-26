<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchRadioColor;

/** Цвет образца (Figma Switches/radio-color); значение — суффикс токена --color-uniq-<значение> */
enum RadioColorValue: string
{
    case Dark = 'dark';
    case Violet = 'violet';
    case Green = 'green';
    case Blue = 'blue';
    case Red = 'red';
    case Purple = 'purple';
    case Orange = 'orange';
    case Gold = 'gold';
    case Pink = 'pink';
    case Light = 'light';
}
