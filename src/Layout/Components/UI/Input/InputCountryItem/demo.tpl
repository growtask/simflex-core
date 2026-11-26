<?php

/**
 * Демо InputCountryItem: страны, выбранная (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputCountryItem\Layout as InputCountryItem;
use Simflex\Core\Layout\Components\UI\Input\InputPhone\PhoneCountry;

?>
<div class="ui-showcase__row">
    <?php foreach (PhoneCountry::cases() as $country): ?>
        <?= InputCountryItem::drawInputCountryItem($country, $country === PhoneCountry::Ru, $theme) ?>
    <?php endforeach; ?>
</div>
