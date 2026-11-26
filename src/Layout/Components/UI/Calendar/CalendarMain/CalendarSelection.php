<?php

namespace Simflex\Core\Layout\Components\UI\Calendar\CalendarMain;

/**
 * Как выбираются дни: None — календарь только показывает даты, Single — один день, Range — диапазон двумя кликами
 */
enum CalendarSelection: string
{
    case None = 'none';
    case Single = 'single';
    case Range = 'range';
}
