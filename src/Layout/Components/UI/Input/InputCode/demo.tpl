<?php

/**
 * Демо CodeInput: пустое, набор, заполненное, ошибка, успех, длины 4–6 (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputCode\CodeInputState;
use Simflex\Core\Layout\Components\UI\Input\InputCode\CodeInputTheme;
use Simflex\Core\Layout\Components\UI\Input\InputCode\Layout as CodeInput;

$codeTheme = CodeInputTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">Состояния</h3>
<div class="ui-showcase__row">
    <?= CodeInput::drawCodeInput(
        name: 'ui_code_empty_' . $theme,
        state: CodeInputState::Default,
        theme: $codeTheme,
        id: 'ui-code-empty-' . $theme,
    ) ?>
    <?= CodeInput::drawCodeInput(name: 'ui_code_filling_' . $theme, value: '482', theme: $codeTheme, id: 'ui-code-filling-' . $theme) ?>
    <?= CodeInput::drawCodeInput(name: 'ui_code_filled_' . $theme, value: '482601', theme: $codeTheme, id: 'ui-code-filled-' . $theme) ?>
    <?= CodeInput::drawCodeInput(
        name: 'ui_code_error_' . $theme,
        value: '482601',
        state: CodeInputState::Error,
        message: 'Неверный код. Попробуйте снова.',
        theme: $codeTheme,
        id: 'ui-code-error-' . $theme,
    ) ?>
    <?= CodeInput::drawCodeInput(
        name: 'ui_code_success_' . $theme,
        value: '482601',
        state: CodeInputState::Success,
        message: 'Код принят.',
        theme: $codeTheme,
        id: 'ui-code-success-' . $theme,
    ) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Длина кода</h3>
<div class="ui-showcase__row">
    <?php foreach ([4, 5, 6] as $length): ?>
        <?= CodeInput::drawCodeInput(
            name: 'ui_code_length_' . $length . '_' . $theme,
            length: $length,
            theme: $codeTheme,
            id: 'ui-code-length-' . $length . '-' . $theme,
        ) ?>
    <?php endforeach; ?>
</div>
