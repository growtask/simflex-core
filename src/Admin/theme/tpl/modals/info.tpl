<?php

/**
 * Сведения о записи (Modal/main): таблица «поле — значение» загружается скриптом (?action=showDetail) в
 * .modal-info__talbe-wrapper, ссылка «Редактировать» — .modal-info__btn-edit (window.openInfoModal())
 * @var \Simflex\Core\Admin\Page $page
 */

use Simflex\Core\Layout\Components\Common\Modal\Layout as Modal;
use Simflex\Core\Layout\Components\Common\Modal\ModalSize;
use Simflex\Core\Layout\Components\Common\Modal\ModalTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

?>
<?= Modal::drawModal(
    id: 'sf-modal-info',
    title: 'Информация',
    content: '<div class="modal-info__talbe-wrapper"></div>',
    footer: Button::drawButtonMain(
        className: 'modal-info__btn-edit',
        text: 'Редактировать',
        link: '#',
        size: ButtonMainSize::Small,
        theme: ButtonMainTheme::from($page->getTheme()),
        iconLeft: 'pencil-line',
    ),
    size: ModalSize::Medium,
    theme: ModalTheme::from($page->getTheme()),
) ?>
