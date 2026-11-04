<?php

namespace Simflex\Core\Layout\Components\UI\Core\Calendar;

/**
 * Что выбирает календарь: дату (виды days, months, years), дату и время (после дня — вид time), только время
 */
enum CalendarMode: string
{
    case Date = 'date';
    case DateTime = 'datetime';
    case Time = 'time';
}
