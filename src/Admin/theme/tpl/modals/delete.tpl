<?php

/**
 * Подтверждение удаления (Modal/main, role="alertdialog"): опасная кнопка не главная. Кнопки подставляет скрипт
 * списка в .modal-delete__btns (window.openDeleteModal())
 * @var \Simflex\Core\Admin\Page $page
 */

use Simflex\Core\Layout\Components\Common\Modal\Layout as Modal;
use Simflex\Core\Layout\Components\Common\Modal\ModalTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$buttonTheme = ButtonMainTheme::from($page->getTheme());
?>
<?= Modal::drawModal(
    id: 'sf-modal-delete',
    title: 'Удалить запись?',
    text: 'Действие нельзя отменить.',
    footer: '<div class="modal-delete__btns">'
        . Button::drawButtonMain(text: 'Удалить', style: ButtonMainStyle::Secondary, size: ButtonMainSize::Small, theme: $buttonTheme)
        . Button::drawButtonMain(
            text: 'Отмена',
            style: ButtonMainStyle::Outline,
            size: ButtonMainSize::Small,
            theme: $buttonTheme,
            attributes: ['data-modal-close' => ''],
        )
        . '</div>',
    theme: ModalTheme::from($page->getTheme()),
    alert: true,
) ?>
