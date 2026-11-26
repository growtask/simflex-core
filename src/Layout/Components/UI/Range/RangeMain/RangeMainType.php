<?php

namespace Simflex\Core\Layout\Components\UI\Range\RangeMain;

enum RangeMainType: string
{
    /** Две ручки: от и до */
    case Range = 'range';
    /** Одна ручка: значение от минимума */
    case Single = 'single';
}
