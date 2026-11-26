<?php

/**
 * Демо PaymentList: ряд всех знаков и выбранных, одноцветный вариант (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo\PaymentSystem;
use Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo\PaymentStyle;
use Simflex\Core\Layout\Components\Parts\Payment\PaymentList\Layout as PaymentList;

$style = $theme === 'dark' ? PaymentStyle::MonochromeDark : PaymentStyle::Monochrome;

?>
<h3 class="ui-showcase__subtitle ui-m">Все</h3>
<div class="ui-showcase__row">
    <?= PaymentList::drawPaymentList() ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Выбранные, одноцветные</h3>
<div class="ui-showcase__row">
    <?= PaymentList::drawPaymentList([PaymentSystem::GooglePay, PaymentSystem::Mastercard, PaymentSystem::Maestro], $style) ?>
</div>
