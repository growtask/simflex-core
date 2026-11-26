<?php

/**
 * Демо DeliveryList: ряд всех знаков и выбранных, одноцветный вариант (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\Delivery\DeliveryLogo\DeliveryLogoService;
use Simflex\Core\Layout\Components\Parts\Delivery\DeliveryLogo\DeliveryLogoStyle;
use Simflex\Core\Layout\Components\Parts\Delivery\DeliveryList\Layout as DeliveryList;

$style = $theme === 'dark' ? DeliveryLogoStyle::MonochromeDark : DeliveryLogoStyle::Monochrome;

?>
<h3 class="ui-showcase__subtitle ui-m">Все</h3>
<div class="ui-showcase__row">
    <?= DeliveryList::drawDeliveryList() ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Выбранные, одноцветные</h3>
<div class="ui-showcase__row">
    <?= DeliveryList::drawDeliveryList([DeliveryLogoService::FivePost, DeliveryLogoService::Ozon, DeliveryLogoService::Cdek], $style) ?>
</div>
