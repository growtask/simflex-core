<?php

/**
 * Список раздела (компоненты макета page-head, table-card: table-toolbar, th-tags, thr/th, tr/td, table-footer,
 * table-empty, table-bar). Поведение — theme/js/list.js
 * @var \Simflex\Core\Admin\Table\Table $this
 * @var list<array> $rows
 * @var \Simflex\Core\Admin\Plugins\Pagination\Pagination $pagination
 * @var int $highlightId Запись, к которой прокручивается и подсвечивается список (?show_id=, ?save_id=)
 * @var string $treeName Колонка с отступом уровня дерева, пусто — список не дерево
 * @var list<array{name: string, label: string, value: string, reset: string}> $filters Выбранные фильтры
 * @var string $search Строка поиска
 * @var int $count Записей по фильтрам
 * @var string $theme
 */

use Simflex\Core\Admin\Fields\Field;
use Simflex\Core\Admin\Fields\FieldString;
use Simflex\Core\Admin\Fields\FieldText;
use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\Common\Modal\Layout as Modal;
use Simflex\Core\Layout\Components\Common\Modal\ModalTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\Checkbox\CheckboxTheme;
use Simflex\Core\Layout\Components\UI\Core\Checkbox\Layout as Checkbox;
use Simflex\Core\Layout\Components\UI\Core\SortButton\Layout as SortButton;
use Simflex\Core\Layout\Components\UI\Core\SortButton\SortButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\SortButton\SortDirection;
use Simflex\Core\Layout\Components\UI\Core\Tag\Layout as Tag;
use Simflex\Core\Layout\Components\UI\Core\Tag\TagSize;
use Simflex\Core\Layout\Components\UI\Core\Tag\TagStyle;
use Simflex\Core\Layout\Components\UI\Core\Tag\TagTheme;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputSize;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;
use Simflex\Core\Layout\Components\UI\Core\Tooltip\Layout as Tooltip;
use Simflex\Core\Layout\Components\UI\Core\Tooltip\TooltipTheme;

$buttonTheme = ButtonTheme::from($theme);
$fields = array_filter($this->fields, fn(Field $field) => $field->isVisible);
// главная колонка растягивается (минимум 280 px): поле с width 1, колонка дерева или первая текстовая
$mainName = $treeName;
foreach ($fields as $field) {
    if ($field->width === 1.0) {
        $mainName = $field->name;
        break;
    }
}
foreach ($fields as $field) {
    if ($mainName === '' && ($field instanceof FieldString || $field instanceof FieldText)) {
        $mainName = $field->name;
    }
}
$sortColumn = $this->getSortColumn();
$isFiltered = $filters || $search !== '';
$hasSearch = (bool)$this->getSearchFields();
$columnStyle = fn(Field $field) => $field->name !== $mainName && $field->width > 1
    ? ' style="width: ' . (int)$field->width . 'px"' : '';
$columnClasses = fn(Field $field, string $base) => implode(' ', array_filter([
    $base,
    'table-data-' . $field->name,
    $field->name === $mainName ? $base . '_main' : '',
    // главная колонка — заголовок карточки на телефоне, не скрывается
    $field->widthMob === 0.0 && $field->name !== $mainName ? $base . '_hide-mobile' : '',
]));

