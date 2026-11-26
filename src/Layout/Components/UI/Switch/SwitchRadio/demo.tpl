<?php

/**
 * Демо RadioOption: размеры × положение подписи, выбранный, отключённый (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\Layout as Radio;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\SwitchRadioPosition;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\SwitchRadioSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\SwitchRadioTheme;

$radioTheme = SwitchRadioTheme::from($theme);

?>
<?php foreach (SwitchRadioSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (SwitchRadioPosition::cases() as $position): ?>
            <?php $id = 'ui-radio-' . $theme . '-' . $size->name . '-' . $position->name; ?>
            <?= Radio::drawSwitchRadio(
                text: $position->name,
                id: $id,
                size: $size,
                theme: $radioTheme,
                position: $position,
            ) ?>
            <?= Radio::drawSwitchRadio(
                text: 'checked',
                id: $id . '-checked',
                size: $size,
                theme: $radioTheme,
                position: $position,
                attributes: ['checked' => 'checked'],
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Состояния</h3>
<div class="ui-showcase__row">
    <?= Radio::drawSwitchRadio(
        text: 'disabled',
        id: 'ui-radio-disabled-' . $theme,
        theme: $radioTheme,
        attributes: ['disabled' => 'disabled'],
    ) ?>
    <?= Radio::drawSwitchRadio(
        text: 'disabled, checked',
        id: 'ui-radio-disabled-checked-' . $theme,
        theme: $radioTheme,
        attributes: ['disabled' => 'disabled', 'checked' => 'checked'],
    ) ?>
</div>
