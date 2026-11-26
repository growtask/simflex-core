<?php

/**
 * Демо StepIndicator: размеры, число шагов и активный шаг (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Other\StepIndicator\Layout as StepIndicator;
use Simflex\Core\Layout\Components\UI\Other\StepIndicator\StepIndicatorSize;
use Simflex\Core\Layout\Components\UI\Other\StepIndicator\StepIndicatorTheme;

$indicatorTheme = StepIndicatorTheme::from($theme);

?>
<?php foreach (StepIndicatorSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach ([[3, 0], [3, 1], [5, 2], [10, 4], [10, 9]] as [$count, $active]): ?>
            <?= StepIndicator::drawStepIndicator(
                count: $count,
                active: $active,
                label: "Шаг $active из $count",
                size: $size,
                theme: $indicatorTheme,
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
