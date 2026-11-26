<?php

/**
 * Демо Stepper: размеры × стили × заливка, ширина, ошибка, загрузка, отключённый (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\Layout as Stepper;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainFill;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainSize;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainStyle;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainTheme;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainWidth;

$stepperTheme = StepperMainTheme::from($theme);

?>
<?php foreach (StepperMainSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (StepperMainStyle::cases() as $style): ?>
            <?php foreach (StepperMainFill::cases() as $fill): ?>
                <?= Stepper::drawStepperMain(
                    'ui_stepper_' . $theme . '_' . $size->name . '_' . $style->name . '_' . $fill->name,
                    1,
                    min: 1,
                    max: 5,
                    size: $size,
                    style: $style,
                    fill: $fill,
                    theme: $stepperTheme,
                ) ?>
            <?php endforeach; ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Ширина и состояния</h3>
<div class="ui-showcase__row">
    <?php foreach (StepperMainWidth::cases() as $width): ?>
        <?= Stepper::drawStepperMain(
            'ui_stepper_width_' . $width->name . '_' . $theme,
            2,
            width: $width,
            theme: $stepperTheme,
        ) ?>
    <?php endforeach; ?>
    <?= Stepper::drawStepperMain(
        'ui_stepper_error_' . $theme,
        5,
        max: 5,
        style: StepperMainStyle::Input,
        fill: StepperMainFill::Outline,
        theme: $stepperTheme,
        error: 'Осталось только 5',
    ) ?>
    <?= Stepper::drawStepperMain('ui_stepper_loading_' . $theme, 3, theme: $stepperTheme, loading: true) ?>
    <?= Stepper::drawStepperMain('ui_stepper_disabled_' . $theme, 3, theme: $stepperTheme, disabled: true) ?>
</div>
