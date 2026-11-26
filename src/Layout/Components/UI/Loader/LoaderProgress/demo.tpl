<?php

/**
 * Демо LoaderProgress: полоса (тип × размер × стиль) (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\Layout as Progress;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressTheme;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressType;

$progressTheme = LoaderProgressTheme::from($theme);

?>
<?php foreach (LoaderProgressStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m">Полоса: <?= $style->name ?></h3>
    <?php foreach (LoaderProgressSize::cases() as $size): ?>
        <div class="ui-showcase__row">
            <?php foreach ([0, 25, 50, 75, 100] as $value): ?>
                <span class="ui-showcase__field">
                    <?= Progress::drawLoaderProgress($value, LoaderProgressType::Determinate, $size, $style, $progressTheme) ?>
                </span>
            <?php endforeach; ?>
            <span class="ui-showcase__field">
                <?= Progress::drawLoaderProgress(type: LoaderProgressType::Indeterminate, size: $size, style: $style, theme: $progressTheme) ?>
            </span>
            <span class="ui-showcase__field">
                <?= Progress::drawLoaderProgress(
                    type: LoaderProgressType::Indeterminate,
                    size: $size,
                    style: $style,
                    theme: $progressTheme,
                    animation: false,
                ) ?>
            </span>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>
