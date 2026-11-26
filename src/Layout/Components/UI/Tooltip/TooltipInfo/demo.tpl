<?php

/**
 * Демо TooltipInfo: иконка «i» во всех положениях (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Tooltip\TooltipInfo\Layout as TooltipInfo;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainPosition;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainTheme;

$tooltipTheme = TooltipMainTheme::from($theme);

?>
<div class="ui-showcase__row ui-showcase__row_tooltips">
    <?php foreach (TooltipMainPosition::cases() as $position): ?>
        <?= TooltipInfo::drawTooltipInfo('Короткое пояснение термина', $tooltipTheme, $position) ?>
    <?php endforeach; ?>
</div>
