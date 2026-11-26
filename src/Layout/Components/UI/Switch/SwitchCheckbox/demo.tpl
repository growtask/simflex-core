<?php

/**
 * Демо Checkbox: размеры × стили × положение подписи, отмеченный, отключённый, ошибка, согласие
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\CheckboxPosition;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\CheckboxSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\CheckboxStyle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\CheckboxTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\Layout as Checkbox;

$checkboxTheme = CheckboxTheme::from($theme);

?>
<?php foreach (CheckboxSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (CheckboxStyle::cases() as $style): ?>
            <?php foreach (CheckboxPosition::cases() as $position): ?>
                <?= Checkbox::drawCheckbox(
                    text: $style->name . ', ' . $position->name,
                    style: $style,
                    size: $size,
                    theme: $checkboxTheme,
                    position: $position,
                ) ?>
                <?= Checkbox::drawCheckbox(
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
    <?= Checkbox::drawCheckbox(text: 'disabled', theme: $checkboxTheme, attributes: ['disabled' => 'disabled']) ?>
    <?= Checkbox::drawCheckbox(
        text: 'disabled, checked',
        theme: $checkboxTheme,
        attributes: ['disabled' => 'disabled', 'checked' => 'checked'],
    ) ?>
    <?= Checkbox::drawCheckbox(text: 'Ошибка', theme: $checkboxTheme, error: true) ?>
    <?= Checkbox::drawCheckbox(text: 'Согласие с политикой', theme: $checkboxTheme, policy: true) ?>
</div>
