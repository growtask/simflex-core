<?php

namespace Simflex\Core\Layout\Components\UI\Core\Calendar;

use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\Layout as ButtonIcon;
use Simflex\Core\Layout\LayoutBase;

/**
 * Календарь (Figma Calendar/calendar, day, item; design-ui-calendar.md): виды days (сетка дней, неделя
 * с понедельника), months, years, time (часы и минуты). Сетку строит script.js по data-value; выбор — событие
 * calendar:select на корне ({detail: {value: 'Y-m-d' | 'Y-m-d H:i' | 'H:i'}}). Поле даты — TextInput с
 * TextInputKind::Date, DateTime, Time: календарь раскрывается под ним
 */
class Layout extends LayoutBase
{
    private static int $counter = 0;

    /**
     * @param string $value Выбранное значение в ISO: 'Y-m-d', 'Y-m-d H:i' или 'H:i'; пусто — не выбрано
     * @param bool $card Карточка: фон, тень, радиус (у всплывающего календаря); без неё — только отступы
     * @param string $min Самая ранняя дата 'Y-m-d' (раньше — недоступны), пусто — без ограничения
     * @param string $max Самая поздняя дата 'Y-m-d', пусто — без ограничения
     * @param int $minuteStep Шаг минут в виде time
     * @param string $label Доступное имя календаря
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawCalendar(
        string        $value = '',
        CalendarMode  $mode = CalendarMode::Date,
        CalendarTheme $theme = CalendarTheme::Light,
        bool          $card = true,
        string        $min = '',
        string        $max = '',
        int           $minuteStep = 5,
        string        $label = 'Календарь',
        string        $id = '',
        string        $className = '',
        array         $attributes = [],
    ): string {
        $id = $id !== '' ? $id : 'sf-calendar-' . ++self::$counter;
        $arrow = fn(string $icon, string $text, string $step) => ButtonIcon::drawButtonIcon(
            icon: $icon,
            label: $text,
            className: 'calendar__arrow',
            style: ButtonIconStyle::Flat,
            theme: ButtonIconTheme::from($theme->value),
            attributes: ['data-sf-calendar-step' => $step],
        );
        $prev = $arrow('chevron-m-left', 'Назад', '-1');
        $next = $arrow('chevron-m-right', 'Вперёд', '1');

        return static::draw(compact(
            'value',
            'card',
            'min',
            'max',
            'minuteStep',
            'label',
            'id',
            'className',
            'attributes',
            'prev',
            'next'
        ) + [
            'mode' => $mode->value,
            'theme' => $theme->value,
        ]);
    }
}
