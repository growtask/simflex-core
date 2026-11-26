<?php

/**
 * Демо PaymentLogo: все знаки в трёх вариантах, знак со ссылкой (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo\PaymentLogoSystem;
use Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo\Layout as PaymentLogo;
use Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo\PaymentLogoStyle;

?>
<?php foreach (PaymentLogoStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <?php /* знаки для тёмного фона кладём на тёмную подложку, на светлой они не видны */ ?>
    <div class="ui-showcase__row"<?= $style === PaymentLogoStyle::MonochromeDark ? ' style="background: var(--color-main-gray-black); padding: 20px;"' : '' ?>>
        <?php foreach (PaymentLogoSystem::cases() as $system): ?>
            <?= PaymentLogo::drawPaymentLogo($system, $style) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Ссылка</h3>
<div class="ui-showcase__row">
    <?= PaymentLogo::drawPaymentLogo(PaymentLogoSystem::GooglePay, href: '#google-pay') ?>
</div>
