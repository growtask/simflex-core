<?php

/**
 * Демо LoaderProgressLabel: вид × процент × размер (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressTheme;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgressLabel\Layout as ProgressLabel;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgressLabel\LoaderProgressLabelStyle;

$progressTheme = LoaderProgressTheme::from($theme);

?>
<?php foreach ([LoaderProgressSize::Medium, LoaderProgressSize::Small] as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (LoaderProgressLabelStyle::cases() as $labelStyle): ?>
            <?php foreach ([0, 50, 75] as $percent): ?>
                <?= ProgressLabel::drawLoaderProgressLabel($percent, 'report.pdf', $labelStyle, $size, $progressTheme) ?>
            <?php endforeach; ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
