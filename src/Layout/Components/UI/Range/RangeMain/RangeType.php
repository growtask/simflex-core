<?php

namespace Simflex\Core\Layout\Components\UI\Range\RangeMain;

enum RangeType: string
{
    /** Две ручки: от и до */
    case Range = 'range';
    /** Одна ручка: значение от минимума */
    case Single = 'single';
}
