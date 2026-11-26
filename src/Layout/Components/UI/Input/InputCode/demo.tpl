<?php

/**
 * Демо CodeInput: пустое, набор, заполненное, ошибка, успех, длины 4–6 (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputCode\InputCodeState;
use Simflex\Core\Layout\Components\UI\Input\InputCode\InputCodeTheme;
use Simflex\Core\Layout\Components\UI\Input\InputCode\Layout as CodeInput;

$codeTheme = InputCodeTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">Состояния</h3>
<div class="ui-showcase__row">
    <?= CodeInput::drawInputCode(
        name: 'ui_code_empty_' . $theme,
        state: InputCodeState::Default,
        theme: $codeTheme,
        id: 'ui-code-empty-' . $theme,
    ) ?>
    <?= CodeInput::drawInputCode(name: 'ui_code_filling_' . $theme, value: '482', theme: $codeTheme, id: 'ui-code-filling-' . $theme) ?>
    <?= CodeInput::drawInputCode(name: 'ui_code_filled_' . $theme, value: '482601', theme: $codeTheme, id: 'ui-code-filled-' . $theme) ?>
    <?= CodeInput::drawInputCode(
        name: 'ui_code_error_' . $theme,
        value: '482601',
        state: InputCodeState::Error,
        message: 'Неверный код. Попробуйте снова.',
        theme: $codeTheme,
        id: 'ui-code-error-' . $theme,
    ) ?>
    <?= CodeInput::drawInputCode(
        name: 'ui_code_success_' . $theme,
        value: '482601',
        state: InputCodeState::Success,
        message: 'Код принят.',
        theme: $codeTheme,
        id: 'ui-code-success-' . $theme,
    ) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Длина кода</h3>
<div class="ui-showcase__row">
    <?php foreach ([4, 5, 6] as $length): ?>
        <?= CodeInput::drawInputCode(
            name: 'ui_code_length_' . $length . '_' . $theme,
            length: $length,
            theme: $codeTheme,
            id: 'ui-code-length-' . $length . '-' . $theme,
        ) ?>
    <?php endforeach; ?>
</div>
