<?php

/**
 * Демо InputFlag: все флаги (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputFlag\Layout as InputFlag;
use Simflex\Core\Layout\Components\UI\Input\InputPhone\PhoneCountry;

?>
<div class="ui-showcase__row">
    <?php foreach (PhoneCountry::cases() as $country): ?>
        <?= InputFlag::drawInputFlag($country) ?>
    <?php endforeach; ?>
</div>
