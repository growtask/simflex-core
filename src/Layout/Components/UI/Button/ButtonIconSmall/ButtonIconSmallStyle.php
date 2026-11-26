<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall;

enum ButtonIconSmallStyle: string
{
    /** Без плашки: крестик закрытия, очистка поля */
    case Flat = 'flat';
    /** Плашка со своей заливкой */
    case Secondary = 'secondary';
}
