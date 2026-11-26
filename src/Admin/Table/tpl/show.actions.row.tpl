<?php

/**
 * Действия строки списка (компоненты макета td type=controls, more): изменить, удалить, «Ещё» → сведения о
 * записи. Удаление — с подтверждением (theme/js/list.js). Класс .table__body-item-btns — точка расширения:
 * разделы добавляют в него свои кнопки
 * @var \Simflex\Core\Admin\Table\Table $this
 * @var array $row
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainSize;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainTheme;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\Layout as Dropdown;

$theme = Page::get()->getTheme();
$iconTheme = ButtonIconSmallTheme::from($theme);
$id = $row[$this->pk->name];
?>
<div class="table__body-item-btns row-actions">
    <?php if ($this->canEdit): ?>
        <div class="tooltip-row1-edit"><?= ButtonIcon::drawButtonIconSmall(
            icon: 'pencil-line',
            label: 'Редактировать',
            style: ButtonIconSmallStyle::Secondary,
            theme: $iconTheme,
            link: '?action=form&' . rawurlencode($this->pk->name) . '=' . rawurlencode((string)$id),
        ) ?></div>
    <?php endif ?>
    <?php if ($this->canDelete): ?>
        <div class="tooltip-row1-delete"><?= ButtonIcon::drawButtonIconSmall(
            icon: 'trash',
            label: 'Удалить',
            style: ButtonIconSmallStyle::Secondary,
            theme: $iconTheme,
            attributes: ['data-sf-row-delete' => '?action=delete&rows[]=' . rawurlencode((string)$id)],
        ) ?></div>
    <?php endif ?>
    <div class="tooltip-row1-info"><?= Dropdown::drawDropdownMainMenu(
        ButtonIcon::drawButtonIconSmall(
            icon: 'dots-vertical',
            label: 'Ещё',
            style: ButtonIconSmallStyle::Secondary,
            theme: $iconTheme,
        ),
        [['text' => 'Информация', 'icon' => 'notify-info', 'attributes' => ['data-sf-row-info' => (string)$id]]],
        size: DropdownMainSize::ExtraSmall,
        theme: DropdownMainTheme::from($theme),
        label: 'Действия с записью ' . $id,
    ) ?></div>
</div>
