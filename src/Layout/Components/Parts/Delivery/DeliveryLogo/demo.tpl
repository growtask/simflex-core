<?php

/**
 * Демо DeliveryLogo: все знаки в трёх вариантах, знак со ссылкой (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\Delivery\DeliveryLogo\DeliveryService;
use Simflex\Core\Layout\Components\Parts\Delivery\DeliveryLogo\Layout as DeliveryLogo;
use Simflex\Core\Layout\Components\Parts\Delivery\DeliveryLogo\DeliveryStyle;

?>
<?php foreach (DeliveryStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <?php /* знаки для тёмного фона кладём на тёмную подложку, на светлой они не видны */ ?>
    <div class="ui-showcase__row"<?= $style === DeliveryStyle::MonochromeDark ? ' style="background: var(--color-main-gray-black); padding: 20px;"' : '' ?>>
        <?php foreach (DeliveryService::cases() as $service): ?>
            <?= DeliveryLogo::drawDeliveryLogo($service, $style) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Ссылка</h3>
<div class="ui-showcase__row">
    <?= DeliveryLogo::drawDeliveryLogo(DeliveryService::FivePost, href: '#5post') ?>
</div>
