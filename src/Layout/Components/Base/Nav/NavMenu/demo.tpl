<?php

/**
 * Демо NavMenu: полное меню, с раскрытым подменю, без города, контактов, соцсетей и кнопки (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Nav\NavMenu\Layout as NavMenu;
use Simflex\Core\Layout\Components\Base\Nav\NavMenu\NavMenuTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallNetwork;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactType;

$theme = NavMenuTheme::from($theme);
$items = static fn(bool $open): array => [
    ['text' => 'Каталог', 'link' => '#catalog', 'current' => true],
    ['text' => 'Акции', 'link' => '#sale'],
    ['text' => 'Информация', 'open' => $open, 'children' => [
        ['text' => 'О компании', 'link' => '#about'],
        ['text' => 'Доставка и оплата', 'link' => '#delivery'],
    ]],
];
$contacts = [
    ['type' => LinkContactType::Phone, 'value' => '+7 (800) 555-35-35'],
    ['type' => LinkContactType::Email, 'value' => 'info@example.com'],
];
$socials = [
    ['network' => ButtonSocialSmallNetwork::Telegram, 'href' => '#telegram'],
    ['network' => ButtonSocialSmallNetwork::Vkontakte, 'href' => '#vk'],
];

?>
<h3 class="ui-showcase__subtitle ui-m">Полное меню</h3>
<div class="ui-showcase__row">
    <?= NavMenu::drawNavMenu(
        $items(false),
        location: 'Москва',
        contacts: $contacts,
        socials: $socials,
        buttonText: 'Связаться с нами',
        buttonLink: '#contacts',
        theme: $theme,
    ) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Подменю раскрыто</h3>
<div class="ui-showcase__row">
    <?= NavMenu::drawNavMenu($items(true), location: 'Москва', theme: $theme) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Без города, контактов, соцсетей и кнопки</h3>
<div class="ui-showcase__row">
    <?= NavMenu::drawNavMenu($items(false), theme: $theme) ?>
</div>
