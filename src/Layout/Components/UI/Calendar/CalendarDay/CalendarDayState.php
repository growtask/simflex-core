<?php

namespace Simflex\Core\Layout\Components\UI\Calendar\CalendarDay;

/** Вид ячейки дня (набор Figma Calendar/day) */
enum CalendarDayState: string
{
    case Default = 'default';
    case Weekend = 'weekend';
    case Muted = 'muted';
    case Today = 'today';
    case Selected = 'selected';
    case RangeStart = 'range-start';
    case InRange = 'in-range';
    case RangeEnd = 'range-end';
    case Disabled = 'disabled';
}
