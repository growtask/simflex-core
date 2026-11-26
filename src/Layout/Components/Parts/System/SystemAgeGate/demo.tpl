<?php

/**
 * Демо AgeGate: окно проверки возраста с логотипом и без (витрина Layout\LayoutShowcase).
 * Окно выведено в рамке (inline), на странице оно закрывает весь экран
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\System\SystemAgeGate\AgeGateTheme;
use Simflex\Core\Layout\Components\Parts\System\SystemAgeGate\Layout as AgeGate;
use Simflex\Core\Layout\Components\UI\Other\Logo\Layout as Logo;
use Simflex\Core\Layout\Components\UI\Other\Logo\LogoTheme;
use Simflex\Core\Layout\Components\UI\Other\Logo\LogoType;

$gateTheme = AgeGateTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">С логотипом</h3>
<div class="ui-showcase__row">
    <?= AgeGate::drawAgeGate(
        theme: $gateTheme,
        logoHtml: Logo::drawLogo(name: 'Мой сайт', text: false, type: LogoType::Static, theme: LogoTheme::from($theme)),
        inline: true,
    ) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Без логотипа, свои тексты</h3>
<div class="ui-showcase__row">
    <?= AgeGate::drawAgeGate(
        theme: $gateTheme,
        title: 'Вам исполнилось 21 год?',
        text: 'Сайт содержит информацию о товарах для взрослых.',
        inline: true,
    ) ?>
</div>
