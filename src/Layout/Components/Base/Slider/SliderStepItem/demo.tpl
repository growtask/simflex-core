<?php

/**
 * Демо SliderStepItem: полоска обычная и активная, размеры m и s (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Slider\SliderStep\SliderStepSize;
use Simflex\Core\Layout\Components\Base\Slider\SliderStep\SliderStepTheme;
use Simflex\Core\Layout\Components\Base\Slider\SliderStepItem\Layout as SliderStepItem;

?>
<?php foreach (SliderStepSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?= SliderStepItem::drawSliderStepItem(size: $size, theme: SliderStepTheme::from($theme)) ?>
        <?= SliderStepItem::drawSliderStepItem(active: true, size: $size, theme: SliderStepTheme::from($theme)) ?>
    </div>
<?php endforeach; ?>
