<?php

/**
 * Демо Calendar: режимы дата, дата и время, время; с карточкой и без, с ограничением дат
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarFormat;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarMode;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarSelection;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarTheme;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\Layout as Calendar;

$calendarTheme = CalendarTheme::from($theme);
$values = [
    CalendarMode::Date->value => '2026-11-19',
    CalendarMode::DateTime->value => '2026-11-19 14:30',
    CalendarMode::Time->value => '14:30',
];

?>
<?php foreach (CalendarMode::cases() as $mode): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $mode->name ?></h3>
    <div class="ui-showcase__row">
        <?= Calendar::drawCalendar(
            value: $values[$mode->value],
            mode: $mode,
            theme: $calendarTheme,
            id: 'ui-calendar-' . $mode->value . '-' . $theme,
        ) ?>
        <?= Calendar::drawCalendar(
            mode: $mode,
            theme: $calendarTheme,
            card: false,
            id: 'ui-calendar-empty-' . $mode->value . '-' . $theme,
        ) ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Выбор дней (CalendarSelection)</h3>
<div class="ui-showcase__row">
    <?php foreach (CalendarSelection::cases() as $selection): ?>
        <?= Calendar::drawCalendar(
            value: $selection === CalendarSelection::Range ? '2026-11-17/2026-11-21' : '2026-11-19',
            theme: $calendarTheme,
            selection: $selection,
            label: 'Календарь: ' . $selection->name,
            id: 'ui-calendar-selection-' . $selection->value . '-' . $theme,
        ) ?>
    <?php endforeach; ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Формат времени (CalendarFormat)</h3>
<div class="ui-showcase__row">
    <?php foreach (CalendarFormat::cases() as $format): ?>
        <?= Calendar::drawCalendar(
            value: '14:30',
            mode: CalendarMode::Time,
            theme: $calendarTheme,
            format: $format,
            id: 'ui-calendar-format-' . $format->value . '-' . $theme,
        ) ?>
    <?php endforeach; ?>
    <?= Calendar::drawCalendar(
        value: '2026-11-19 14:30',
        mode: CalendarMode::DateTime,
        theme: $calendarTheme,
        format: CalendarFormat::H12,
        id: 'ui-calendar-datetime-12h-' . $theme,
    ) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Ограничение дат и шаг минут</h3>
<div class="ui-showcase__row">
    <?= Calendar::drawCalendar(
        value: '2026-11-19',
        theme: $calendarTheme,
        min: '2026-11-10',
        max: '2026-11-25',
        id: 'ui-calendar-limit-' . $theme,
    ) ?>
    <?= Calendar::drawCalendar(
        value: '14:30',
        mode: CalendarMode::Time,
        theme: $calendarTheme,
        minuteStep: 15,
        id: 'ui-calendar-step-' . $theme,
    ) ?>
</div>
