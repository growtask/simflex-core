<?php

/**
 * Действия строки списка (компоненты макета td type=controls, more): изменить, удалить, «Ещё» → сведения о
 * записи. Удаление — с подтверждением (theme/js/list.js). Класс .table__body-item-btns — точка расширения:
 * разделы добавляют в него свои кнопки
 * @var \Simflex\Core\Admin\Table\Table $this
 * @var array $row
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Core\Dropdown\DropdownSize;
use Simflex\Core\Layout\Components\UI\Core\Dropdown\DropdownTheme;
use Simflex\Core\Layout\Components\UI\Core\Dropdown\Layout as Dropdown;

$theme = Page::get()->getTheme();
$iconTheme = ButtonIconTheme::from($theme);
$id = $row[$this->pk->name];
?>
<div class="table__body-item-btns row-actions">
    <?php if ($this->canEdit): ?>
        <div class="tooltip-row1-edit"><?= ButtonIcon::drawButtonIcon(
            icon: 'pencil-line',
            label: 'Редактировать',
            style: ButtonIconStyle::Secondary,
            theme: $iconTheme,
            link: '?action=form&' . rawurlencode($this->pk->name) . '=' . rawurlencode((string)$id),
        ) ?></div>
    <?php endif ?>
    <?php if ($this->canDelete): ?>
        <div class="tooltip-row1-delete"><?= ButtonIcon::drawButtonIcon(
            icon: 'trash',
            label: 'Удалить',
            style: ButtonIconStyle::Secondary,
            theme: $iconTheme,
            attributes: ['data-sf-row-delete' => '?action=delete&rows[]=' . rawurlencode((string)$id)],
        ) ?></div>
    <?php endif ?>
    <div class="tooltip-row1-info"><?= Dropdown::drawMenu(
        ButtonIcon::drawButtonIcon(
            icon: 'dots-vertical',
            label: 'Ещё',
            style: ButtonIconStyle::Secondary,
            theme: $iconTheme,
        ),
        [['text' => 'Информация', 'icon' => 'notify-info', 'attributes' => ['data-sf-row-info' => (string)$id]]],
        size: DropdownSize::ExtraSmall,
        theme: DropdownTheme::from($theme),
        label: 'Действия с записью ' . $id,
    ) ?></div>
</div>
