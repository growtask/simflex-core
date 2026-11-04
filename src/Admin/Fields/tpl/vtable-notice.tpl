<?php

/**
 * Таблица строк FieldVirtualTable у новой записи: строки ссылаются на запись, поэтому добавляются после сохранения
 * @var \Simflex\Core\Admin\Fields\FieldVirtualTable $this
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\Notice\Layout as Notice;
use Simflex\Core\Layout\Components\UI\Core\Notice\NoticeTheme;

?>
<?= Notice::drawNotice(
    title: strip_tags((string)$this->label),
    text: 'Строки можно будет добавить после сохранения записи.',
    theme: NoticeTheme::from(Page::get()->getTheme()),
    className: 'edit-table-notice',
) ?>
