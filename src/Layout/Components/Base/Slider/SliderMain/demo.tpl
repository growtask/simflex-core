<?php

/**
 * Демо SliderMain: стрелки, индикатор шагов и без управления, карточки m и s, вид планшета и телефона, без
 * заголовка (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Slider\SliderMain\Layout as Slider;
use Simflex\Core\Layout\Components\Base\Slider\SliderMain\SliderMainStep;
use Simflex\Core\Layout\Components\Base\Slider\SliderMain\SliderMainTheme;
use Simflex\Core\Layout\Components\Base\Slider\SliderMain\SliderMainType;

$sliderTheme = SliderMainTheme::from($theme);
$cards = [];
for ($i = 1; $i <= 9; $i++) {
    $cards[] = '<a href="#card-' . $i . '" style="display:flex;flex-direction:column;justify-content:flex-end;box-sizing:border-box;'
        . 'min-height:180px;padding:20px;border-radius:var(--radius-ui-large);text-decoration:none;'
        . 'background:var(--color-main-gray-' . ($theme === 'dark' ? 'darker' : 'lighter') . ');'
        . 'color:var(--color-text-icon-gray-' . ($theme === 'dark' ? 'white' : 'darker') . ')">'
        . '<strong>Карточка ' . $i . '</strong><span>Любое содержимое слайда</span></a>';
}

?>
<?php foreach (SliderMainType::cases() as $type): ?>
    <?php foreach (SliderMainStep::cases() as $step): ?>
        <h3 class="ui-showcase__subtitle ui-m"><?= $type->name ?>, карточки <?= $step->name ?></h3>
        <?= Slider::drawSliderMain(
            cards: $cards,
            title: 'Популярное',
            type: $type,
            step: $step,
            theme: $sliderTheme,
            allLink: '#all',
        ) ?>
    <?php endforeach; ?>
<?php endforeach; ?>
<h3 class="ui-showcase__subtitle ui-m">Вид планшета: «Показать все» под рядом</h3>
<div style="max-width:736px">
    <?= Slider::drawSliderMain(cards: $cards, title: 'Популярное', type: SliderMainType::Steps, theme: $sliderTheme,
        allLink: '#all', className: 'slider_view_tablet') ?>
</div>
<h3 class="ui-showcase__subtitle ui-m">Вид телефона: без стрелок, мелкие карточки</h3>
<div style="max-width:382px">
    <?= Slider::drawSliderMain(cards: $cards, title: 'Популярное', type: SliderMainType::Steps, step: SliderMainStep::Small,
        theme: $sliderTheme, allLink: '#all', className: 'slider_view_mobile') ?>
</div>
<h3 class="ui-showcase__subtitle ui-m">Без заголовка (heading=false)</h3>
<?= Slider::drawSliderMain(cards: $cards, heading: false, theme: $sliderTheme) ?>
