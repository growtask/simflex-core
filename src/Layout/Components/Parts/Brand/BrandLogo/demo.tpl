<?php

/**
 * Демо BrandLogo: статичный логотип по умолчанию и со своим знаком (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\Brand\BrandLogo\Layout as BrandLogo;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogo\LogoTheme;

$logoTheme = LogoTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">Знак по умолчанию</h3>
<div class="ui-showcase__row">
    <?= BrandLogo::drawBrandLogo(theme: $logoTheme, name: 'Simflex') ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Свой знак, ссылка не на главную</h3>
<div class="ui-showcase__row">
    <?= BrandLogo::drawBrandLogo(
        theme: $logoTheme,
        name: 'Мой сайт',
        href: '/about',
        src: asset('images/brand/made-by' . ($theme === 'dark' ? '-dark' : '') . '.svg'),
    ) ?>
</div>
