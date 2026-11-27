<?php

/**
 * Демо Button: размеры × стили, иконка слева и справа, загрузка, отключённая, успех и ошибка (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainIconPos;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainState;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$buttonTheme = ButtonMainTheme::from($theme);

$morphId = 'ui-btn-morph-' . $theme;
$run = "document.querySelectorAll('#$morphId [data-demo-morph]').forEach(function (b) { %s })";

?>
<h3 class="ui-showcase__subtitle ui-m">Загрузка и результат: спиннер по центру сжимает кнопку в круг (соседи не сдвигаются), затем success или error ~900 мс; наведение — лёгкое увеличение, нажатие — уменьшение и свечение у primary и accent</h3>
<div class="ui-showcase__row" id="<?= $morphId ?>">
    <?= Button::drawButtonMain(text: 'Оформить заказ', theme: $buttonTheme, attributes: ['data-demo-morph' => '']) ?>
    <?= Button::drawButtonMain(text: 'Отправить заявку', style: ButtonMainStyle::Accent, size: ButtonMainSize::Large, theme: $buttonTheme, attributes: ['data-demo-morph' => '']) ?>
    <?= Button::drawButtonMain(text: 'Сохранить', style: ButtonMainStyle::Outline, size: ButtonMainSize::Small, theme: $buttonTheme, attributes: ['data-demo-morph' => '']) ?>
    <?= Button::drawButtonMain(text: 'С иконкой — без морфа', iconLeft: 'check', style: ButtonMainStyle::Secondary, theme: $buttonTheme, attributes: ['data-demo-morph' => '']) ?>
</div>
<div class="ui-showcase__row">
    <?= Button::drawButtonMain(text: 'Начать загрузку', size: ButtonMainSize::ExtraSmall, style: ButtonMainStyle::Gray, theme: $buttonTheme, attributes: ['onclick' => sprintf($run, 'SfUi.buttonLoad(b, true);')]) ?>
    <?= Button::drawButtonMain(text: '→ success', size: ButtonMainSize::ExtraSmall, style: ButtonMainStyle::Flat, theme: $buttonTheme, attributes: ['onclick' => sprintf($run, "SfUi.buttonResult(b, 'success');")]) ?>
    <?= Button::drawButtonMain(text: '→ error', size: ButtonMainSize::ExtraSmall, style: ButtonMainStyle::Flat, theme: $buttonTheme, attributes: ['onclick' => sprintf($run, "SfUi.buttonResult(b, 'error');")]) ?>
    <?= Button::drawButtonMain(text: '→ без результата', size: ButtonMainSize::ExtraSmall, style: ButtonMainStyle::Flat, theme: $buttonTheme, attributes: ['onclick' => sprintf($run, 'SfUi.buttonLoad(b, false);')]) ?>
</div>
<?php foreach (ButtonMainSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (ButtonMainStyle::cases() as $style): ?>
            <?= Button::drawButtonMain(
                text: $style->name,
                icon: 'plus',
                style: $style,
                size: $size,
                theme: $buttonTheme,
            ) ?>
        <?php endforeach; ?>
        <?= Button::drawButtonMain(text: 'disabled', size: $size, theme: $buttonTheme, disabled: true) ?>
    </div>
    <div class="ui-showcase__row">
        <?php /* кнопка только с иконкой (Figma icon=center): иконка без текста */ ?>
        <?php foreach (ButtonMainStyle::cases() as $style): ?>
            <?= Button::drawButtonMain(
                iconLeft: 'plus',
                style: $style,
                size: $size,
                theme: $buttonTheme,
                attributes: ['aria-label' => $style->name],
            ) ?>
        <?php endforeach; ?>
        <?= Button::drawButtonMain(iconLeft: 'plus', size: $size, theme: $buttonTheme, disabled: true, attributes: ['aria-label' => 'disabled']) ?>
        <?= Button::drawButtonMain(iconLeft: 'plus', load: true, size: $size, theme: $buttonTheme, attributes: ['aria-label' => 'Загрузка']) ?>
    </div>
    <div class="ui-showcase__row">
        <?php foreach (ButtonMainIconPos::cases() as $iconPos): ?>
            <?php foreach (ButtonMainStyle::cases() as $style): ?>
                <?= Button::drawButtonMain(
                    text: 'Иконка ' . $iconPos->name,
                    icon: 'arrow-right',
                    iconPos: $iconPos,
                    style: $style,
                    size: $size,
                    theme: $buttonTheme,
                ) ?>
            <?php endforeach; ?>
        <?php endforeach; ?>
        <?= Button::drawButtonMain(text: 'Загрузка', load: true, size: $size, theme: $buttonTheme) ?>
        <?php foreach (ButtonMainState::cases() as $state): ?>
            <?php if ($state === ButtonMainState::Default) { continue; } ?>
            <?= Button::drawButtonMain(text: $state->name, state: $state, size: $size, theme: $buttonTheme) ?>
            <?= Button::drawButtonMain(text: $state->name, icon: 'plus', state: $state, size: $size, theme: $buttonTheme) ?>
            <?= Button::drawButtonMain(iconLeft: 'plus', state: $state, size: $size, theme: $buttonTheme, attributes: ['aria-label' => $state->name]) ?>
        <?php endforeach; ?>
        <?= Button::drawButtonMain(text: 'Ссылка', link: '#link', size: $size, theme: $buttonTheme) ?>
    </div>
<?php endforeach; ?>
