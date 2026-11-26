<?php

/**
 * Демо RadioOption: размеры × положение подписи, выбранный, отключённый (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\Layout as Radio;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\RadioPosition;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\RadioSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\RadioTheme;

$radioTheme = RadioTheme::from($theme);

?>
<?php foreach (RadioSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (RadioPosition::cases() as $position): ?>
            <?php $id = 'ui-radio-' . $theme . '-' . $size->name . '-' . $position->name; ?>
            <?= Radio::drawRadio(
                text: $position->name,
                id: $id,
                size: $size,
                theme: $radioTheme,
                position: $position,
            ) ?>
            <?= Radio::drawRadio(
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
    <?= Radio::drawRadio(
        text: 'disabled',
        id: 'ui-radio-disabled-' . $theme,
        theme: $radioTheme,
        attributes: ['disabled' => 'disabled'],
    ) ?>
    <?= Radio::drawRadio(
        text: 'disabled, checked',
        id: 'ui-radio-disabled-checked-' . $theme,
        theme: $radioTheme,
        attributes: ['disabled' => 'disabled', 'checked' => 'checked'],
    ) ?>
</div>
