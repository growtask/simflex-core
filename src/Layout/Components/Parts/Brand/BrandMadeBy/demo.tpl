<?php

/**
 * Демо BrandMadeBy: отметка движка «Powered by» и со своей подписью (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\Brand\BrandMadeBy\Layout as BrandMadeBy;
use Simflex\Core\Layout\Components\Parts\Brand\BrandMadeBy\MadeByTheme;

$madeTheme = MadeByTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">Powered by</h3>
<div class="ui-showcase__row">
    <?= BrandMadeBy::drawBrandMadeBy(theme: $madeTheme, name: 'Симфлекс', href: 'https://example.com') ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Своя подпись</h3>
<div class="ui-showcase__row">
    <?= BrandMadeBy::drawBrandMadeBy(theme: $madeTheme, caption: 'Работает на', name: 'Симфлекс', href: 'https://example.com') ?>
</div>
