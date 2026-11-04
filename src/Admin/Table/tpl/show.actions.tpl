<?php

/**
 * Кнопки панели действий списка (компонент макета table-bar): Добавить, Редактировать (одна запись; несколько —
 * при групповом редактировании), Копировать, Удалить (с подтверждением). Доступность по числу выбранных
 * записей — theme/js/list.js. Разделы добавляют свои кнопки после parent::showActions()
 * @var \Simflex\Core\Admin\Table\Table $this
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;

$theme = ButtonTheme::from(Page::get()->getTheme());
$action = fn(string $id, string $text, string $icon, string $action, array $attributes = []) => Button::drawButton(
    className: 'table-bar__button',
    text: $text,
    style: ButtonStyle::Secondary,
    size: ButtonSize::Small,
    theme: $theme,
    attributes: $attributes + ['id' => $id, 'data-sf-list-action' => $action],
    iconLeft: $icon,
    disabled: true,
);
?>
<?php if ($this->canAdd): ?>
    <?= Button::drawButton(
        className: 'table-bar__button table-bar__add',
        text: 'Добавить',
        link: '?action=form',
        size: ButtonSize::Small,
        theme: $theme,
        iconLeft: 'plus',
    ) ?>
<?php endif ?>
<?php if ($this->canEdit): ?>
    <?= $action('btn-control-edit', 'Редактировать', 'pencil-line', 'edit', [
        'data-sf-group' => $this->canEditGroup ? '1' : '0',
    ]) ?>
<?php endif ?>
<?php if ($this->canAdd && $this->canCopy): ?>
    <?= $action('btn-control-copy', 'Копировать', 'copy', 'copy') ?>
<?php endif ?>
<?php if ($this->canDelete): ?>
    <?= $action('btn-control-delete', 'Удалить', 'trash', 'delete') ?>
<?php endif ?>
