<?php

/**
 * Демо InputPassword: стиль × размер, ошибка и успех (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputPassword\Layout as InputPassword;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputTheme;

$inputTheme = TextInputTheme::from($theme);

?>
<?php foreach (TextInputStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <?php foreach ([TextInputSize::Large, TextInputSize::Medium, TextInputSize::Small] as $size): ?>
        <div class="ui-showcase__row">
            <span class="ui-showcase__field"><?= InputPassword::drawInputPassword(placeholder: 'Пароль', style: $style, size: $size, theme: $inputTheme) ?></span>
            <span class="ui-showcase__field"><?= InputPassword::drawInputPassword(placeholder: 'Пароль', labelText: 'Подпись', labelPos: TextInputLabelPos::Standard, value: 'secret123', style: $style, size: $size, theme: $inputTheme) ?></span>
            <span class="ui-showcase__field"><?= InputPassword::drawInputPassword(placeholder: 'Пароль', value: 'secret123', error: 'Ошибка ввода', style: $style, size: $size, theme: $inputTheme) ?></span>
            <span class="ui-showcase__field"><?= InputPassword::drawInputPassword(placeholder: 'Пароль', value: 'secret123', success: true, style: $style, size: $size, theme: $inputTheme) ?></span>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>
