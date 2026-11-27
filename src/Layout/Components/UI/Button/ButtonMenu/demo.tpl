<?php

/**
 * Демо ButtonMenu: расположение × размеры × стили, с иконкой и бейджем, без подписи, без иконки
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Button\ButtonMenu\ButtonMenuDirection;
use Simflex\Core\Layout\Components\UI\Button\ButtonMenu\ButtonMenuSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMenu\ButtonMenuStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMenu\ButtonMenuTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMenu\Layout as ButtonMenu;

$menuTheme = ButtonMenuTheme::from($theme);

?>
<?php foreach (ButtonMenuDirection::cases() as $direction): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $direction->name ?></h3>
    <?php foreach (ButtonMenuSize::cases() as $size): ?>
        <div class="ui-showcase__row">
            <?php foreach (ButtonMenuStyle::cases() as $style): ?>
                <?= ButtonMenu::drawButtonMenu(
                    text: $style->name,
                    icon: 'check',
                    link: '#menu',
                    style: $style,
                    size: $size,
                    theme: $menuTheme,
                    direction: $direction,
                ) ?>
                <?= ButtonMenu::drawButtonMenu(
                    text: 'С бейджем',
                    icon: 'check',
                    link: '#menu',
                    badge: '5',
                    style: $style,
                    size: $size,
                    theme: $menuTheme,
                    direction: $direction,
                ) ?>
                <?= ButtonMenu::drawButtonMenu(
                    icon: 'check',
                    link: '#menu',
                    badge: '5',
                    style: $style,
                    size: $size,
                    theme: $menuTheme,
                    direction: $direction,
                ) ?>
                <?= ButtonMenu::drawButtonMenu(
                    text: 'Без иконки',
                    link: '#menu',
                    icon: '',
                    style: $style,
                    size: $size,
                    theme: $menuTheme,
                    direction: $direction,
                ) ?>
            <?php endforeach; ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>
<h3 class="ui-showcase__subtitle ui-m">Недоступная</h3>
<div class="ui-showcase__row">
    <?php foreach (ButtonMenuStyle::cases() as $style): ?>
        <?= ButtonMenu::drawButtonMenu(text: 'Недоступна', icon: 'check', style: $style, theme: $menuTheme, attributes: ['disabled' => 'disabled']) ?>
    <?php endforeach; ?>
</div>
<h3 class="ui-showcase__subtitle ui-m">Бейдж (SfUi.menuBadge): появляется пружиной от угла, уходит быстрее</h3>
<div class="ui-showcase__row" id="ui-menu-badge-<?= $theme ?>">
    <?= ButtonMenu::drawButtonMenu(text: 'Корзина', icon: 'check', theme: $menuTheme) ?>
    <?= Button::drawButtonMain(text: 'Бейдж', style: ButtonMainStyle::Gray, size: ButtonMainSize::ExtraSmall, theme: ButtonMainTheme::from($theme), attributes: ['onclick' => 'var b=document.querySelector(\'#ui-menu-badge-' . $theme . ' .btn-menu\'); var n=b.querySelector(\'.btn-menu__badge:not([data-sf-leaving])\'); SfUi.menuBadge(b, n ? \'\' : \'3\')']) ?>
    <?= Button::drawButtonMain(text: '+1', style: ButtonMainStyle::Flat, size: ButtonMainSize::ExtraSmall, theme: ButtonMainTheme::from($theme), attributes: ['onclick' => 'var b=document.querySelector(\'#ui-menu-badge-' . $theme . ' .btn-menu\'); var n=b.querySelector(\'.btn-menu__badge:not([data-sf-leaving])\'); SfUi.menuBadge(b, String((n ? +n.textContent : 0) + 1))']) ?>
</div>
