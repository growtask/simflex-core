<?php

/**
 * Демо LoaderIcon: все размеры × стили (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\Layout as LoaderIcon;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderTheme;

$loaderTheme = LoaderTheme::from($theme);

?>
<?php foreach (LoaderStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (LoaderSize::cases() as $size): ?>
            <?= LoaderIcon::drawLoader($size, $style, $loaderTheme, label: $size->name) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Без анимации (animation: false)</h3>
<div class="ui-showcase__row">
    <?php foreach (LoaderSize::cases() as $size): ?>
        <?= LoaderIcon::drawLoader($size, LoaderStyle::Primary, $loaderTheme, label: $size->name, animation: false) ?>
    <?php endforeach; ?>
</div>
