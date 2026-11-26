<?php

/**
 * Демо Preloader: с логотипом и без (витрина Layout\LayoutShowcase).
 * Прелоадер выведен в рамке (inline), на странице он закрывает весь экран
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\System\SystemPreloader\Layout as Preloader;
use Simflex\Core\Layout\Components\Parts\System\SystemPreloader\PreloaderTheme;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogo\Layout as BrandLogo;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogo\LogoTheme;

$preloaderTheme = PreloaderTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">С логотипом</h3>
<div class="ui-showcase__row" style="height: 320px">
    <?= Preloader::drawPreloader(
        theme: $preloaderTheme,
        logoHtml: BrandLogo::drawBrandLogo(name: 'Мой сайт', theme: LogoTheme::from($theme)),
        inline: true,
    ) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Только лоадер</h3>
<div class="ui-showcase__row" style="height: 240px">
    <?= Preloader::drawPreloader(theme: $preloaderTheme, inline: true) ?>
</div>
