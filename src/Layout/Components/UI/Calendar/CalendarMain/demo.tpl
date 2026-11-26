<?php

/**
 * Демо Calendar: режимы дата, дата и время, время; с карточкой и без, с ограничением дат
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarMainFormat;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarMainMode;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarMainSelection;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarMainTheme;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\Layout as Calendar;

$calendarTheme = CalendarMainTheme::from($theme);
$values = [
    CalendarMainMode::Date->value => '2026-11-19',
    CalendarMainMode::DateTime->value => '2026-11-19 14:30',
    CalendarMainMode::Time->value => '14:30',
];

?>
<?php foreach (CalendarMainMode::cases() as $mode): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $mode->name ?></h3>
    <div class="ui-showcase__row">
        <?= Calendar::drawCalendarMain(
            value: $values[$mode->value],
            mode: $mode,
            theme: $calendarTheme,
            id: 'ui-calendar-' . $mode->value . '-' . $theme,
        ) ?>
        <?= Calendar::drawCalendarMain(
            mode: $mode,
            theme: $calendarTheme,
            card: false,
            id: 'ui-calendar-empty-' . $mode->value . '-' . $theme,
        ) ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Выбор дней (CalendarMainSelection)</h3>
<div class="ui-showcase__row">
    <?php foreach (CalendarMainSelection::cases() as $selection): ?>
        <?= Calendar::drawCalendarMain(
            value: $selection === CalendarMainSelection::Range ? '2026-11-17/2026-11-21' : '2026-11-19',
            theme: $calendarTheme,
            selection: $selection,
            label: 'Календарь: ' . $selection->name,
            id: 'ui-calendar-selection-' . $selection->value . '-' . $theme,
        ) ?>
    <?php endforeach; ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Формат времени (CalendarMainFormat)</h3>
<div class="ui-showcase__row">
    <?php foreach (CalendarMainFormat::cases() as $format): ?>
        <?= Calendar::drawCalendarMain(
            value: '14:30',
            mode: CalendarMainMode::Time,
            theme: $calendarTheme,
            format: $format,
            id: 'ui-calendar-format-' . $format->value . '-' . $theme,
        ) ?>
    <?php endforeach; ?>
    <?= Calendar::drawCalendarMain(
        value: '2026-11-19 14:30',
        mode: CalendarMainMode::DateTime,
        theme: $calendarTheme,
        format: CalendarMainFormat::H12,
        id: 'ui-calendar-datetime-12h-' . $theme,
    ) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Ограничение дат и шаг минут</h3>
<div class="ui-showcase__row">
    <?= Calendar::drawCalendarMain(
        value: '2026-11-19',
        theme: $calendarTheme,
        min: '2026-11-10',
        max: '2026-11-25',
        id: 'ui-calendar-limit-' . $theme,
    ) ?>
    <?= Calendar::drawCalendarMain(
        value: '14:30',
        mode: CalendarMainMode::Time,
        theme: $calendarTheme,
        minuteStep: 15,
        id: 'ui-calendar-step-' . $theme,
    ) ?>
</div>
