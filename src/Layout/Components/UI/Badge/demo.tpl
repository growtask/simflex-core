<?php

/**
 * Демо Badge: все размеры и стили, точка, иконка (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Badge\BadgeSize;
use Simflex\Core\Layout\Components\UI\Badge\BadgeStyle;
use Simflex\Core\Layout\Components\UI\Badge\Layout as Badge;

?>
<?php foreach (BadgeSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (BadgeStyle::cases() as $style): ?>
            <?= Badge::drawBadge(text: $style->name, style: $style, size: $size) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">С иконкой и точкой</h3>
<div class="ui-showcase__row">
    <?php foreach (BadgeSize::cases() as $size): ?>
        <?= Badge::drawBadge(text: 'icon', icon: 'check', size: $size) ?>
        <?= Badge::drawBadge(text: 'dot', dot: true, size: $size) ?>
    <?php endforeach; ?>
</div>
