<?php

/**
 * Демо RadioColor: размеры × 10 цветов, выбранный, отключённый (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchRadioColor\Layout as RadioColor;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadioColor\SwitchRadioColorSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadioColor\SwitchRadioColorTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadioColor\SwitchRadioColorValue;

$colorTheme = SwitchRadioColorTheme::from($theme);

?>
<?php foreach (SwitchRadioColorSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (SwitchRadioColorValue::cases() as $color): ?>
            <?= RadioColor::drawSwitchRadioColor(
                name: 'ui_color_' . $size->value . '_' . $theme,
                value: $color->value,
                label: $color->name,
                color: $color,
                checked: $color === SwitchRadioColorValue::Blue,
                size: $size,
                theme: $colorTheme,
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Отключённый</h3>
<div class="ui-showcase__row">
    <?= RadioColor::drawSwitchRadioColor(
        name: 'ui_color_disabled_' . $theme,
        value: 'red',
        label: 'Red',
        color: SwitchRadioColorValue::Red,
        disabled: true,
        theme: $colorTheme,
    ) ?>
</div>
