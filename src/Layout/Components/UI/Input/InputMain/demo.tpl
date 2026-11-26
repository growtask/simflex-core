<?php

/**
 * Демо TextInput: размеры × стили, положение подписи, виды поля, ошибка, успех, счётчик, иконка
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainKind;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;

$inputTheme = InputMainTheme::from($theme);

$nextId = static function () use ($theme): string {
    static $n = [];
    $n[$theme] = ($n[$theme] ?? 0) + 1;

    return 'ui-input-' . $theme . '-' . $n[$theme];
};

?>
<?php foreach (InputMainSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (InputMainStyle::cases() as $style): ?>
            <?php foreach (InputMainLabelPos::cases() as $labelPos): ?>
                <?= TextInput::drawInputMain(
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
    <?php foreach (InputMainKind::cases() as $kind): ?>
        <?= TextInput::drawInputMain(
            id: $nextId(),
            placeholder: $kind->name,
            labelText: $kind->name,
            labelPos: InputMainLabelPos::Standard,
            theme: $inputTheme,
            kind: $kind,
        ) ?>
    <?php endforeach; ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Состояния</h3>
<div class="ui-showcase__row">
    <?= TextInput::drawInputMain(
        id: $nextId(),
        labelText: 'Подпись внутри',
        labelPos: InputMainLabelPos::Inside,
        theme: $inputTheme,
        icon: 'check',
        counter: true,
        maxLength: 50,
    ) ?>
    <?= TextInput::drawInputMain(
        id: $nextId(),
        labelText: 'Подпись внутри',
        labelPos: InputMainLabelPos::Inside,
        theme: $inputTheme,
        icon: 'check',
        value: 'Текст',
        counter: true,
        maxLength: 50,
    ) ?>
    <?= TextInput::drawInputMain(id: $nextId(), placeholder: 'Пусто', theme: $inputTheme) ?>
    <?= TextInput::drawInputMain(id: $nextId(), placeholder: 'С иконкой', theme: $inputTheme, icon: 'search') ?>
    <?= TextInput::drawInputMain(id: $nextId(), placeholder: 'Значение', theme: $inputTheme, value: 'Значение') ?>
    <?= TextInput::drawInputMain(id: $nextId(), placeholder: 'Email', theme: $inputTheme, value: 'admin@', error: 'Неверный email') ?>
    <?= TextInput::drawInputMain(id: $nextId(), placeholder: 'Логин', theme: $inputTheme, value: 'admin', success: true) ?>
    <?= TextInput::drawInputMain(
        id: $nextId(),
        placeholder: 'Со счётчиком',
        theme: $inputTheme,
        value: 'Текст',
        counter: true,
        maxLength: 50,
    ) ?>
    <?= TextInput::drawInputMain(
        id: $nextId(),
        placeholder: 'Отключено',
        theme: $inputTheme,
        attributes: ['disabled' => 'disabled'],
    ) ?>
</div>
