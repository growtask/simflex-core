<?php

/**
 * Демо TextInput: размеры × стили, положение подписи, виды поля, ошибка, успех, счётчик, иконка
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputKind;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputTheme;

$inputTheme = TextInputTheme::from($theme);

$nextId = static function () use ($theme): string {
    static $n = [];
    $n[$theme] = ($n[$theme] ?? 0) + 1;

    return 'ui-input-' . $theme . '-' . $n[$theme];
};

?>
<?php foreach (TextInputSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (TextInputStyle::cases() as $style): ?>
            <?php foreach (TextInputLabelPos::cases() as $labelPos): ?>
                <?= TextInput::drawInput(
                    id: $nextId(),
                    placeholder: $style->name,
                    labelText: $labelPos->name,
                    labelPos: $labelPos,
                    style: $style,
                    size: $size,
                    theme: $inputTheme,
                ) ?>
            <?php endforeach; ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Виды поля (kind)</h3>
<div class="ui-showcase__row">
    <?php foreach (TextInputKind::cases() as $kind): ?>
        <?= TextInput::drawInput(
            id: $nextId(),
            placeholder: $kind->name,
            labelText: $kind->name,
            labelPos: TextInputLabelPos::Standard,
            theme: $inputTheme,
            kind: $kind,
        ) ?>
    <?php endforeach; ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Состояния</h3>
<div class="ui-showcase__row">
    <?= TextInput::drawInput(
        id: $nextId(),
        labelText: 'Подпись внутри',
        labelPos: TextInputLabelPos::Inside,
        theme: $inputTheme,
        icon: 'check',
        counter: true,
        maxLength: 50,
    ) ?>
    <?= TextInput::drawInput(
        id: $nextId(),
        labelText: 'Подпись внутри',
        labelPos: TextInputLabelPos::Inside,
        theme: $inputTheme,
        icon: 'check',
        value: 'Текст',
        counter: true,
        maxLength: 50,
    ) ?>
    <?= TextInput::drawInput(id: $nextId(), placeholder: 'Пусто', theme: $inputTheme) ?>
    <?= TextInput::drawInput(id: $nextId(), placeholder: 'С иконкой', theme: $inputTheme, icon: 'search') ?>
    <?= TextInput::drawInput(id: $nextId(), placeholder: 'Значение', theme: $inputTheme, value: 'Значение') ?>
    <?= TextInput::drawInput(id: $nextId(), placeholder: 'Email', theme: $inputTheme, value: 'admin@', error: 'Неверный email') ?>
    <?= TextInput::drawInput(id: $nextId(), placeholder: 'Логин', theme: $inputTheme, value: 'admin', success: true) ?>
    <?= TextInput::drawInput(
        id: $nextId(),
        placeholder: 'Со счётчиком',
        theme: $inputTheme,
        value: 'Текст',
        counter: true,
        maxLength: 50,
    ) ?>
    <?= TextInput::drawInput(
        id: $nextId(),
        placeholder: 'Отключено',
        theme: $inputTheme,
        attributes: ['disabled' => 'disabled'],
    ) ?>
</div>
