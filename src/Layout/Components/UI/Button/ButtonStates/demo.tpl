<?php

/**
 * Демо ButtonStates: состояния × размеры, с иконкой и без (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonStates\ButtonStatesState;
use Simflex\Core\Layout\Components\UI\Button\ButtonStates\Layout as ButtonStates;

$buttonTheme = ButtonTheme::from($theme);

?>
<?php foreach (ButtonSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (ButtonStatesState::cases() as $state): ?>
            <?= ButtonStates::drawButtonStates(text: $state->name, state: $state, size: $size, theme: $buttonTheme) ?>
            <?= ButtonStates::drawButtonStates(
                text: $state->name,
                state: $state,
                size: $size,
                theme: $buttonTheme,
                iconLeft: 'plus',
            ) ?>
            <?= ButtonStates::drawButtonStates(
                state: $state,
                size: $size,
                theme: $buttonTheme,
                iconLeft: 'plus',
                attributes: ['aria-label' => $state->name],
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
