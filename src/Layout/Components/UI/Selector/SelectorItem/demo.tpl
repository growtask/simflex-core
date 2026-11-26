<?php

/**
 * Демо SelectorItem: стиль × размер × состояние (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Selector\SelectorItem\Layout as SelectorItem;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorMainSize;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorMainStyle;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorMainTheme;

$selectorTheme = SelectorMainTheme::from($theme);

?>
<?php foreach (SelectorMainStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <?php foreach (SelectorMainSize::cases() as $size): ?>
        <div class="ui-showcase__row">
            <?= SelectorItem::drawSelectorItem('Месяц', style: $style, size: $size, theme: $selectorTheme) ?>
            <?= SelectorItem::drawSelectorItem('Месяц', active: true, style: $style, size: $size, theme: $selectorTheme) ?>
            <?= SelectorItem::drawSelectorItem('Список', icon: 'plus', badge: '3', style: $style, size: $size, theme: $selectorTheme) ?>
            <?= SelectorItem::drawSelectorItem('Недоступно', disabled: true, style: $style, size: $size, theme: $selectorTheme) ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>
