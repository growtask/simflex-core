<?php

/**
 * Демо LoaderSteps: число шагов × размер (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressTheme;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSteps\Layout as Steps;

$progressTheme = ProgressTheme::from($theme);

?>
<?php foreach (ProgressSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach ([3, 4, 5] as $total): ?>
            <?= Steps::drawSteps($total, 2, true, $size, $progressTheme) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
