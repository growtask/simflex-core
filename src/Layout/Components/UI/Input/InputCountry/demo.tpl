<?php

/**
 * Демо InputCountry: кнопка страны, с открытым списком, недоступная (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputCountry\Layout as InputCountry;
use Simflex\Core\Layout\Components\UI\Input\InputPhone\PhoneCountry;

?>
<div class="ui-showcase__row">
    <?= InputCountry::drawInputCountry(PhoneCountry::Ru, theme: $theme) ?>
    <?= InputCountry::drawInputCountry(PhoneCountry::Kz, theme: $theme) ?>
    <?= InputCountry::drawInputCountry(PhoneCountry::Ru, open: true, theme: $theme) ?>
    <?= InputCountry::drawInputCountry(PhoneCountry::Ru, disabled: true, theme: $theme) ?>
</div>
