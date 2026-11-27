<?php

/**
 * Демо ModalMain: размеры xs–l, окно с подтверждением, без текста и подвала (витрина Layout\LayoutShowcase).
 * Окна показаны в потоке страницы (inline), на сайте окно скрыто и открывается по data-modal
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Modal\ModalMain\Layout as ModalMain;
use Simflex\Core\Layout\Components\Base\Modal\ModalMain\ModalMainSize;
use Simflex\Core\Layout\Components\Base\Modal\ModalMain\ModalMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$theme = ModalMainTheme::from($theme);
$buttonTheme = ButtonMainTheme::from($theme->value);
$footer = Button::drawButtonMain(
    text: 'Отмена',
    style: ButtonMainStyle::Gray,
    size: ButtonMainSize::Medium,
    theme: $buttonTheme,
) . Button::drawButtonMain(
    text: 'Подтвердить',
    style: ButtonMainStyle::Primary,
    size: ButtonMainSize::Medium,
    theme: $buttonTheme,
);

?>
<?php foreach (ModalMainSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row" style="display: block;">
        <?= ModalMain::drawModalMain(
            id: 'demo-modal-' . $size->value,
            title: 'Заголовок окна',
            text: 'Короткий текст под заголовком объясняет, что нужно сделать.',
            content: '<p>Любое содержимое: форма, список, результат.</p>',
            footer: $footer,
            size: $size,
            theme: $theme,
            inline: true,
        ) ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Подтверждение (alertdialog)</h3>
<div class="ui-showcase__row" style="display: block;">
    <?= ModalMain::drawModalMain(
        id: 'demo-modal-alert',
        title: 'Удалить запись?',
        text: 'Действие нельзя отменить.',
        footer: $footer,
        theme: $theme,
        alert: true,
        inline: true,
    ) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Только заголовок и содержимое</h3>
<div class="ui-showcase__row" style="display: block;">
    <?= ModalMain::drawModalMain(
        id: 'demo-modal-bare',
        title: 'Только заголовок',
        content: '<p>Окно без текста и подвала.</p>',
        size: ModalMainSize::Small,
        theme: $theme,
        inline: true,
    ) ?>
</div>
