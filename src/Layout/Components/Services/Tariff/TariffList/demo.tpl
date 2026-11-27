<?php

/**
 * Демо TariffList: три тарифа, период месяц и год (переключатель меняет цены), вид телефона — слайдер с точками
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Services\Tariff\TariffList\Layout as TariffList;
use Simflex\Core\Layout\Components\Services\Tariff\TariffList\TariffListPeriod;
use Simflex\Core\Layout\Components\Services\Tariff\TariffList\TariffListTheme;

$features = static fn(int $n): array => array_map(static fn(int $i): array => [
    'text' => 'Функция ' . $i,
    'included' => $i <= $n,
], range(1, 5));
$tariffs = [
    ['name' => 'Базовый', 'description' => 'Для старта', 'price' => '5 000 ₽', 'period' => '/ мес',
        'year' => ['price' => '48 000 ₽', 'period' => '/ год', 'oldPrice' => '60 000 ₽', 'discount' => '-20%'], 'features' => $features(2)],
    ['name' => 'Стандарт', 'description' => 'Для небольших проектов', 'label' => 'Хит', 'price' => '10 000 ₽', 'period' => '/ мес',
        'year' => ['price' => '96 000 ₽', 'period' => '/ год', 'oldPrice' => '120 000 ₽', 'discount' => '-20%'], 'features' => $features(4), 'featured' => true],
    ['name' => 'Премиум', 'description' => 'Для крупных проектов', 'price' => '20 000 ₽', 'period' => '/ мес',
        'year' => ['price' => '192 000 ₽', 'period' => '/ год', 'oldPrice' => '240 000 ₽', 'discount' => '-20%'], 'features' => $features(5)],
];
$listTheme = TariffListTheme::from($theme);

?>
<?php foreach (TariffListPeriod::cases() as $period): ?>
    <h3 class="ui-showcase__subtitle ui-m">Период: <?= $period->name ?> — переключатель меняет цены у всех тарифов</h3>
    <?= TariffList::drawTariffList($tariffs, $period, $listTheme, yearBadge: '-20%') ?>
<?php endforeach; ?>
<h3 class="ui-showcase__subtitle ui-m">Вид телефона: слайдер с точками</h3>
<div style="max-width:414px">
    <?= TariffList::drawTariffList($tariffs, theme: $listTheme, yearBadge: '-20%', className: 'tariff-list_view_mobile') ?>
</div>
