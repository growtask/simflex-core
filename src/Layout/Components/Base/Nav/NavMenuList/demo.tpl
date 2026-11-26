<?php

/**
 * Демо NavMenuList: свёрнутое и раскрытое подменю, текущая страница (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Nav\NavMenuList\Layout as NavMenuList;
use Simflex\Core\Layout\Components\Base\Nav\NavMenuList\NavMenuListTheme;

$theme = NavMenuListTheme::from($theme);
$items = static fn(bool $open, bool $current): array => [
    ['text' => 'Каталог', 'link' => '#catalog', 'current' => $current],
    ['text' => 'Акции', 'link' => '#sale'],
    ['text' => 'Информация', 'open' => $open, 'children' => [
        ['text' => 'О компании', 'link' => '#about'],
        ['text' => 'Доставка и оплата', 'link' => '#delivery'],
        ['text' => 'Контакты', 'link' => '#contacts'],
    ]],
    ['text' => 'Блог', 'link' => '#blog'],
];

?>
<h3 class="ui-showcase__subtitle ui-m">Подменю свёрнуто</h3>
<div class="ui-showcase__row" style="max-width: 320px;">
    <?= NavMenuList::drawNavMenuList($items(false, false), $theme) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Подменю раскрыто</h3>
<div class="ui-showcase__row" style="max-width: 320px;">
    <?= NavMenuList::drawNavMenuList($items(true, false), $theme) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Текущая страница</h3>
<div class="ui-showcase__row" style="max-width: 320px;">
    <?= NavMenuList::drawNavMenuList($items(false, true), $theme) ?>
</div>
