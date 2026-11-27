<?php

/**
 * Демо GeoMain: все состояния Figma (static, active, choice, dropdown, selected, empty), вид desktop и mobile
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Geo\GeoMain\GeoMainState;
use Simflex\Core\Layout\Components\Base\Geo\GeoMain\GeoMainStyle;
use Simflex\Core\Layout\Components\Base\Geo\GeoMain\GeoMainTheme;
use Simflex\Core\Layout\Components\Base\Geo\GeoMain\Layout as GeoMain;

$cities = ['Москва', 'Московский', 'Мурманск', 'Мытищи', 'Набережные Челны', 'Нижний Новгород'];
$queries = ['dropdown' => 'Мо', 'selected' => 'Мурманск', 'empty' => 'Ыы'];

?>
<?php foreach (GeoMainStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <div class="ui-showcase__row" style="align-items:flex-start;flex-wrap:wrap">
        <?php foreach (GeoMainState::cases() as $state): ?>
            <div style="width:<?= $style === GeoMainStyle::Mobile ? 382 : 360 ?>px;<?= $style === GeoMainStyle::Mobile ? 'min-height:480px;display:flex;' : 'min-height:300px;' ?>">
                <?= GeoMain::drawGeoMain(
                    city: 'Москва',
                    guess: 'Москва',
                    cities: $cities,
                    state: $state,
                    style: $style,
                    theme: GeoMainTheme::from($theme),
                    id: 'ui-geo-main-' . $style->value . '-' . $state->value . '-' . $theme,
                    query: $queries[$state->value] ?? '',
                ) ?>
            </div>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
