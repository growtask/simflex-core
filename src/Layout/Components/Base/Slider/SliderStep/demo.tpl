<?php

/**
 * Демо SliderStep: размеры, число шагов и активный шаг (первый, в середине, последний) (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Slider\SliderStep\Layout as StepIndicator;
use Simflex\Core\Layout\Components\Base\Slider\SliderStep\SliderStepSize;
use Simflex\Core\Layout\Components\Base\Slider\SliderStep\SliderStepTheme;

$indicatorTheme = SliderStepTheme::from($theme);

?>
<?php foreach (SliderStepSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach ([[3, 0], [3, 1], [5, 2], [10, 4], [10, 9]] as [$count, $active]): ?>
            <?= StepIndicator::drawSliderStep(
                count: $count,
                active: $active,
                label: "Шаг $active из $count",
                size: $size,
                theme: $indicatorTheme,
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
