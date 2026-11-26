<?php

/**
 * Демо SwitchSort: направление × стиль (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchSort\Layout as Sort;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SortButtonStyle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SortButtonTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSort\SortDirection;

$sortTheme = SortButtonTheme::from($theme);

?>
<div class="ui-showcase__row">
    <?php foreach (SortDirection::cases() as $direction): ?>
        <?php foreach (SortButtonStyle::cases() as $style): ?>
            <?= Sort::drawSort('Название', '#asc', '#desc', $direction, $style, $sortTheme) ?>
        <?php endforeach; ?>
    <?php endforeach; ?>
</div>
