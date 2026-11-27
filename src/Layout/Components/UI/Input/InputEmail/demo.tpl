<?php

/**
 * Демо InputEmail: стиль × размер, ошибка и успех (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputEmail\Layout as InputEmail;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;

$inputTheme = InputMainTheme::from($theme);

?>
<?php foreach (InputMainStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <?php foreach ([InputMainSize::Large, InputMainSize::Medium, InputMainSize::Small] as $size): ?>
        <div class="ui-showcase__row">
            <span class="ui-showcase__field"><?= InputEmail::drawInputEmail(placeholder: 'name@example.com', style: $style, size: $size, theme: $inputTheme) ?></span>
            <span class="ui-showcase__field"><?= InputEmail::drawInputEmail(placeholder: 'name@example.com', labelText: 'Подпись', labelPos: InputMainLabelPos::Standard, value: 'name@example.com', style: $style, size: $size, theme: $inputTheme) ?></span>
            <span class="ui-showcase__field"><?= InputEmail::drawInputEmail(placeholder: 'name@example.com', value: 'name@example.com', error: 'Ошибка ввода', style: $style, size: $size, theme: $inputTheme) ?></span>
            <span class="ui-showcase__field"><?= InputEmail::drawInputEmail(placeholder: 'name@example.com', value: 'name@example.com', success: true, style: $style, size: $size, theme: $inputTheme) ?></span>
            <span class="ui-showcase__field"><?= InputEmail::drawInputEmail(placeholder: 'name@example.com', value: 'name@example.com', attributes: ['disabled' => 'disabled'], style: $style, size: $size, theme: $inputTheme) ?></span>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>
