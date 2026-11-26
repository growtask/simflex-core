<?php

/**
 * Демо ScrollbarArrow: направление × размер (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarMainSize;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarMainTheme;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarArrow\Layout as ScrollbarArrow;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarArrow\ScrollbarArrowStyle;

$scrollbarTheme = ScrollbarMainTheme::from($theme);

?>
<?php foreach (ScrollbarMainSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (ScrollbarArrowStyle::cases() as $style): ?>
            <?= ScrollbarArrow::drawScrollbarArrow($style, $size, $scrollbarTheme) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
