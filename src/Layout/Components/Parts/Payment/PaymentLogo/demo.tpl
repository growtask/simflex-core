<?php

/**
 * Демо PaymentLogo: все знаки в трёх вариантах, знак со ссылкой (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo\PaymentSystem;
use Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo\Layout as PaymentLogo;
use Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo\PaymentStyle;

?>
<?php foreach (PaymentStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <?php /* знаки для тёмного фона кладём на тёмную подложку, на светлой они не видны */ ?>
    <div class="ui-showcase__row"<?= $style === PaymentStyle::MonochromeDark ? ' style="background: var(--color-main-gray-black); padding: 20px;"' : '' ?>>
        <?php foreach (PaymentSystem::cases() as $system): ?>
            <?= PaymentLogo::drawPaymentLogo($system, $style) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Ссылка</h3>
<div class="ui-showcase__row">
    <?= PaymentLogo::drawPaymentLogo(PaymentSystem::GooglePay, href: '#google-pay') ?>
</div>
