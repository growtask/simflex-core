<?php

/**
 * Демо ButtonIcon: стили и состояния (витрина Layout\Showcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;

?>
<div class="ui-showcase__row">
    <?php foreach (ButtonIconStyle::cases() as $style): ?>
        <?php foreach (['close', 'copy', 'trash', 'pencil-line'] as $icon): ?>
            <?= ButtonIcon::drawButtonIcon(
                icon: $icon,
                label: $icon,
                style: $style,
                theme: ButtonIconTheme::from($theme),
            ) ?>
        <?php endforeach; ?>
        <?= ButtonIcon::drawButtonIcon(
            icon: 'close',
            label: 'disabled',
            style: $style,
            theme: ButtonIconTheme::from($theme),
            disabled: true,
        ) ?>
    <?php endforeach; ?>
</div>
