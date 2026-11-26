<?php

/**
 * Демо DropdownTab: размеры × стили, тема меню, активная, отключённая, с иконкой и бейджем
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Dropdown\DropdownTab\DropdownTabMenuTheme;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownTab\DropdownTabSize;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownTab\DropdownTabStyle;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownTab\DropdownTabTheme;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownTab\Layout as DropdownTab;

$tabTheme = DropdownTabTheme::from($theme);
$options = [
    ['value' => 'phones', 'text' => 'Телефоны', 'link' => '#phones'],
    ['value' => 'tv', 'text' => 'Телевизоры', 'link' => '#tv', 'badge' => 'new'],
    ['value' => 'laptops', 'text' => 'Ноутбуки', 'link' => '#laptops'],
];

?>
<?php foreach (DropdownTabSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row ui-showcase__row_dropdowns">
        <?php foreach (DropdownTabStyle::cases() as $style): ?>
            <?= DropdownTab::drawDropdownTab(
                text: $style->name,
                options: $options,
                style: $style,
                size: $size,
                theme: $tabTheme,
                id: 'ui-dropdown-tab-' . $theme . '-' . $size->name . '-' . $style->name,
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Состояния, иконка, бейдж, тема меню</h3>
<div class="ui-showcase__row ui-showcase__row_dropdowns">
    <?= DropdownTab::drawDropdownTab(
        text: 'Активная',
        options: $options,
        theme: $tabTheme,
        active: true,
        id: 'ui-dropdown-tab-active-' . $theme,
    ) ?>
    <?= DropdownTab::drawDropdownTab(
        text: 'Отключённая',
        options: $options,
        theme: $tabTheme,
        disabled: true,
        id: 'ui-dropdown-tab-disabled-' . $theme,
    ) ?>
    <?= DropdownTab::drawDropdownTab(
        text: 'С иконкой и бейджем',
        icon: 'home',
        badge: '5',
        options: $options,
        theme: $tabTheme,
        id: 'ui-dropdown-tab-icon-' . $theme,
    ) ?>
    <?php foreach (DropdownTabMenuTheme::cases() as $menuTheme): ?>
        <?= DropdownTab::drawDropdownTab(
            text: 'Меню: ' . $menuTheme->name,
            options: $options,
            menuTheme: $menuTheme,
            theme: $tabTheme,
            id: 'ui-dropdown-tab-menu-' . $theme . '-' . $menuTheme->name,
        ) ?>
    <?php endforeach; ?>
</div>
