<?php

/**
 * Демо Maintenance: страница работ с логотипом и кнопкой, и короткая (витрина Layout\LayoutShowcase).
 * Страница выведена в рамке (inline), на сайте она занимает весь экран
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\System\SystemMaintenance\Layout as Maintenance;
use Simflex\Core\Layout\Components\Parts\System\SystemMaintenance\SystemMaintenanceTheme;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogo\Layout as BrandLogo;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogo\BrandLogoTheme;

$maintenanceTheme = SystemMaintenanceTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">С логотипом и кнопкой</h3>
<div class="ui-showcase__row">
    <?= Maintenance::drawSystemMaintenance(
        theme: $maintenanceTheme,
        buttonLink: 'mailto:info@example.com',
        logoHtml: BrandLogo::drawBrandLogo(name: 'Мой сайт', theme: BrandLogoTheme::from($theme)),
        inline: true,
    ) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Без кнопки, свои тексты</h3>
<div class="ui-showcase__row">
    <?= Maintenance::drawSystemMaintenance(
        theme: $maintenanceTheme,
        title: 'Идут технические работы',
        text: 'Сайт будет доступен сегодня после 18:00.',
        inline: true,
    ) ?>
</div>
