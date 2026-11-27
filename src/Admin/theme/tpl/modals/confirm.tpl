<?php

/**
 * Окно подтверждения для sfAdmin.confirm(message, {title, confirmText, danger}) (theme/js/modals.js)
 * @var \Simflex\Core\Admin\Page $page
 */

use Simflex\Core\Layout\Components\Base\Modal\ModalMain\Layout as Modal;
use Simflex\Core\Layout\Components\Base\Modal\ModalMain\ModalMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$buttonTheme = ButtonMainTheme::from($page->getTheme());
?>
<?= Modal::drawModalMain(
    id: 'sf-modal-confirm',
    title: 'Подтвердите действие',
    text: ' ',
    footer: Button::drawButtonMain(
        text: 'Да',
        size: ButtonMainSize::Small,
        theme: $buttonTheme,
        attributes: ['data-sf-confirm' => 'yes'],
    ) . Button::drawButtonMain(
        text: 'Отмена',
        style: ButtonMainStyle::Outline,
        size: ButtonMainSize::Small,
        theme: $buttonTheme,
        attributes: ['data-sf-confirm' => 'no'],
    ),
    theme: ModalMainTheme::from($page->getTheme()),
    alert: true,
) ?>
