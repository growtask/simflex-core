<?php

/**
 * Демо GeoList: список городов и «Ничего не найдено», вид desktop и mobile (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Geo\GeoList\GeoListStyle;
use Simflex\Core\Layout\Components\Base\Geo\GeoList\GeoListTheme;
use Simflex\Core\Layout\Components\Base\Geo\GeoList\Layout as GeoList;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;

$cities = ['Москва', 'Московский', 'Мурманск', 'Мытищи', 'Набережные Челны', 'Нижний Новгород'];
// пункты списка — вкладки Tabs/main: стили вкладки подключаются отрисовкой
Tab::drawTabMain(text: '');

?>
<?php foreach (GeoListStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <div class="ui-showcase__row" style="align-items:flex-start">
        <div style="width:360px"><?= GeoList::drawGeoList($cities, 'ui-geo-list-' . $style->value . '-' . $theme, $style, GeoListTheme::from($theme)) ?></div>
        <div style="width:360px"><?= GeoList::drawGeoList($cities, 'ui-geo-empty-' . $style->value . '-' . $theme, $style, GeoListTheme::from($theme), empty: true) ?></div>
    </div>
<?php endforeach; ?>
