<?php

/**
 * Демо ButtonIcon: стили и состояния (витрина Layout\Showcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;

?>
<div class="ui-showcase__row">
    <?php foreach (ButtonIconSmallStyle::cases() as $style): ?>
        <?php foreach (['close', 'copy', 'trash', 'pencil-line'] as $icon): ?>
            <?= ButtonIcon::drawButtonIconSmall(
                icon: $icon,
                label: $icon,
                style: $style,
                theme: ButtonIconSmallTheme::from($theme),
            ) ?>
        <?php endforeach; ?>
        <?= ButtonIcon::drawButtonIconSmall(
            icon: 'close',
            label: 'disabled',
            style: $style,
            theme: ButtonIconSmallTheme::from($theme),
            disabled: true,
        ) ?>
    <?php endforeach; ?>
</div>
