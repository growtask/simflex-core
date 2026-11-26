<?php

/**
 * Демо LoaderRing: значение × размер, без числа, успех и ошибка (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressTheme;
use Simflex\Core\Layout\Components\UI\Loader\LoaderRing\Layout as Ring;

$progressTheme = ProgressTheme::from($theme);

?>
<?php foreach (ProgressSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach ([0, 25, 50, 75, 100] as $value): ?>
            <?= Ring::drawRing($value, size: $size, theme: $progressTheme) ?>
        <?php endforeach; ?>
        <?= Ring::drawRing(60, showValue: false, size: $size, style: ProgressStyle::Success, theme: $progressTheme) ?>
        <?= Ring::drawRing(30, size: $size, style: ProgressStyle::Error, theme: $progressTheme) ?>
    </div>
<?php endforeach; ?>
