<?php

/**
 * Демо CalendarItem: ячейка месяца и года в трёх состояниях (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarTheme;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarItem\Layout as CalendarItem;

$calendarTheme = CalendarTheme::from($theme);

?>
<div class="ui-showcase__row">
    <?= CalendarItem::drawCalendarItem('Март', theme: $calendarTheme) ?>
    <?= CalendarItem::drawCalendarItem('Апрель', current: true, theme: $calendarTheme) ?>
    <?= CalendarItem::drawCalendarItem('Май', selected: true, theme: $calendarTheme) ?>
    <?= CalendarItem::drawCalendarItem('2026', theme: $calendarTheme) ?>
</div>