echo Page::get()->drawPageHead(
    $this->title,
    $this->canAdd ? Button::drawButton(
        text: 'Добавить',
        link: '?action=form',
        size: ButtonSize::Small,
        theme: $buttonTheme,
        iconLeft: 'plus',
    ) : '',
);
?>
<section class="table-card table-card-theme_<?= $theme ?>" data-sf="list"
         data-pk="<?= htmlspecialchars($this->pk->name) ?>" aria-label="<?= htmlspecialchars($this->title) ?>">
    <?php if ($hasSearch || $this->isFilter): ?>
        <div class="table-toolbar">
            <?php if ($hasSearch): ?>
                <?= TextInput::drawInput(
                    className: 'table-toolbar__search',
                    placeholder: 'Поиск',
                    size: TextInputSize::Medium,
                    theme: TextInputTheme::from($theme),
                    icon: 'search',
                    id: 'sf-list-search',
                    attributes: [
                        'name' => 'q',
                        'data-sf-filter' => '',
                        'autocomplete' => 'off',
                        'aria-label' => 'Поиск по списку',
                    ],
                    value: $search,
                ) ?>
            <?php endif; ?>
            <?php if ($this->isFilter): ?>
                <?= Button::drawButton(
                    className: 'table-toolbar__filters',
                    text: 'Фильтры',
                    style: ButtonStyle::Secondary,
                    size: ButtonSize::Medium,
                    theme: $buttonTheme,
                    attributes: ['data-modal' => 'sf-modal-filters'],
                    iconLeft: 'filter',
                ) ?>
            <?php endif; ?>
        </div>
    <?php endif; ?>

    <?php if ($filters): ?>
        <div class="th-tags">
            <span class="th-tags__title">Фильтры:</span>
            <?php foreach ($filters as $filter): ?>
                <?= Tag::drawTag(
                    text: htmlspecialchars($filter['label'] . ': ' . $filter['value']),
                    style: TagStyle::Secondary,
                    size: TagSize::ExtraSmall,
                    theme: TagTheme::from($theme),
                    attributes: ['data-sf-filter-reset' => $filter['reset']],
                    close: true,
                    closeLabel: 'Сбросить фильтр «' . $filter['label'] . '»',
                ) ?>
            <?php endforeach; ?>
            <?= Button::drawButton(
                text: 'Сбросить всё',
                link: '?action=filterReset',
                style: ButtonStyle::Flat,
                size: ButtonSize::ExtraSmall,
                theme: $buttonTheme,
            ) ?>
        </div>
    <?php endif; ?>

    <div class="table-card__scroll">
        <table class="table-list">
            <thead>
            <tr class="thr">
                <th class="th th_select" scope="col">
                    <?= Checkbox::drawCheckbox(
                        className: 'th__check',
                        theme: CheckboxTheme::from($theme),
                        attributes: ['data-sf-select-all' => '', 'aria-label' => 'Выбрать все записи'],
                    ) ?>
                </th>
                <?php foreach ($fields as $field): ?>
                    <?php
                    $direction = $field->name !== $sortColumn ? SortDirection::None
                        : ($this->isSortDesc() ? SortDirection::Descending : SortDirection::Ascending);
                    ?>
                    <th class="<?= $columnClasses($field, 'th') ?>" scope="col"
                        aria-sort="<?= $direction->value ?>"<?= $columnStyle($field) ?>>
                        <div class="th__head">
                            <?= SortButton::drawSort(
                                strip_tags($field->label),
                                '?o=' . rawurlencode($field->name) . '&d=0',
                                '?o=' . rawurlencode($field->name) . '&d=1',
                                $direction,
                                theme: SortButtonTheme::from($theme),
                                className: 'th__sort',
                            ) ?>
                            <?php if ($field->help !== ''): ?>
                                <span class="table__head-help">
                                    <?= Tooltip::drawInfo(strip_tags($field->help), TooltipTheme::from($theme)) ?>
                                </span>
                            <?php endif; ?>
                        </div>
                        <?php if ($field->filter): ?>
                            <div class="th__filter"><?= $this->filterField($field) ?></div>
                        <?php endif; ?>
                    </th>
                <?php endforeach; ?>
                <th class="th th_controls table-data-controls" scope="col">
                    <div class="th__head"><span class="th__label">Действия</span></div>
                    <?php if ($isFiltered || isset($this->getState()['order_by'])): ?>
                        <?= Button::drawButton(
                            className: 'btn-reset',
                            text: 'Сброс',
                            link: '?action=filterReset',
                            style: ButtonStyle::Flat,
                            size: ButtonSize::ExtraSmall,
                            theme: $buttonTheme,
                            attributes: ['title' => 'Сбросить фильтры и сортировку'],
                        ) ?>
                    <?php endif; ?>
                </th>
            </tr>
            </thead>
            <tbody class="table__body">
            <?php foreach ($rows as $i => $row): ?>
                <?php $id = $row[$this->pk->name]; ?>
                <tr class="tr table__body-row<?= (int)$id === $highlightId ? ' tr_saved' : '' ?>"
                    data-id="<?= htmlspecialchars((string)$id) ?>">
                    <td class="td td_select table-data-select">
                        <?= Checkbox::drawCheckbox(
                            className: 'td__check',
                            theme: CheckboxTheme::from($theme),
                            attributes: [
                                'name' => 'row[]',
                                'value' => (string)$id,
                                'data-sf-row-select' => '',
                                'aria-label' => 'Выбрать запись ' . $id,
                            ],
                        ) ?>
                    </td>
                    <?php foreach ($fields as $field): ?>
                        <?php
                        $field->pkValue = $id;
                        $level = $field->name === $treeName ? (int)($row['tree_level'] ?? 0) : 0;
                        ?>
                        <td class="<?= $columnClasses($field, 'td') ?><?= $level ? ' td_level td_level_' . min($level, 6) : '' ?>"
                            data-field="<?= htmlspecialchars($field->name) ?>" data-pk="<?= htmlspecialchars((string)$id) ?>"
                            data-label="<?= htmlspecialchars(strip_tags($field->label)) ?>">
                            <?= $this->showCell($field, $row) ?>
                        </td>
                    <?php endforeach; ?>
                    <td class="td td_controls table-data-controls"><?= $this->rowActions($row, $i) ?></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>

        <?php if (!$rows): ?>
            <div class="table-empty">
                <span class="table-empty__icon">
                    <?= renderIcon($isFiltered ? 'search-x' : 'package', 'table-empty__icon-svg') ?>
                </span>
                <h2 class="table-empty__title"><?= $isFiltered ? 'Ничего не найдено' : 'Записей пока нет' ?></h2>
                <p class="table-empty__text">
                    <?= $isFiltered ? 'Измените условия поиска или сбросьте фильтры.' : 'Добавьте первую запись раздела.' ?>
                </p>
                <?php if ($isFiltered): ?>
                    <?= Button::drawButton(
                        text: 'Сбросить фильтры',
                        link: '?action=filterReset',
                        style: ButtonStyle::Secondary,
                        size: ButtonSize::Small,
                        theme: $buttonTheme,
                    ) ?>
                <?php elseif ($this->canAdd): ?>
                    <?= Button::drawButton(
                        text: 'Добавить',
                        link: '?action=form',
                        size: ButtonSize::Small,
                        theme: $buttonTheme,
                        iconLeft: 'plus',
                    ) ?>
                <?php endif; ?>
            </div>
        <?php endif; ?>
    </div>

    <?= $pagination->content() ?>
