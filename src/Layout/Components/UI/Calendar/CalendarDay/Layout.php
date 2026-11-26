<?php

namespace Simflex\Core\Layout\Components\UI\Calendar\CalendarDay;

use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarMainTheme;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\Layout as CalendarMain;
use Simflex\Core\Layout\LayoutBase;

/**
 * Ячейка дня (набор Figma Calendar/day): живёт внутри CalendarMain (строит script.js); отдельно показывает
 * ячейку во всех состояниях. Стили — у CalendarMain (подключается вместе с этим компонентом)
 */
class Layout extends LayoutBase
{
    public static function drawCalendarDay(
        int              $day = 1,
        CalendarDayState $state = CalendarDayState::Default,
        CalendarMainTheme    $theme = CalendarMainTheme::Light,
        string           $className = '',
    ): string {
        CalendarMain::initAssets();

        return static::draw(compact('day', 'className') + ['state' => $state->value, 'theme' => $theme->value]);
    }
}
