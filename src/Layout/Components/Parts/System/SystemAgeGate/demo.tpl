<?php

/**
 * Демо AgeGate: окно проверки возраста с логотипом и без (витрина Layout\LayoutShowcase).
 * Окно выведено в рамке (inline), на странице оно закрывает весь экран
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\System\SystemAgeGate\SystemAgeGateTheme;
use Simflex\Core\Layout\Components\Parts\System\SystemAgeGate\Layout as AgeGate;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogo\Layout as BrandLogo;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogo\BrandLogoTheme;

$gateTheme = SystemAgeGateTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">С логотипом</h3>
<div class="ui-showcase__row">
    <?= AgeGate::drawSystemAgeGate(
        theme: $gateTheme,
        logoHtml: BrandLogo::drawBrandLogo(name: 'Мой сайт', theme: BrandLogoTheme::from($theme)),
        inline: true,
    ) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Без логотипа, свои тексты</h3>
<div class="ui-showcase__row">
    <?= AgeGate::drawSystemAgeGate(
        theme: $gateTheme,
        title: 'Вам исполнилось 21 год?',
        text: 'Сайт содержит информацию о товарах для взрослых.',
        inline: true,
    ) ?>
</div>