</section>

<div class="table-bar table-bar-theme_<?= $theme ?>" data-sf-table-bar role="toolbar" aria-label="Действия с записями">
    <?= $this->showActions() ?>
    <span class="table-bar__count" data-sf-selected hidden>
        Выбрано: <b data-sf-selected-count>0</b>
        <button type="button" class="table-bar__clear" data-sf-select-clear aria-label="Снять выбор">
            <?= renderIcon('close', 'table-bar__clear-icon') ?>
        </button>
    </span>
</div>

<?php if ($this->isFilter): ?>
    <?php
    // окно фильтров (на планшете и телефоне шапки таблицы нет): те же фильтры колонок
    $modalFilters = '';
    foreach ($fields as $field) {
        if ($field->filter) {
            $modalFilters .= '<div class="modal-filters__field"><span class="modal-filters__label">'
                . htmlspecialchars(strip_tags($field->label)) . '</span>' . $this->filterField($field) . '</div>';
        }
    }
    ?>
    <?= Modal::drawModal(
        id: 'sf-modal-filters',
        title: 'Фильтры',
        content: '<div class="modal-filters" data-sf-filters-modal>' . $modalFilters . '</div>',
        footer: Button::drawButton(
            text: 'Применить',
            size: ButtonSize::Small,
            theme: $buttonTheme,
            attributes: ['data-sf-filters-apply' => ''],
        ) . Button::drawButton(
            text: 'Сбросить',
            link: '?action=filterReset',
            style: ButtonStyle::Outline,
            size: ButtonSize::Small,
            theme: $buttonTheme,
        ),
        theme: ModalTheme::from($theme),
    ) ?>
<?php endif; ?>
