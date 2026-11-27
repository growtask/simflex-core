<?php

/**
 * Демо PriceMain: цена и «По запросу», виды Default, Compact и Sticky (в потоке), вид телефона, «Недоступно»
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Services\Price\PriceMain\Layout as Price;
use Simflex\Core\Layout\Components\Services\Price\PriceMain\PriceMainStyle;
use Simflex\Core\Layout\Components\Services\Price\PriceMain\PriceMainTheme;
use Simflex\Core\Layout\Components\Services\Price\PriceMain\PriceMainType;

$priceTheme = PriceMainTheme::from($theme);
$full = ['price' => '10 000 ₽', 'from' => 'от', 'unit' => '/ проект', 'oldPrice' => '12 000 ₽', 'discount' => '-17%', 'time' => '10 часов'];

?>
<?php foreach (PriceMainStyle::cases() as $style): ?>
    <?php foreach (PriceMainType::cases() as $type): ?>
        <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?>, <?= $type->name ?></h3>
        <div class="ui-showcase__row" style="align-items:flex-start">
            <div style="width:<?= $style === PriceMainStyle::Sticky ? 414 : 640 ?>px">
                <?= Price::drawPriceMain(...$full, type: $type, style: $style, theme: $priceTheme, inline: true) ?>
            </div>
            <?php if ($style === PriceMainStyle::Default): ?>
                <div style="width:382px">
                    <?= Price::drawPriceMain(...$full, type: $type, style: $style, theme: $priceTheme, className: 'price_view_mobile') ?>
                </div>
            <?php endif; ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>
<h3 class="ui-showcase__subtitle ui-m">Услугу нельзя заказать; только цена</h3>
<div class="ui-showcase__row" style="align-items:flex-start">
    <div style="width:640px"><?= Price::drawPriceMain(...$full, unavailable: true, theme: $priceTheme) ?></div>
    <div style="width:640px"><?= Price::drawPriceMain(price: '5 000 ₽', askText: '', theme: $priceTheme) ?></div>
</div>
