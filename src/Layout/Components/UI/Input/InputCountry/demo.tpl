<?php

/**
 * Демо InputCountry: кнопка страны, с открытым списком, недоступная (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputCountry\Layout as InputCountry;
use Simflex\Core\Layout\Components\UI\Input\InputPhone\InputPhoneCountry;

?>
<div class="ui-showcase__row">
    <?= InputCountry::drawInputCountry(InputPhoneCountry::Ru, theme: $theme) ?>
    <?= InputCountry::drawInputCountry(InputPhoneCountry::Kz, theme: $theme) ?>
    <?= InputCountry::drawInputCountry(InputPhoneCountry::Ru, open: true, theme: $theme) ?>
    <?= InputCountry::drawInputCountry(InputPhoneCountry::Ru, disabled: true, theme: $theme) ?>
</div>
