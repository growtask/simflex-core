<?php

/**
 * Демо States: все состояния, кнопки включены и выключены (витрина Layout\LayoutShowcase).
 * Размеры Figma (fullhd, hd, tablet, mobile) задаёт ширина окна
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\States\Layout as States;
use Simflex\Core\Layout\Components\Parts\States\StatesStyle;
use Simflex\Core\Layout\Components\Parts\States\StatesTheme;

$statesTheme = StatesTheme::from($theme);

?>
<?php foreach (StatesStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <div class="ui-showcase__row">
        <?= States::drawStates(style: $style, theme: $statesTheme) ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Без второй кнопки</h3>
<div class="ui-showcase__row">
    <?= States::drawStates(style: StatesStyle::Error, theme: $statesTheme, secondaryButton: false) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Без кнопок, свои тексты</h3>
<div class="ui-showcase__row">
    <?= States::drawStates(
        style: StatesStyle::Empty,
        theme: $statesTheme,
        title: 'Ничего не найдено',
        text: 'Измените запрос или сбросьте фильтры',
        buttons: false,
    ) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Кнопки-ссылки</h3>
<div class="ui-showcase__row">
    <?= States::drawStates(
        style: StatesStyle::Success,
        theme: $statesTheme,
        primaryText: 'В каталог',
        primaryLink: '/catalog',
        secondaryText: 'На главную',
        secondaryLink: '/',
    ) ?>
</div>
