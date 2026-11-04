<?php

/**
 * Подтверждение удаления (Modal/main, role="alertdialog"): опасная кнопка не главная. Кнопки подставляет скрипт
 * списка в .modal-delete__btns (window.openDeleteModal())
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
    id: 'sf-modal-delete',
    title: 'Удалить запись?',
    text: 'Действие нельзя отменить.',
    footer: '<div class="modal-delete__btns">'
        . Button::drawButton(text: 'Удалить', style: ButtonStyle::Secondary, size: ButtonSize::Small, theme: $buttonTheme)
        . Button::drawButton(
            text: 'Отмена',
            style: ButtonStyle::Outline,
            size: ButtonSize::Small,
            theme: $buttonTheme,
            attributes: ['data-modal-close' => ''],
        )
        . '</div>',
    theme: ModalTheme::from($page->getTheme()),
    alert: true,
) ?>
