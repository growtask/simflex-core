<?php

namespace Simflex\Core\Layout\Components\UI\Calendar\CalendarMain;

/**
 * Формат времени в виде time: 24-часовой или 12-часовой (колонка AM/PM; значение календаря остаётся 24-часовым)
 */
enum CalendarMainFormat: string
{
    case H24 = '24h';
    case H12 = '12h';
}
