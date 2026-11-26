<?php

/**
 * Демо LoaderDots: размеры × стили, с анимацией и без (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderDots\Layout as LoaderDots;
use Simflex\Core\Layout\Components\UI\Loader\LoaderDots\LoaderDotsSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderTheme;

$loaderTheme = LoaderTheme::from($theme);

?>
<?php foreach (LoaderStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (LoaderDotsSize::cases() as $size): ?>
            <?= LoaderDots::drawLoaderDots($size, $style, $loaderTheme, label: $size->name) ?>
            <?= LoaderDots::drawLoaderDots($size, $style, $loaderTheme, animation: false, label: $size->name) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
