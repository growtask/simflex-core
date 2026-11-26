<?php

/**
 * Демо Textarea: размеры × стили × положение подписи, состояния (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Textarea\Layout as Textarea;
use Simflex\Core\Layout\Components\UI\Textarea\TextareaLabelPos;
use Simflex\Core\Layout\Components\UI\Textarea\TextareaSize;
use Simflex\Core\Layout\Components\UI\Textarea\TextareaState;
use Simflex\Core\Layout\Components\UI\Textarea\TextareaStyle;
use Simflex\Core\Layout\Components\UI\Textarea\TextareaTheme;

$textareaTheme = TextareaTheme::from($theme);

?>
<?php foreach (TextareaSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (TextareaStyle::cases() as $style): ?>
            <?php foreach (TextareaLabelPos::cases() as $labelPos): ?>
                <?= Textarea::drawTextarea(
                    placeholder: $style->name,
                    labelText: $labelPos->name,
                    labelPos: $labelPos,
                    style: $style,
                    size: $size,
                    theme: $textareaTheme,
                ) ?>
            <?php endforeach; ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Состояния</h3>
<div class="ui-showcase__row">
    <?php foreach (TextareaState::cases() as $state): ?>
        <?= Textarea::drawTextarea(
            value: 'Текст',
            labelText: $state->name,
            message: $state === TextareaState::Default ? '' : 'Сообщение: ' . $state->name,
            theme: $textareaTheme,
            state: $state,
        ) ?>
    <?php endforeach; ?>
    <?= Textarea::drawTextarea(
        placeholder: 'Без счётчика',
        counter: false,
        theme: $textareaTheme,
    ) ?>
    <?= Textarea::drawTextarea(
        placeholder: 'Отключено',
        theme: $textareaTheme,
        attributes: ['disabled' => 'disabled'],
    ) ?>
</div>
