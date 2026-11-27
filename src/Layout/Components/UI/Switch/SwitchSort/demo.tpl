<?php

/**
 * Демо SwitchSort: направление × стиль (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchSort\Layout as Sort;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SwitchSortButtonStyle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SwitchSortButtonTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSort\SwitchSortDirection;

$sortTheme = SwitchSortButtonTheme::from($theme);

?>
<div class="ui-showcase__row">
    <?php foreach (SwitchSortDirection::cases() as $direction): ?>
        <?php foreach (SwitchSortButtonStyle::cases() as $style): ?>
            <?= Sort::drawSwitchSort('Название', '#asc', '#desc', $direction, $style, $sortTheme) ?>
        <?php endforeach; ?>
    <?php endforeach; ?>
</div>
<h3 class="ui-showcase__subtitle ui-m">Сортировка на месте (кнопки без ссылок): индикатор переезжает к выбранной стрелке</h3>
<div class="ui-showcase__row">
    <?php foreach (SwitchSortButtonStyle::cases() as $style): ?>
        <?= Sort::drawSwitchSort('Цена', '', '', SwitchSortDirection::Ascending, $style, $sortTheme) ?>
    <?php endforeach; ?>
</div>
