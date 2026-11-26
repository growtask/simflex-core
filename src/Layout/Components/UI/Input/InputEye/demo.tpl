<?php

/**
 * Демо InputEye: обычная, нажатая и недоступная (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallTheme;
use Simflex\Core\Layout\Components\UI\Input\InputEye\Layout as InputEye;

$eyeTheme = ButtonIconSmallTheme::from($theme);

?>
<div class="ui-showcase__row">
    <?= InputEye::drawInputEye(theme: $eyeTheme) ?>
    <?= InputEye::drawInputEye(active: true, theme: $eyeTheme) ?>
    <?= InputEye::drawInputEye(disabled: true, theme: $eyeTheme) ?>
</div>
