<?php

namespace Simflex\Core\Layout\Components\UI\Range\RangeMain;

enum RangeWidth: string
{
    /** Фиксированная ширина 220 px */
    case Hug = 'hug';
    /** На всю ширину контейнера */
    case Fill = 'fill';
}
