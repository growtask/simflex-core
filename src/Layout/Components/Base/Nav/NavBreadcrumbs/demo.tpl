<?php

/**
 * Демо NavBreadcrumbs: длинный и короткий путь, без кнопки «домой» (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Nav\NavBreadcrumbs\Layout as NavBreadcrumbs;
use Simflex\Core\Layout\Components\Base\Nav\NavBreadcrumbs\NavBreadcrumbsTheme;

$theme = NavBreadcrumbsTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">Длинный путь (на телефоне середина сворачивается в «…»)</h3>
<div class="ui-showcase__row">
    <?= NavBreadcrumbs::drawNavBreadcrumbs([
        ['name' => 'Каталог', 'link' => '#catalog'],
        ['name' => 'Мебель', 'link' => '#furniture'],
        ['name' => 'Диваны', 'link' => '#sofas'],
        ['name' => 'Угловые диваны', 'link' => '#corner'],
        ['name' => 'Диван Модерн'],
    ], homeLink: '#home', theme: $theme) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Короткий путь</h3>
<div class="ui-showcase__row">
    <?= NavBreadcrumbs::drawNavBreadcrumbs([
        ['name' => 'Каталог', 'link' => '#catalog'],
        ['name' => 'Мебель'],
    ], homeLink: '#home', theme: $theme) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Без кнопки «домой»</h3>
<div class="ui-showcase__row">
    <?= NavBreadcrumbs::drawNavBreadcrumbs([
        ['name' => 'Настройки', 'link' => '#settings'],
        ['name' => 'Профиль'],
    ], homeLink: '', theme: $theme) ?>
</div>
