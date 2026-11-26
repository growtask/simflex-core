<?php

/**
 * Демо BrandLogoAnim: логотип с подписью и без, по наведению знак сменяется «Главная» (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\Brand\BrandLogoAnim\Layout as BrandLogoAnim;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogoAnim\BrandLogoAnimTheme;

$logoTheme = BrandLogoAnimTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">С подписью (text включён)</h3>
<div class="ui-showcase__row">
    <?= BrandLogoAnim::drawBrandLogoAnim(theme: $logoTheme, name: 'Simflex', caption: 'Shop') ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Без подписи (text выключен)</h3>
<div class="ui-showcase__row">
    <?= BrandLogoAnim::drawBrandLogoAnim(theme: $logoTheme, name: 'Simflex', text: false) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Своя подпись при наведении</h3>
<div class="ui-showcase__row">
    <?= BrandLogoAnim::drawBrandLogoAnim(theme: $logoTheme, name: 'Simflex', text: false, homeText: 'На главную') ?>
</div>
