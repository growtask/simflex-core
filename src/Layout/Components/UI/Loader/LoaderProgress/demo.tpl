<?php

/**
 * Демо LoaderProgress: полоса (тип × размер × стиль) (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\Layout as Progress;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressTheme;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressType;

$progressTheme = ProgressTheme::from($theme);

?>
<?php foreach (ProgressStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m">Полоса: <?= $style->name ?></h3>
    <?php foreach (ProgressSize::cases() as $size): ?>
        <div class="ui-showcase__row">
            <?php foreach ([0, 25, 50, 75, 100] as $value): ?>
                <span class="ui-showcase__field">
                    <?= Progress::drawProgress($value, ProgressType::Determinate, $size, $style, $progressTheme) ?>
                </span>
            <?php endforeach; ?>
            <span class="ui-showcase__field">
                <?= Progress::drawProgress(type: ProgressType::Indeterminate, size: $size, style: $style, theme: $progressTheme) ?>
            </span>
            <span class="ui-showcase__field">
                <?= Progress::drawProgress(
                    type: ProgressType::Indeterminate,
                    size: $size,
                    style: $style,
                    theme: $progressTheme,
                    animation: false,
                ) ?>
            </span>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>
