<?php

/**
 * Демо StepperQuantity: размер × заливка, предел остатка, недоступный (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperFill;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperSize;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperTheme;
use Simflex\Core\Layout\Components\UI\Stepper\StepperQuantity\Layout as StepperQuantity;

$stepperTheme = StepperTheme::from($theme);

?>
<?php foreach (StepperSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (StepperFill::cases() as $fill): ?>
            <?= StepperQuantity::drawStepperQuantity(value: 1, fill: $fill, size: $size, theme: $stepperTheme) ?>
            <?= StepperQuantity::drawStepperQuantity(value: 5, stock: 5, fill: $fill, size: $size, theme: $stepperTheme) ?>
        <?php endforeach; ?>
        <?= StepperQuantity::drawStepperQuantity(value: 2, size: $size, theme: $stepperTheme, disabled: true) ?>
    </div>
<?php endforeach; ?>
