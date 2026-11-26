<?php

/**
 * Демо TooltipRich: положение × сторона, с иконкой и без действия (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainPosition;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainSide;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainTheme;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipRich\Layout as TooltipRich;

$tooltipTheme = TooltipMainTheme::from($theme);
$buttonTheme = ButtonMainTheme::from($theme);

?>
<?php foreach (TooltipMainPosition::cases() as $position): ?>
    <div class="ui-showcase__row ui-showcase__row_tooltips">
        <?php foreach (TooltipMainSide::cases() as $side): ?>
            <?= TooltipRich::drawTooltipRich(
                Button::drawButtonMain(
                    text: $position->name . ', ' . $side->name,
                    style: ButtonMainStyle::Secondary,
                    size: ButtonMainSize::Small,
                    theme: $buttonTheme,
                ),
                title: 'Заголовок',
                text: 'Короткое пояснение, которое переносится на несколько строк',
                actionText: 'Подробнее',
                actionLink: '#rich',
                icon: $side === TooltipMainSide::Center ? 'notify-info' : '',
                position: $position,
                side: $side,
                theme: $tooltipTheme,
            ) ?>
        <?php endforeach; ?>
        <?= TooltipRich::drawTooltipRich(
            Button::drawButtonMain(text: 'Без действия', style: ButtonMainStyle::Secondary, size: ButtonMainSize::Small, theme: $buttonTheme),
            title: 'Только заголовок и текст',
            text: 'Действие необязательно',
            position: $position,
            theme: $tooltipTheme,
        ) ?>
    </div>
<?php endforeach; ?>
