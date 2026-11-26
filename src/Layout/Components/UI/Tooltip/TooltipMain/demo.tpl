<?php

/**
 * Демо TooltipMain: положение × сторона × стиль (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\Layout as Tooltip;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipPosition;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipSide;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipStyle;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipTheme;

$tooltipTheme = TooltipTheme::from($theme);
$buttonTheme = ButtonTheme::from($theme);
$text = 'Подсказка: тултип стоит с противоположной стороны от стрелки';

?>
<?php foreach (TooltipPosition::cases() as $position): ?>
    <h3 class="ui-showcase__subtitle ui-m">Положение: <?= $position->name ?></h3>
    <div class="ui-showcase__row ui-showcase__row_tooltips">
        <?php foreach (TooltipSide::cases() as $side): ?>
            <?php foreach (TooltipStyle::cases() as $style): ?>
                <?= Tooltip::drawTooltip(
                    Button::drawButton(
                        text: $side->name . ', ' . $style->name,
                        style: ButtonStyle::Secondary,
                        size: ButtonSize::Small,
                        theme: $buttonTheme,
                    ),
                    $text,
                    position: $position,
                    side: $side,
                    style: $style,
                    theme: $tooltipTheme,
                ) ?>
            <?php endforeach; ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
