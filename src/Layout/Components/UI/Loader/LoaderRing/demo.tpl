<?php

/**
 * Демо LoaderRing: значение × размер, без числа, успех и ошибка (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressTheme;
use Simflex\Core\Layout\Components\UI\Loader\LoaderRing\Layout as Ring;

$progressTheme = LoaderProgressTheme::from($theme);

?>
<?php foreach (LoaderProgressSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach ([0, 25, 50, 75, 100] as $value): ?>
            <?= Ring::drawLoaderRing($value, size: $size, theme: $progressTheme) ?>
        <?php endforeach; ?>
        <?= Ring::drawLoaderRing(60, showValue: false, size: $size, style: LoaderProgressStyle::Success, theme: $progressTheme) ?>
        <?= Ring::drawLoaderRing(30, size: $size, style: LoaderProgressStyle::Error, theme: $progressTheme) ?>
    </div>
<?php endforeach; ?>
