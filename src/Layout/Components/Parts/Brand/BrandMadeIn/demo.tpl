<?php

/**
 * Демо BrandMadeIn: отметка студии с флагом и без, со своей подписью (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\Brand\BrandMadeIn\Layout as BrandMadeIn;
use Simflex\Core\Layout\Components\Parts\Brand\BrandMadeIn\MadeInTheme;

$madeTheme = MadeInTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">С флагом (flag включён)</h3>
<div class="ui-showcase__row">
    <?= BrandMadeIn::drawBrandMadeIn(theme: $madeTheme, name: 'Гротеск', href: 'https://example.com') ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Без флага (flag выключен)</h3>
<div class="ui-showcase__row">
    <?= BrandMadeIn::drawBrandMadeIn(theme: $madeTheme, flag: false, name: 'Гротеск', href: 'https://example.com') ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Своя подпись</h3>
<div class="ui-showcase__row">
    <?= BrandMadeIn::drawBrandMadeIn(theme: $madeTheme, caption: 'Разработка', name: 'Гротеск', href: 'https://example.com') ?>
</div>
