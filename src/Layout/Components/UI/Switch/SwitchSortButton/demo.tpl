<?php

/**
 * Демо SwitchSortButton: размеры × стили, активная кнопка со стрелкой вверх и вниз
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\Layout as SortButton;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SwitchSortButtonSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SwitchSortButtonStyle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SwitchSortButtonTheme;

$sortTheme = SwitchSortButtonTheme::from($theme);

?>
<?php foreach (SwitchSortButtonSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (SwitchSortButtonStyle::cases() as $style): ?>
            <?= SortButton::drawSwitchSortButton(
                up: true,
                label: $style->name . ', вверх',
                link: '#up',
                style: $style,
                size: $size,
                theme: $sortTheme,
            ) ?>
            <?= SortButton::drawSwitchSortButton(
                up: false,
                label: $style->name . ', вниз',
                link: '#down',
                style: $style,
                size: $size,
                theme: $sortTheme,
            ) ?>
            <?= SortButton::drawSwitchSortButton(
                up: true,
                label: 'active',
                link: '#active',
                active: true,
                style: $style,
                size: $size,
                theme: $sortTheme,
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
