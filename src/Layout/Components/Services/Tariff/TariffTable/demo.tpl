<?php

/**
 * Демо TariffTable: три тарифа, восемь возможностей с подсказками, рекомендуемая колонка; вид телефона с выбором
 * тарифа (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Services\Tariff\TariffTable\Layout as TariffTable;
use Simflex\Core\Layout\Components\Services\Tariff\TariffTable\TariffTablePlan;
use Simflex\Core\Layout\Components\Services\Tariff\TariffTable\TariffTableTheme;

$plans = [
    ['name' => 'Базовый', 'price' => '5 000 ₽'],
    ['name' => 'Стандарт', 'price' => '10 000 ₽', 'featured' => true],
    ['name' => 'Премиум', 'price' => '20 000 ₽'],
];
$features = [];
for ($i = 1; $i <= 8; $i++) {
    $features[] = ['text' => 'Функция ' . $i, 'hint' => $i === 1 ? 'Пояснение к функции' : '', 'values' => [$i <= 6, $i <= 7, true]];
}
$tableTheme = TariffTableTheme::from($theme);

?>
<?= TariffTable::drawTariffTable($plans, $features, theme: $tableTheme) ?>
<h3 class="ui-showcase__subtitle ui-m">Вид телефона: селектор переключает тариф</h3>
<div class="ui-showcase__row" style="align-items:flex-start;flex-wrap:wrap">
    <?php foreach (TariffTablePlan::cases() as $plan): ?>
        <div style="width:382px"><?= TariffTable::drawTariffTable($plans, $features, plan: $plan, theme: $tableTheme, className: 'tariff-table_view_mobile') ?></div>
    <?php endforeach; ?>
</div>
<h3 class="ui-showcase__subtitle ui-m">Без кнопок</h3>
<?= TariffTable::drawTariffTable($plans, array_slice($features, 0, 3), buttons: false, theme: $tableTheme) ?>
