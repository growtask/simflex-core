<?php

/**
 * Окно подтверждения для sfAdmin.confirm(message, {title, confirmText, danger}) (theme/js/modals.js)
 * @var \Simflex\Core\Admin\Page $page
 */

use Simflex\Core\Layout\Components\Common\Modal\Layout as Modal;
use Simflex\Core\Layout\Components\Common\Modal\ModalTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;

$buttonTheme = ButtonTheme::from($page->getTheme());
?>
<?= Modal::drawModal(
    id: 'sf-modal-confirm',
    title: 'Подтвердите действие',
    text: ' ',
    footer: Button::drawButton(
        text: 'Да',
        size: ButtonSize::Small,
        theme: $buttonTheme,
        attributes: ['data-sf-confirm' => 'yes'],
    ) . Button::drawButton(
        text: 'Отмена',
        style: ButtonStyle::Outline,
        size: ButtonSize::Small,
        theme: $buttonTheme,
        attributes: ['data-sf-confirm' => 'no'],
    ),
    theme: ModalTheme::from($page->getTheme()),
    alert: true,
) ?>
