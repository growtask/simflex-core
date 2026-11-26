<?php

/**
 * Демо BadgeStock: размеры × стили наличия (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Other\BadgeStock\BadgeStockSize;
use Simflex\Core\Layout\Components\UI\Other\BadgeStock\BadgeStockStyle;
use Simflex\Core\Layout\Components\UI\Other\BadgeStock\Layout as BadgeStock;

?>
<?php foreach (BadgeStockSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (BadgeStockStyle::cases() as $style): ?>
            <?= BadgeStock::drawBadge(text: $style->name, style: $style, size: $size) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
