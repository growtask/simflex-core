<?php

/**
 * Демо InputFlag: все флаги (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputFlag\Layout as InputFlag;
use Simflex\Core\Layout\Components\UI\Input\InputPhone\InputPhoneCountry;

?>
<div class="ui-showcase__row">
    <?php foreach (InputPhoneCountry::cases() as $country): ?>
        <?= InputFlag::drawInputFlag($country) ?>
    <?php endforeach; ?>
</div>
