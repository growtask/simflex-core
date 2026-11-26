<?php

/**
 * Демо RangeDot: ручка на треке, с подсказкой и без, недоступная (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Range\RangeDot\Layout as RangeDot;
use Simflex\Core\Layout\Components\UI\Range\RangeMain\RangeTheme;

$rangeTheme = RangeTheme::from($theme);

?>
<div class="ui-showcase__row">
    <span class="ui-showcase__field"><?= RangeDot::drawRangeDot(30, theme: $rangeTheme) ?></span>
    <span class="ui-showcase__field"><?= RangeDot::drawRangeDot(60, tooltip: false, theme: $rangeTheme) ?></span>
    <span class="ui-showcase__field"><?= RangeDot::drawRangeDot(80, disabled: true, theme: $rangeTheme) ?></span>
</div>
