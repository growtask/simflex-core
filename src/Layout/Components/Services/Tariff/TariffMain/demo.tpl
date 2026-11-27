<?php

/**
 * Демо TariffMain: обычный, рекомендуемый и недоступный тариф; возможности с описанием, подсказкой и «не входит»
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Services\Tariff\TariffMain\Layout as Tariff;
use Simflex\Core\Layout\Components\Services\Tariff\TariffMain\TariffMainTheme;

$tariffTheme = TariffMainTheme::from($theme);
$features = [
    ['text' => 'Дизайн по шаблону', 'hint' => 'Готовый шаблон с вашими цветами и логотипом'],
    ['text' => 'До 10 страниц', 'description' => 'Каталог, контакты, о компании'],
    ['text' => 'Форма заявки'],
    ['text' => 'Интеграция с CRM', 'included' => false],
];
$base = ['name' => 'Стандарт', 'description' => 'Для небольших проектов', 'price' => '10 000 ₽', 'period' => '/ проект',
    'oldPrice' => '12 000 ₽', 'discount' => '-17%', 'features' => $features, 'theme' => $tariffTheme];

?>
<div class="ui-showcase__row" style="align-items:stretch;flex-wrap:wrap">
    <div style="width:360px;display:flex"><?= Tariff::drawTariffMain(...$base) ?></div>
    <div style="width:360px;display:flex"><?= Tariff::drawTariffMain(...$base, label: 'Хит', featured: true, buttonText: 'Выбрать тариф') ?></div>
    <div style="width:360px;display:flex"><?= Tariff::drawTariffMain(...$base, disabled: true) ?></div>
    <div style="width:340px;display:flex"><?= Tariff::drawTariffMain(name: 'Базовый', price: 'Бесплатно', features: [['text' => 'Одна страница']], theme: $tariffTheme) ?></div>
</div>
