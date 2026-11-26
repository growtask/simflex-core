<?php

/**
 * Демо BrowserSupport: баннер с кнопкой и без (витрина Layout\LayoutShowcase).
 * В демо check выключен, чтобы баннер был виден; на сайте он показывается только в устаревшем браузере
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\System\SystemBrowserSupport\BrowserSupportTheme;
use Simflex\Core\Layout\Components\Parts\System\SystemBrowserSupport\Layout as BrowserSupport;

$bannerTheme = BrowserSupportTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">С кнопкой</h3>
<div class="ui-showcase__row">
    <?= BrowserSupport::drawBrowserSupport(theme: $bannerTheme, buttonLink: 'https://browsehappy.com/', check: false, inline: true) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Без кнопки</h3>
<div class="ui-showcase__row">
    <?= BrowserSupport::drawBrowserSupport(theme: $bannerTheme, check: false, inline: true) ?>
</div>
