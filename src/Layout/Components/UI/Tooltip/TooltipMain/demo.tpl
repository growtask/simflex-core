<?php

/**
 * Демо TooltipMain: положение × сторона × стиль (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\Layout as Tooltip;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainPosition;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainSide;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainStyle;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainTheme;

$tooltipTheme = TooltipMainTheme::from($theme);
$buttonTheme = ButtonMainTheme::from($theme);
$text = 'Подсказка: тултип стоит с противоположной стороны от стрелки';

?>
<?php foreach (TooltipMainPosition::cases() as $position): ?>
    <h3 class="ui-showcase__subtitle ui-m">Положение: <?= $position->name ?></h3>
    <div class="ui-showcase__row ui-showcase__row_tooltips">
        <?php foreach (TooltipMainSide::cases() as $side): ?>
            <?php foreach (TooltipMainStyle::cases() as $style): ?>
                <?= Tooltip::drawTooltipMain(
                    Button::drawButtonMain(
                        text: $side->name . ', ' . $style->name,
                        style: ButtonMainStyle::Secondary,
                        size: ButtonMainSize::Small,
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
