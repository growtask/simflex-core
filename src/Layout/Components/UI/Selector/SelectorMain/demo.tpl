<?php

/**
 * Демо Selector: стиль × размер, ширина fill, иконки и бейдж, отключённый сегмент (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\Layout as Selector;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorMainSize;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorMainStyle;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorMainTheme;

$selectorTheme = SelectorMainTheme::from($theme);
$items = [['text' => 'День'], ['text' => 'Неделя'], ['text' => 'Месяц']];
$rich = [
    ['text' => 'Все', 'icon' => 'check', 'badge' => '-20%'],
    ['text' => 'Новые', 'icon' => 'check'],
    ['text' => 'Скоро', 'icon' => 'check', 'disabled' => true],
];

?>
<?php foreach (SelectorMainStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <?php foreach (SelectorMainSize::cases() as $size): ?>
        <div class="ui-showcase__row">
            <?= Selector::drawSelectorMain($items, $style, $size, $selectorTheme) ?>
            <?= Selector::drawSelectorMain($rich, $style, $size, $selectorTheme) ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Ширина fill</h3>
<div class="ui-showcase__field">
    <?= Selector::drawSelectorMain($items, SelectorMainStyle::Primary, SelectorMainSize::Small, $selectorTheme, fill: true) ?>
</div>
