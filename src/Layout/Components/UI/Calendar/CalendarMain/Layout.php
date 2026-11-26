<?php

namespace Simflex\Core\Layout\Components\UI\Calendar\CalendarMain;

use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;
use Simflex\Core\Layout\LayoutBase;

/**
 * Календарь (Figma Calendar/calendar, day, item; design-ui-calendar.md): виды days (сетка дней, неделя
 * с понедельника), months, years, time (часы и минуты). Сетку строит script.js по data-value; выбор — событие
 * calendar:select на корне ({detail: {value: 'Y-m-d' | 'Y-m-d H:i' | 'H:i'}}). Поле даты — TextInput с
 * InputMainKind::Date, DateTime, Time: календарь раскрывается под ним
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
     * @param CalendarMainSelection $selection None — только показ, Single — один день, Range — диапазон
     *        (значение 'Y-m-d/Y-m-d', событие calendar:select после выбора конца)
     * @param CalendarMainFormat $format H24 или H12 (в виде time колонки часов, минут и AM/PM)
     */
    public static function drawCalendarMain(
        string        $value = '',
        CalendarMainMode  $mode = CalendarMainMode::Date,
        CalendarMainTheme $theme = CalendarMainTheme::Light,
        bool          $card = true,
        string        $min = '',
        string        $max = '',
        int           $minuteStep = 5,
        string        $label = 'Календарь',
        string        $id = '',
        string        $className = '',
        array         $attributes = [],
        CalendarMainSelection $selection = CalendarMainSelection::Single,
        CalendarMainFormat $format = CalendarMainFormat::H24,
    ): string {
        $id = $id !== '' ? $id : 'sf-calendar-' . ++self::$counter;
        $arrow = fn(string $icon, string $text, string $step) => ButtonIcon::drawButtonIconSmall(
            icon: $icon,
            label: $text,
            className: 'calendar__arrow',
            style: ButtonIconSmallStyle::Flat,
            theme: ButtonIconSmallTheme::from($theme->value),
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
            'selection' => $selection->value,
            'format' => $format->value,
        ]);
    }
}
