<?php

/**
 * Демо Checkbox: размеры × стили × положение подписи, отмеченный, отключённый, ошибка, согласие
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxPosition;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxStyle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\Layout as Checkbox;

$checkboxTheme = SwitchCheckboxTheme::from($theme);

?>
<?php foreach (SwitchCheckboxSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (SwitchCheckboxStyle::cases() as $style): ?>
            <?php foreach (SwitchCheckboxPosition::cases() as $position): ?>
                <?= Checkbox::drawSwitchCheckbox(
                    text: $style->name . ', ' . $position->name,
                    style: $style,
                    size: $size,
                    theme: $checkboxTheme,
                    position: $position,
                ) ?>
                <?= Checkbox::drawSwitchCheckbox(
                    text: 'checked',
                    style: $style,
                    size: $size,
                    theme: $checkboxTheme,
                    position: $position,
                    attributes: ['checked' => 'checked'],
                ) ?>
            <?php endforeach; ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Состояния</h3>
<div class="ui-showcase__row">
    <?= Checkbox::drawSwitchCheckbox(text: 'disabled', theme: $checkboxTheme, attributes: ['disabled' => 'disabled']) ?>
    <?= Checkbox::drawSwitchCheckbox(
        text: 'disabled, checked',
        theme: $checkboxTheme,
        attributes: ['disabled' => 'disabled', 'checked' => 'checked'],
    ) ?>
    <?= Checkbox::drawSwitchCheckbox(text: 'Ошибка', theme: $checkboxTheme, error: true) ?>
    <?= Checkbox::drawSwitchCheckbox(text: 'Согласие с политикой', theme: $checkboxTheme, policy: true) ?>
</div>
