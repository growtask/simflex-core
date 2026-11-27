<?php

/**
 * Демо LoginInput: размеры × стили, подпись, значение, отключённое поле (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputLogin\Layout as LoginInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;

$inputTheme = InputMainTheme::from($theme);

$nextId = static function () use ($theme): string {
    static $n = [];
    $n[$theme] = ($n[$theme] ?? 0) + 1;

    return 'ui-login-' . $theme . '-' . $n[$theme];
};

?>
<?php foreach (InputMainSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (InputMainStyle::cases() as $style): ?>
            <?= LoginInput::drawInputLogin(id: $nextId(), style: $style, size: $size, theme: $inputTheme) ?>
            <?= LoginInput::drawInputLogin(id: $nextId(), value: 'Иван', style: $style, size: $size, theme: $inputTheme) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Подпись и состояния</h3>
<div class="ui-showcase__row">
    <?= LoginInput::drawInputLogin(
        id: $nextId(),
        labelText: 'Подпись',
        labelPos: InputMainLabelPos::Standard,
        theme: $inputTheme,
    ) ?>
    <?= LoginInput::drawInputLogin(
        id: $nextId(),
        labelText: 'Подпись внутри',
        labelPos: InputMainLabelPos::Inside,
        theme: $inputTheme,
    ) ?>
    <?= LoginInput::drawInputLogin(id: $nextId(), value: 'Иван', theme: $inputTheme, attributes: ['disabled' => 'disabled']) ?>
    <?= LoginInput::drawInputLogin(id: $nextId(), value: 'ivan', error: 'Такого логина нет', theme: $inputTheme) ?>
</div>
