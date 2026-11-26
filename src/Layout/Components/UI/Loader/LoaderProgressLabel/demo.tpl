<?php

/**
 * Демо LoaderProgressLabel: вид × процент × размер (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressTheme;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgressLabel\Layout as ProgressLabel;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgressLabel\ProgressLabelStyle;

$progressTheme = ProgressTheme::from($theme);

?>
<?php foreach ([ProgressSize::Medium, ProgressSize::Small] as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (ProgressLabelStyle::cases() as $labelStyle): ?>
            <?php foreach ([0, 50, 75] as $percent): ?>
                <?= ProgressLabel::drawProgressLabel($percent, 'report.pdf', $labelStyle, $size, $progressTheme) ?>
            <?php endforeach; ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
