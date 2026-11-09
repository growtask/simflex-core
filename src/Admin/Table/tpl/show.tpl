<?php

/**
 * Список раздела (компоненты макета page-head, table-card: table-toolbar, th-tags, thr/th/th-actions, tr/td,
 * table-footer, table-empty, table-bar). Поведение — theme/js/list.js
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
use Simflex\Core\Layout\Components\Common\Modal\ModalSize;
use Simflex\Core\Layout\Components\Common\Modal\ModalTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\Badge\BadgeStyle;
use Simflex\Core\Layout\Components\UI\Core\Badge\Layout as Badge;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Core\Checkbox\CheckboxTheme;
use Simflex\Core\Layout\Components\UI\Core\Checkbox\Layout as Checkbox;
use Simflex\Core\Layout\Components\UI\Core\Dropdown\DropdownTheme;
use Simflex\Core\Layout\Components\UI\Core\Dropdown\Layout as Dropdown;
use Simflex\Core\Layout\Components\UI\Core\Link\Layout as Link;
use Simflex\Core\Layout\Components\UI\Core\Link\LinkSize;
use Simflex\Core\Layout\Components\UI\Core\Link\LinkTheme;
use Simflex\Core\Layout\Components\UI\Core\SortButton\Layout as SortButton;
use Simflex\Core\Layout\Components\UI\Core\SortButton\SortButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\SortButton\SortButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\SortButton\SortDirection;
use Simflex\Core\Layout\Components\UI\Core\Tag\Layout as Tag;
use Simflex\Core\Layout\Components\UI\Core\Tag\TagSize;
use Simflex\Core\Layout\Components\UI\Core\Tag\TagStyle;
use Simflex\Core\Layout\Components\UI\Core\Tab\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabStyle;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabTheme;
use Simflex\Core\Layout\Components\UI\Core\Tag\TagTheme;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputSize;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;
use Simflex\Core\Layout\Components\UI\Core\Tooltip\Layout as Tooltip;
use Simflex\Core\Layout\Components\UI\Core\Tooltip\TooltipPosition;
use Simflex\Core\Layout\Components\UI\Core\Tooltip\TooltipSide;
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
// колонка, сортировку по которой выбрали в списке (по умолчанию — нет): у неё кнопка «Сбросить»
$sortedColumn = (string)($this->getState()['order_by'] ?? '');
$isFiltered = $filters || $search !== '';
$searchFields = $this->getSearchFields();
$hasSearch = (bool)$searchFields;
$searchScope = $this->getSearchScope();
$filterValues = array_column($filters, 'value', 'name');
// теги над таблицей: фильтры колонок и поиск
$tags = $filters;
if ($search !== '') {
    $tags[] = [
        'name' => 'q',
        'label' => 'Поиск' . ($searchScope !== '' ? ' (' . strip_tags($searchFields[$searchScope]->label) . ')' : ''),
        'value' => $search,
        'reset' => Page::get()->getPath() . '?' . http_build_query(['q' => '', 'p' => 0]),
    ];
}
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
            <?php if (count($searchFields) > 1): ?>
                <?php
                // «где искать»: во всех колонках поиска или в одной
                $scopes = ['' => 'Везде'];
                foreach ($searchFields as $field) {
                    $scopes[$field->name] = strip_tags($field->label);
                }
                $scopeItems = [];
                foreach ($scopes as $name => $scopeLabel) {
                    $scopeItems[] = [
                        'text' => $scopeLabel,
                        'link' => '?' . http_build_query(['qf' => $name, 'p' => 0]),
                        'icon' => $name === $searchScope ? 'check' : '',
                        'active' => $name === $searchScope,
                    ];
                }
                ?>
                <?= Dropdown::drawMenu(
                    Tab::drawTab(
                        className: 'table-scope__trigger',
                        text: htmlspecialchars($searchScope === '' ? 'Везде'
                            : strip_tags($searchFields[$searchScope]->label)),
                        iconRight: 'chevron-s-down',
                        style: TabStyle::Outline,
                        theme: TabTheme::from($theme),
                        attributes: ['type' => 'button', 'title' => 'Где искать'],
                    ),
                    $scopeItems,
                    theme: DropdownTheme::from($theme),
                    side: 'left',
                    label: 'Где искать',
                    className: 'table-scope',
                ) ?>
            <?php endif; ?>
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
                        'data-sf-search' => '',
                        'autocomplete' => 'off',
                        'aria-label' => 'Поиск по списку',
                    ],
                    value: $search,
                ) ?>
            <?php endif; ?>
            <?php if ($this->isFilter): ?>
                <span class="table-toolbar__filters">
                    <?= Button::drawButton(
                        className: 'table-toolbar__filters-button',
                        style: ButtonStyle::Secondary,
                        size: ButtonSize::Medium,
                        theme: $buttonTheme,
                        attributes: [
                            'data-modal' => 'sf-modal-filters',
                            'aria-label' => 'Фильтры' . ($filters ? ', задано: ' . count($filters) : ''),
                            'title' => 'Фильтры',
                        ],
                        iconLeft: 'filter',
                    ) ?>
                    <?php if ($filters): ?>
                        <?= Badge::drawBadge(
                            className: 'table-toolbar__filters-count',
                            text: (string)count($filters),
                            style: BadgeStyle::Primary,
                            attributes: ['aria-hidden' => 'true'],
                        ) ?>
                    <?php endif; ?>
                </span>
            <?php endif; ?>
        </div>
    <?php endif; ?>

    <?php if ($tags): ?>
        <div class="th-tags">
            <span class="th-tags__title">Фильтры:</span>
            <div class="th-tags__list">
                <?php foreach ($tags as $tag): ?>
                    <?= Tag::drawTag(
                        text: htmlspecialchars(strip_tags($tag['label']) . ': ' . $tag['value']),
                        style: TagStyle::Secondary,
                        size: TagSize::ExtraSmall,
                        theme: TagTheme::from($theme),
                        attributes: ['data-sf-filter-reset' => $tag['reset']],
                        close: true,
                        closeLabel: 'Сбросить фильтр «' . strip_tags($tag['label']) . '»',
                    ) ?>
                <?php endforeach; ?>
                <a class="th-tags__clear-tag" href="?action=filterReset">Убрать всё</a>
            </div>
            <?= ButtonIcon::drawButtonIcon(
                icon: 'close',
                label: 'Сбросить все фильтры',
                className: 'th-tags__clear',
                theme: ButtonIconTheme::from($theme),
                link: '?action=filterReset',
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
                        <?php if ($field->isSortable): ?>aria-sort="<?= $direction->value ?>"<?php endif; ?>
                        <?= $columnStyle($field) ?>>
                        <div class="th__head">
                            <?php $label = htmlspecialchars(strip_tags($field->label)); ?>
                            <?php if ($field->help !== ''): ?>
                                <?php // подсказка — при наведении на название и фокусе на нём ?>
                                <?= Tooltip::drawTooltip(
                                    '<span class="th__label th__label_help" tabindex="0">' . $label . '</span>',
                                    strip_tags($field->help),
                                    TooltipPosition::Top,
                                    TooltipSide::Left,
                                    theme: TooltipTheme::from($theme),
                                    className: 'th__help',
                                ) ?>
                            <?php else: ?>
                                <span class="th__label"><?= $label ?></span>
                            <?php endif; ?>
                            <?php
                            // сортировка (th-actions): один шеврон — серый без сортировки, акцентный по этой
                            // колонке (вверх — по возрастанию, вниз — по убыванию); клик — следующее направление
                            $isAscending = $direction === SortDirection::Ascending;
                            ?>
                            <?php if ($field->isSortable): ?>
                            <?= SortButton::drawSortButton(
                                up: $isAscending,
                                label: strip_tags($field->label) . ': сортировать по '
                                    . ($isAscending ? 'убыванию' : 'возрастанию'),
                                link: '?o=' . rawurlencode($field->name) . '&d=' . ($isAscending ? '1' : '0'),
                                active: $direction !== SortDirection::None,
                                style: SortButtonStyle::Line,
                                theme: SortButtonTheme::from($theme),
                                className: 'th__sort',
                            ) ?>
                            <?php endif; ?>
                            <?php if ($field->filter): ?>
                                <?= $this->thFilter($field) ?>
                            <?php endif; ?>
                            <?php if (($field->isSortable && $field->name === $sortedColumn)
                                || isset($filterValues[$field->name])): ?>
                                <?= ButtonIcon::drawButtonIcon(
                                    icon: 'close',
                                    label: 'Сбросить сортировку и фильтр колонки «' . strip_tags($field->label) . '»',
                                    className: 'th__reset',
                                    theme: ButtonIconTheme::from($theme),
                                    link: '?' . http_build_query(['action' => 'columnReset', 'column' => $field->name]),
                                ) ?>
                            <?php endif; ?>
                        </div>
                    </th>
                <?php endforeach; ?>
                <th class="th th_controls table-data-controls" scope="col">
                    <div class="th__head"><span class="th__label">Действия</span></div>
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
    // окно фильтров: те же фильтры колонок, у заданного — точка перед подписью
    $modalFilters = '';
    foreach ($fields as $field) {
        if ($field->filter) {
            $isSet = isset($filterValues[$field->name]);
            $modalFilters .= '<div class="modal-filters__field' . ($isSet ? ' modal-filters__field_set' : '') . '">'
                . '<span class="modal-filters__label">' . htmlspecialchars(strip_tags($field->label))
                . ($isSet ? '<span class="visually-hidden"> (задан)</span>' : '') . '</span>'
                . $this->filterField($field) . '</div>';
        }
    }
    ?>
    <?= Modal::drawModal(
        id: 'sf-modal-filters',
        title: 'Фильтры',
        content: '<div class="modal-filters" data-sf-filters-modal>' . $modalFilters . '</div>',
        footer: Button::drawButton(
            className: 'modal-filters__apply',
            text: 'Применить фильтры',
            size: ButtonSize::Medium,
            theme: $buttonTheme,
            attributes: ['data-sf-filters-apply' => ''],
        ),
        size: ModalSize::Small,
        theme: ModalTheme::from($theme),
        className: 'modal-filters-window',
        headAction: Link::drawLink(
            className: 'modal-filters__reset',
            text: 'Сбросить',
            href: '?action=filterReset',
            size: LinkSize::Small,
            theme: LinkTheme::from($theme),
        ),
    ) ?>
<?php endif; ?>
