<?php

/**
 * Демо Button: размеры × стили, иконка слева и справа, загрузка, отключённая (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonIconPos;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$buttonTheme = ButtonTheme::from($theme);

?>
<?php foreach (ButtonSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (ButtonStyle::cases() as $style): ?>
            <?= Button::drawButton(
                text: $style->name,
                icon: 'plus',
                style: $style,
                size: $size,
                theme: $buttonTheme,
            ) ?>
        <?php endforeach; ?>
        <?= Button::drawButton(text: 'disabled', size: $size, theme: $buttonTheme, disabled: true) ?>
    </div>
    <div class="ui-showcase__row">
        <?php /* кнопка только с иконкой (Figma icon=center): иконка без текста */ ?>
        <?php foreach (ButtonStyle::cases() as $style): ?>
            <?= Button::drawButton(
                iconLeft: 'plus',
                style: $style,
                size: $size,
                theme: $buttonTheme,
                attributes: ['aria-label' => $style->name],
            ) ?>
        <?php endforeach; ?>
        <?= Button::drawButton(iconLeft: 'plus', size: $size, theme: $buttonTheme, disabled: true, attributes: ['aria-label' => 'disabled']) ?>
        <?= Button::drawButton(iconLeft: 'plus', load: true, size: $size, theme: $buttonTheme, attributes: ['aria-label' => 'Загрузка']) ?>
    </div>
    <div class="ui-showcase__row">
        <?php foreach (ButtonIconPos::cases() as $iconPos): ?>
            <?php foreach (ButtonStyle::cases() as $style): ?>
                <?= Button::drawButton(
                    text: 'Иконка ' . $iconPos->name,
                    icon: 'arrow-right',
                    iconPos: $iconPos,
                    style: $style,
                    size: $size,
                    theme: $buttonTheme,
                ) ?>
            <?php endforeach; ?>
        <?php endforeach; ?>
        <?= Button::drawButton(text: 'Загрузка', load: true, size: $size, theme: $buttonTheme) ?>
        <?= Button::drawButton(text: 'Ссылка', link: '#link', size: $size, theme: $buttonTheme) ?>
    </div>
<?php endforeach; ?>
