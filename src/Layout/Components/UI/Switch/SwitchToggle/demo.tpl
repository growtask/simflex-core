<?php

/**
 * Демо ToggleSwitch: размеры × положение подписи, с иконкой и без, включённый, отключённый
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\Layout as Toggle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\TogglePosition;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\ToggleSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\ToggleTheme;

$toggleTheme = ToggleTheme::from($theme);

?>
<?php foreach (ToggleSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (TogglePosition::cases() as $position): ?>
            <?= Toggle::drawToggle(
                text: $position->name,
                size: $size,
                theme: $toggleTheme,
                position: $position,
            ) ?>
            <?= Toggle::drawToggle(
                text: 'checked',
                size: $size,
                theme: $toggleTheme,
                position: $position,
                attributes: ['checked' => 'checked'],
            ) ?>
            <?= Toggle::drawToggle(
                text: 'без иконки',
                icon: false,
                size: $size,
                theme: $toggleTheme,
                position: $position,
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Состояния</h3>
<div class="ui-showcase__row">
    <?= Toggle::drawToggle(text: 'disabled', theme: $toggleTheme, attributes: ['disabled' => 'disabled']) ?>
    <?= Toggle::drawToggle(
        text: 'disabled, checked',
        theme: $toggleTheme,
        attributes: ['disabled' => 'disabled', 'checked' => 'checked'],
    ) ?>
</div>
