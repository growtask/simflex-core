<?php

/**
 * Демо PhoneInput: размеры × стили, страны, подпись, ошибка, отключённое поле (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputPhone\Layout as PhoneInput;
use Simflex\Core\Layout\Components\UI\Input\InputPhone\PhoneCountry;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputTheme;

$inputTheme = TextInputTheme::from($theme);

$nextId = static function () use ($theme): string {
    static $n = [];
    $n[$theme] = ($n[$theme] ?? 0) + 1;

    return 'ui-phone-' . $theme . '-' . $n[$theme];
};

?>
<?php foreach (TextInputSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (TextInputStyle::cases() as $style): ?>
            <?= PhoneInput::drawPhoneInput(id: $nextId(), style: $style, size: $size, theme: $inputTheme) ?>
            <?= PhoneInput::drawPhoneInput(id: $nextId(), value: '79161234567', style: $style, size: $size, theme: $inputTheme) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Страны</h3>
<div class="ui-showcase__row">
    <?php foreach (PhoneCountry::cases() as $country): ?>
        <?= PhoneInput::drawPhoneInput(
            name: 'ui_phone_' . $country->value . '_' . $theme,
            value: $country->dial() . '123456789',
            country: $country,
            theme: $inputTheme,
            id: $nextId(),
        ) ?>
    <?php endforeach; ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Подпись и состояния</h3>
<div class="ui-showcase__row">
    <?= PhoneInput::drawPhoneInput(
        id: $nextId(),
        labelText: 'Телефон',
        labelPos: TextInputLabelPos::Standard,
        theme: $inputTheme,
    ) ?>
    <?= PhoneInput::drawPhoneInput(id: $nextId(), value: '7916123', error: 'Введите номер полностью', theme: $inputTheme) ?>
    <?= PhoneInput::drawPhoneInput(id: $nextId(), value: '79161234567', success: true, theme: $inputTheme) ?>
    <?= PhoneInput::drawPhoneInput(
        id: $nextId(),
        value: '79161234567',
        theme: $inputTheme,
        attributes: ['disabled' => 'disabled'],
    ) ?>
</div>
