<?php

/**
 * Демо LoaderIcon: все размеры × стили (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\Layout as LoaderIcon;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainTheme;

$loaderTheme = LoaderMainTheme::from($theme);

?>
<?php foreach (LoaderMainStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (LoaderMainSize::cases() as $size): ?>
            <?= LoaderIcon::drawLoaderMain($size, $style, $loaderTheme, label: $size->name) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Без анимации (animation: false)</h3>
<div class="ui-showcase__row">
    <?php foreach (LoaderMainSize::cases() as $size): ?>
        <?= LoaderIcon::drawLoaderMain($size, LoaderMainStyle::Primary, $loaderTheme, label: $size->name, animation: false) ?>
    <?php endforeach; ?>
</div>
