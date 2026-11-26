<?php

/**
 * Демо LoaderInline: размеры (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderTheme;
use Simflex\Core\Layout\Components\UI\Loader\LoaderInline\Layout as LoaderInline;
use Simflex\Core\Layout\Components\UI\Loader\LoaderInline\LoaderInlineSize;

$loaderTheme = LoaderTheme::from($theme);

?>
<div class="ui-showcase__row">
    <?php foreach (LoaderInlineSize::cases() as $size): ?>
        <?= LoaderInline::drawLoaderInline('Загрузка: ' . $size->name, $size, $loaderTheme) ?>
    <?php endforeach; ?>
</div>
