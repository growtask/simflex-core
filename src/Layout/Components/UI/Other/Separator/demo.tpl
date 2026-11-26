<?php

/**
 * Демо Separator: горизонтальный и вертикальный (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Other\Separator\Layout as Separator;
use Simflex\Core\Layout\Components\UI\Other\Separator\SeparatorOrientation;
use Simflex\Core\Layout\Components\UI\Other\Separator\SeparatorTheme;

$separatorTheme = SeparatorTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m"><?= SeparatorOrientation::Horizontal->name ?></h3>
<p>Текст до разделителя</p>
<?= Separator::drawSeparator(orientation: SeparatorOrientation::Horizontal, theme: $separatorTheme) ?>
<p>Текст после разделителя</p>

<h3 class="ui-showcase__subtitle ui-m"><?= SeparatorOrientation::Vertical->name ?></h3>
<div class="ui-showcase__row">
    <span>Слева</span>
    <?= Separator::drawSeparator(orientation: SeparatorOrientation::Vertical, theme: $separatorTheme) ?>
    <span>Справа</span>
</div>
