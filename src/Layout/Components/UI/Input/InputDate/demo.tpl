<?php

/**
 * Демо InputDate: стиль × размер, ошибка и успех (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputDate\Layout as InputDate;
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
            <span class="ui-showcase__field"><?= InputDate::drawInputDate( style: $style, size: $size, theme: $inputTheme) ?></span>
            <span class="ui-showcase__field"><?= InputDate::drawInputDate( labelText: 'Подпись', labelPos: InputMainLabelPos::Standard, value: '24.11.2026', style: $style, size: $size, theme: $inputTheme) ?></span>
            <span class="ui-showcase__field"><?= InputDate::drawInputDate( value: '24.11.2026', error: 'Ошибка ввода', style: $style, size: $size, theme: $inputTheme) ?></span>
            <span class="ui-showcase__field"><?= InputDate::drawInputDate( value: '24.11.2026', success: true, style: $style, size: $size, theme: $inputTheme) ?></span>

            <span class="ui-showcase__field"><?= InputDate::drawInputDate( value: '24.11.2026', attributes: ['disabled' => 'disabled'], style: $style, size: $size, theme: $inputTheme) ?></span>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>
