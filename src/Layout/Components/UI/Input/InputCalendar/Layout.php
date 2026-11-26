<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputCalendar;

use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarMode;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarTheme;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\Layout as Calendar;
use Simflex\Core\Layout\Components\UI\Input\InputDate\Layout as InputDate;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Календарь у поля даты (набор Figma Inputs/calendar): открытый календарь под полем или над ним. В живом поле даты
 * календарь раскрывает скрипт InputMain; здесь он показан постоянно, как образец
 */
class Layout extends LayoutBase
{
    /**
     * @param bool $top Календарь над полем, иначе под ним
     * @param bool $open Показать календарь; false — только поле с кнопкой календаря
     */
    public static function drawInputCalendar(
        bool           $top = false,
        bool           $open = true,
        TextInputTheme $theme = TextInputTheme::Light,
        string         $value = '',
        string         $className = '',
    ): string {
        $field = InputDate::drawInputDate(theme: $theme, value: $value);
        $calendar = $open
            ? Calendar::drawCalendar(
                value: '',
                mode: CalendarMode::Date,
                theme: CalendarTheme::from($theme->value),
            )
            : '';

        return static::draw(compact('field', 'calendar', 'top', 'className'));
    }
}
