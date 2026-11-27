<?php

/**
 * Демо GeoModal: кнопка города с живым окном (вопрос при загрузке выключен), открытое окно desktop и mobile
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Geo\GeoModal\GeoModalStyle;
use Simflex\Core\Layout\Components\Base\Geo\GeoModal\GeoModalTheme;
use Simflex\Core\Layout\Components\Base\Geo\GeoModal\Layout as GeoModal;

$cities = ['Москва', 'Московский', 'Мурманск', 'Мытищи', 'Набережные Челны', 'Нижний Новгород', 'Новосибирск', 'Омск'];
$geoTheme = GeoModalTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">Живое окно: нажмите на город</h3>
<div class="ui-showcase__row" style="min-height:320px;align-items:flex-start">
    <?= GeoModal::drawGeoModal(guess: 'Москва', cities: $cities, storageKey: 'ui-geo-' . $theme, theme: $geoTheme) ?>
</div>
<?php foreach (GeoModalStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m">Открытое окно: <?= $style->name ?></h3>
    <div class="ui-showcase__row" style="align-items:flex-start">
        <div style="width:<?= $style === GeoModalStyle::Mobile ? 382 : 420 ?>px">
            <?= GeoModal::drawGeoModal(guess: 'Москва', cities: $cities, theme: $geoTheme, open: true, style: $style) ?>
        </div>
    </div>
<?php endforeach; ?>
