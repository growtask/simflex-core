<?php

/**
 * Демо InputCountryItem: страны, выбранная (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputCountryItem\Layout as InputCountryItem;
use Simflex\Core\Layout\Components\UI\Input\InputPhone\InputPhoneCountry;

?>
<div class="ui-showcase__row">
    <?php foreach (InputPhoneCountry::cases() as $country): ?>
        <?= InputCountryItem::drawInputCountryItem($country, $country === InputPhoneCountry::Ru, $theme) ?>
    <?php endforeach; ?>
</div>
