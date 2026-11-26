<?php

/**
 * Кнопки панели действий списка (компонент макета table-bar): Добавить, Редактировать (одна запись; несколько —
 * при групповом редактировании), Копировать, Удалить (с подтверждением). Доступность по числу выбранных
 * записей — theme/js/list.js. Разделы добавляют свои кнопки после parent::showActions()
 * @var \Simflex\Core\Admin\Table\Table $this
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$theme = ButtonMainTheme::from(Page::get()->getTheme());
$action = fn(string $id, string $text, string $icon, string $action, array $attributes = []) => Button::drawButtonMain(
    className: 'table-bar__button',
    text: $text,
    style: ButtonMainStyle::Secondary,
    size: ButtonMainSize::Small,
    theme: $theme,
    attributes: $attributes + ['id' => $id, 'data-sf-list-action' => $action],
    iconLeft: $icon,
    disabled: true,
);
?>
<?php if ($this->canAdd): ?>
    <?= Button::drawButtonMain(
        className: 'table-bar__button table-bar__add',
        text: 'Добавить',
        link: '?action=form',
        size: ButtonMainSize::Small,
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
