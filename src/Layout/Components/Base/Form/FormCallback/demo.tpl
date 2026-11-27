<?php

/**
 * Демо FormCallback: раскладки grid и stack, состояния, набор полей (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Form\FormCallback\FormCallbackLayout;
use Simflex\Core\Layout\Components\Base\Form\FormCallback\FormCallbackState;
use Simflex\Core\Layout\Components\Base\Form\FormCallback\FormCallbackTheme;
use Simflex\Core\Layout\Components\Base\Form\FormCallback\Layout as FormCallback;

$theme = FormCallbackTheme::from($theme);
$values = ['name' => 'Иван', 'phone' => '+7 999 123-45-67', 'email' => 'ivan@example.com', 'comment' => 'Хочу узнать цену'];
$errors = ['phone' => 'Введите номер телефона', 'consent' => 'Нужно согласие на обработку данных'];

?>
<?php foreach (FormCallbackLayout::cases() as $layout): ?>
    <?php foreach (FormCallbackState::cases() as $state): ?>
        <h3 class="ui-showcase__subtitle ui-m"><?= $layout->name ?> · <?= $state->name ?></h3>
        <div class="ui-showcase__row" style="display: block; max-width: 760px;">
            <?= FormCallback::drawFormCallback(
                layout: $layout,
                state: $state,
                theme: $theme,
                values: $state === FormCallbackState::Default ? [] : $values,
                errors: $errors,
                guard: false,
            ) ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Только телефон, без согласия</h3>
<div class="ui-showcase__row" style="display: block; max-width: 760px;">
    <?= FormCallback::drawFormCallback(
        name: false,
        email: false,
        comment: false,
        consent: false,
        submitText: 'Перезвоните мне',
        theme: $theme,
        guard: false,
    ) ?>
</div>
