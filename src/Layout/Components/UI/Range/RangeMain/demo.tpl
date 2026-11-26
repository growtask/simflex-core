<?php

/**
 * Демо Range: диапазон и одиночное значение, ширина hug и fill, отключённый, с подписями и делениями
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Range\RangeMain\Layout as Range;
use Simflex\Core\Layout\Components\UI\Range\RangeMain\RangeTheme;
use Simflex\Core\Layout\Components\UI\Range\RangeMain\RangeType;
use Simflex\Core\Layout\Components\UI\Range\RangeMain\RangeWidth;

$rangeTheme = RangeTheme::from($theme);

?>
<?php foreach (RangeType::cases() as $type): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $type->name ?></h3>
    <?php foreach (RangeWidth::cases() as $width): ?>
        <div class="ui-showcase__row">
            <?= Range::drawRange(0, 100000, 20000, 80000, 1000, $type, $width, $rangeTheme) ?>
            <?= Range::drawRange(0, 100000, null, null, 1000, $type, $width, $rangeTheme, marks: true, labels: true) ?>
            <?= Range::drawRange(0, 100000, 40000, 100000, 1000, $type, $width, $rangeTheme, disabled: true) ?>
            <?= Range::drawRange(0, 100000, 40000, 100000, 1000, $type, $width, $rangeTheme, inputs: false) ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>
