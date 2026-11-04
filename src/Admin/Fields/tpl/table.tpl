<?php

/**
 * Таблица строк в форме (edit-table) полей FieldTable и FieldVirtualTable: кнопка «Добавить строку», таблица
 * (на планшете и телефоне — карточки), окно строки с полем на каждую колонку. Строки рисует, окно заполняет
 * и сохраняет theme/js/table-editor.js.
 * FieldTable: строки — в скрытом поле JSON {s: колонки, v: строки}, сохраняются вместе с формой.
 * FieldVirtualTable: строки другой таблицы, изменения сразу уходят ajax-действиями раздела (vtGet — страница строк,
 * vtAdd, vtEdit, vtDelete).
 * Колонка {n: имя, t: тип (text, int, combo, editor, image, file), l: заголовок, v: значение по умолчанию
 * (__NO_EDIT__ — не редактируется, $DATE$ — сегодня), e: варианты combo «k=v,,k=v» или AJAX:<действие поиска>,
 * c: onchange поля}. Колонка без заголовка не выводится
 * @var \Simflex\Core\Admin\Fields\Field $this
 * @var string $value JSON {s, v}
 * @var bool $isVirtual
 * @var int $total Строк всего (FieldVirtualTable)
 * @var array<string, string> $attributes Атрибуты корня (data-sf-table-*)
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Admin\Plugins\Editor\Editor;
use Simflex\Core\Layout\Components\Common\Modal\Layout as Modal;
use Simflex\Core\Layout\Components\Common\Modal\ModalSize;
use Simflex\Core\Layout\Components\Common\Modal\ModalTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Core\Dropdown\DropdownSize;
use Simflex\Core\Layout\Components\UI\Core\Dropdown\DropdownTheme;
use Simflex\Core\Layout\Components\UI\Core\Dropdown\Layout as Dropdown;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputSize;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;

$theme = Page::get()->getTheme();
$buttonTheme = ButtonTheme::from($theme);
$iconTheme = ButtonIconTheme::from($theme);
$columns = (json_decode($value, true) ?: [])['s'] ?? [];
$modalId = 'sf-table-editor-' . crc32($this->inputName());
$hasEditor = false;
// действия раздела: у FieldVirtualTable — адрес раздела и запись формы
$searchBase = $attributes['data-sf-table-url'] ?? '';
$searchPk = isset($attributes['data-sf-table-pk']) ? '&' . $attributes['data-sf-table-pk'] : '';

// поле окна строки: значение колонки — в элементе с data-sf-column (без name: окно не отправляется с формой)
$drawControl = function (array $column) use ($theme, $buttonTheme, $searchBase, $searchPk, &$hasEditor): string {
    $name = (string)$column['n'];
    $type = (string)$column['t'];
    $label = strip_tags((string)$column['l']);
    $columnAttributes = ['data-sf-column' => $name, 'aria-label' => $label];
    if (str_starts_with($type, 'editor')) {
        $hasEditor = true;
        return '<div class="form-editor"><textarea class="form-editor__textarea" data-sf-column="'
            . htmlspecialchars($name) . '" data-sf-table-editor aria-label="' . htmlspecialchars($label)
            . '"></textarea></div>';
    }
    if (str_starts_with($type, 'image') || str_starts_with($type, 'file')) {
        $isImage = str_starts_with($type, 'image');
        return '<div class="edit-table-file" data-sf-table-file>'
            . '<input type="hidden" data-sf-column="' . htmlspecialchars($name) . '">'
            . ($isImage ? '<img class="edit-table-file__preview" alt="" hidden>' : '')
            . '<a class="edit-table-file__name" target="_blank" rel="noopener" hidden></a>'
            . '<input class="edit-table-file__input" type="file" tabindex="-1" aria-hidden="true"'
            . ($isImage ? ' accept="image/*"' : '') . '>'
            . '<div class="edit-table-file__buttons">'
            . Button::drawButton(
                text: 'Загрузить',
                style: ButtonStyle::Secondary,
                size: ButtonSize::Small,
                theme: $buttonTheme,
                attributes: ['data-sf-table-upload' => ''],
                iconLeft: 'upload',
            )
            // файл из файлового менеджера (window.fileManager)
            . Button::drawButton(
                text: 'Из библиотеки',
                style: ButtonStyle::Secondary,
                size: ButtonSize::Small,
                theme: $buttonTheme,
                attributes: ['data-sf-table-library' => ''],
                iconLeft: 'folder',
            )
            . Button::drawButton(
                text: 'Удалить',
                style: ButtonStyle::Flat,
                size: ButtonSize::Small,
                theme: $buttonTheme,
                attributes: ['data-sf-table-clear' => ''],
                iconLeft: 'trash',
            )
            . '</div></div>';
    }
    if (str_starts_with($type, 'combo')) {
        $extra = (string)($column['e'] ?? '');
        $inputAttributes = ['data-sf-column' => $name];
        if (($column['c'] ?? '') !== '') {
            $inputAttributes['onchange'] = (string)$column['c'];
        }
        if (str_starts_with($extra, 'AJAX:')) {
            // поиск вариантов действием раздела (ответ [{id, name}]); выбранный вариант строки — тот же запрос с id
            $searchUrl = $searchBase . '?action=' . rawurlencode(substr($extra, 5)) . $searchPk;
            $inputAttributes['data-sf-table-search'] = $searchUrl;
            return Dropdown::drawSelect(
                name: '',
                options: [],
                placeholder: 'Начните вводить название',
                size: DropdownSize::Small,
                theme: DropdownTheme::from($theme),
                attributes: ['aria-label' => $label],
                searchUrl: $searchUrl,
                inputAttributes: $inputAttributes,
            );
        }
        $options = [];
        foreach (explode(',,', $extra) as $option) {
            [$key, $text] = array_pad(explode('=', $option, 2), 2, '');
            $options[$key] = $text;
        }
        return Dropdown::drawSelect(
            name: '',
            options: $options,
            size: DropdownSize::Small,
            theme: DropdownTheme::from($theme),
            attributes: ['aria-label' => $label],
            inputAttributes: $inputAttributes,
        );
    }
    return TextInput::drawInput(
        placeholder: $label,
        size: TextInputSize::Small,
        theme: TextInputTheme::from($theme),
        attributes: $columnAttributes + ['type' => $type === 'int' ? 'number' : 'text'],
    );
};

$controls = '';
foreach ($columns as $column) {
    if (($column['l'] ?? '') === '' || ($column['v'] ?? '') === '__NO_EDIT__') {
        continue;
    }
    $controls .= '<div class="form-input form-input_wide" data-field="' . htmlspecialchars((string)$column['n']) . '">'
        . '<div class="form-input__label">' . $column['l'] . '</div>'
        . '<div class="form-input__control">' . $drawControl($column) . '</div></div>';
}
if ($hasEditor) {
    Editor::addScript();
    $attributes['data-sf-table-editor-config'] = json_encode(Editor::getConfig(), JSON_UNESCAPED_UNICODE);
}
$attributes['data-sf-table-modal'] = $modalId;
$rootAttributes = '';
foreach ($attributes as $key => $attribute) {
    $rootAttributes .= ' ' . $key . '="' . htmlspecialchars((string)$attribute) . '"';
}
?>
<div class="edit-table edit-table-theme_<?= $theme ?>" data-sf="table-editor"<?= $rootAttributes ?>>
    <input type="hidden"<?= $isVirtual ? '' : ' name="' . htmlspecialchars($this->inputName()) . '"' ?>
           value="<?= htmlspecialchars($value) ?>" data-sf-table-value>
    <div class="edit-table__head">
        <?= Button::drawButton(
            text: 'Добавить строку',
            style: ButtonStyle::Secondary,
            size: ButtonSize::Small,
            theme: $buttonTheme,
            attributes: ['data-sf-table-add' => ''],
            iconLeft: 'plus',
        ) ?>
    </div>
    <div class="edit-table__wrap">
        <table class="table-list edit-table__table">
            <thead>
                <tr class="thr">
                    <?php foreach ($columns as $column): ?>
                        <?php if (($column['l'] ?? '') !== ''): ?>
                            <th class="th" scope="col"><div class="th__head"><span class="th__label"><?= $column['l'] ?></span></div></th>
                        <?php endif; ?>
                    <?php endforeach; ?>
                    <th class="th th_controls" scope="col"><div class="th__head"><span class="th__label">Действия</span></div></th>
                </tr>
            </thead>
            <tbody class="table__body" data-sf-table-rows></tbody>
        </table>
    </div>
    <p class="edit-table__empty" data-sf-table-empty hidden>Строк пока нет</p>
    <?php if ($isVirtual): ?>
        <div class="edit-table__footer" data-sf-table-pages hidden>
            <span class="edit-table__info" data-sf-table-info></span>
            <?= ButtonIcon::drawButtonIcon(
                icon: 'chevron-s-left',
                label: 'Предыдущая страница',
                style: ButtonIconStyle::Secondary,
                theme: $iconTheme,
                attributes: ['data-sf-table-page' => '-1'],
            ) ?>
            <?= ButtonIcon::drawButtonIcon(
                icon: 'chevron-s-right',
                label: 'Следующая страница',
                style: ButtonIconStyle::Secondary,
                theme: $iconTheme,
                attributes: ['data-sf-table-page' => '1'],
            ) ?>
        </div>
    <?php endif; ?>
    <template data-sf-table-actions>
        <div class="row-actions">
            <?= ButtonIcon::drawButtonIcon(
                icon: 'pencil-line',
                label: 'Редактировать',
                style: ButtonIconStyle::Secondary,
                theme: $iconTheme,
                attributes: ['data-sf-table-edit' => ''],
            ) ?>
            <?= ButtonIcon::drawButtonIcon(
                icon: 'trash',
                label: 'Удалить',
                style: ButtonIconStyle::Secondary,
                theme: $iconTheme,
                attributes: ['data-sf-table-delete' => ''],
            ) ?>
        </div>
    </template>
    <?= Modal::drawModal(
        id: $modalId,
        title: strip_tags((string)$this->label),
        // не form: окно выводится внутри формы записи, вложенную форму браузер отбросит
        content: '<div class="edit-table__form" data-sf-table-form>' . $controls . '</div>',
        footer: Button::drawButton(
            text: 'Сохранить',
            size: ButtonSize::Small,
            theme: $buttonTheme,
            attributes: ['data-sf-table-save' => ''],
            iconLeft: 'check',
        ) . Button::drawButton(
            text: 'Отмена',
            style: ButtonStyle::Secondary,
            size: ButtonSize::Small,
            theme: $buttonTheme,
            attributes: ['data-modal-close' => ''],
        ),
        size: ModalSize::Medium,
        theme: ModalTheme::from($theme),
        className: 'edit-table__modal',
    ) ?>
</div>
