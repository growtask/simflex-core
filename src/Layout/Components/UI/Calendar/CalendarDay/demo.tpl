<?php

/**
 * Демо CalendarDay: все состояния ячейки дня (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarMainTheme;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarDay\CalendarDayState;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarDay\Layout as CalendarDay;

$calendarTheme = CalendarMainTheme::from($theme);

?>
<div class="ui-showcase__row">
    <?php foreach (CalendarDayState::cases() as $state): ?>
        <span title="<?= $state->name ?>"><?= CalendarDay::drawCalendarDay(7, $state, $calendarTheme) ?></span>
    <?php endforeach; ?>
</div>
