<?php

/**
 * Демо TooltipRich: положение × сторона, с иконкой и без действия (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipPosition;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipSide;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipTheme;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipRich\Layout as TooltipRich;

$tooltipTheme = TooltipTheme::from($theme);
$buttonTheme = ButtonTheme::from($theme);

?>
<?php foreach (TooltipPosition::cases() as $position): ?>
    <div class="ui-showcase__row ui-showcase__row_tooltips">
        <?php foreach (TooltipSide::cases() as $side): ?>
            <?= TooltipRich::drawRich(
                Button::drawButton(
                    text: $position->name . ', ' . $side->name,
                    style: ButtonStyle::Secondary,
                    size: ButtonSize::Small,
                    theme: $buttonTheme,
                ),
                title: 'Заголовок',
                text: 'Короткое пояснение, которое переносится на несколько строк',
                actionText: 'Подробнее',
                actionLink: '#rich',
                icon: $side === TooltipSide::Center ? 'notify-info' : '',
                position: $position,
                side: $side,
                theme: $tooltipTheme,
            ) ?>
        <?php endforeach; ?>
        <?= TooltipRich::drawRich(
            Button::drawButton(text: 'Без действия', style: ButtonStyle::Secondary, size: ButtonSize::Small, theme: $buttonTheme),
            title: 'Только заголовок и текст',
            text: 'Действие необязательно',
            position: $position,
            theme: $tooltipTheme,
        ) ?>
    </div>
<?php endforeach; ?>
