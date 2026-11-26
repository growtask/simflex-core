<?php

/**
 * Демо InputCalendar: календарь под полем, над полем и закрытый (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputTheme;
use Simflex\Core\Layout\Components\UI\Input\InputCalendar\Layout as InputCalendar;

$inputTheme = TextInputTheme::from($theme);

?>
<div class="ui-showcase__row">
    <?= InputCalendar::drawInputCalendar(theme: $inputTheme) ?>
    <?= InputCalendar::drawInputCalendar(top: true, theme: $inputTheme) ?>
    <?= InputCalendar::drawInputCalendar(open: false, theme: $inputTheme) ?>
</div>
