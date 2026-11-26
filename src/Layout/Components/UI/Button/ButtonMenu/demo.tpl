<?php

/**
 * Демо ButtonMenu: расположение × размеры × стили, с иконкой и бейджем, без подписи, без иконки
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

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
