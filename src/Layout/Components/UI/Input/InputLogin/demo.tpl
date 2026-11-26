<?php

/**
 * Демо LoginInput: размеры × стили, подпись, значение, отключённое поле (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputLogin\Layout as LoginInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputTheme;

$inputTheme = TextInputTheme::from($theme);

$nextId = static function () use ($theme): string {
    static $n = [];
    $n[$theme] = ($n[$theme] ?? 0) + 1;

    return 'ui-login-' . $theme . '-' . $n[$theme];
};

?>
<?php foreach (TextInputSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (TextInputStyle::cases() as $style): ?>
            <?= LoginInput::drawLoginInput(id: $nextId(), style: $style, size: $size, theme: $inputTheme) ?>
            <?= LoginInput::drawLoginInput(id: $nextId(), value: 'Иван', style: $style, size: $size, theme: $inputTheme) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Подпись и состояния</h3>
<div class="ui-showcase__row">
    <?= LoginInput::drawLoginInput(
        id: $nextId(),
        labelText: 'Подпись',
        labelPos: TextInputLabelPos::Standard,
        theme: $inputTheme,
    ) ?>
    <?= LoginInput::drawLoginInput(
        id: $nextId(),
        labelText: 'Подпись внутри',
        labelPos: TextInputLabelPos::Inside,
        theme: $inputTheme,
    ) ?>
    <?= LoginInput::drawLoginInput(id: $nextId(), value: 'Иван', theme: $inputTheme, attributes: ['disabled' => 'disabled']) ?>
</div>
