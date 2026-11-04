<?php

/**
 * Страница редактирования (компоненты макета page-head, edit-tabs, form-section, form-input, bulk-field, edit-aside,
 * aside-mobile, edit-bar). Поведение — theme/js/form.js.
 *
 * Секции: поля без группы — «Основное», группы pos_group и группы параметров — свои секции; правая панель —
 * поля pos=right и параметры params['right'], «Создано/Изменено». Вкладки (параметр tab поля и группы) видны,
 * если их больше одной
 *
 * @var \Simflex\Core\Admin\Table\Table $this
 * @var array $row
 * @var array $params Значения params записи
 * @var string $title
 * @var bool $isGroup Групповое редактирование (?ids=1,2,3)
 * @var string|null $ids
 */

use Simflex\Core\Admin\Fields\Field;
use Simflex\Core\Admin\Page;
use Simflex\Core\Helpers\Str;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Core\Checkbox\CheckboxSize;
use Simflex\Core\Layout\Components\UI\Core\Checkbox\CheckboxTheme;
use Simflex\Core\Layout\Components\UI\Core\Checkbox\Layout as Checkbox;
use Simflex\Core\Layout\Components\UI\Core\Notice\Layout as Notice;
use Simflex\Core\Layout\Components\UI\Core\Notice\NoticeStyle;
use Simflex\Core\Layout\Components\UI\Core\Notice\NoticeTheme;
use Simflex\Core\Layout\Components\UI\Core\Tab\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabSize;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabStyle;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabTheme;

$theme = Page::get()->getTheme();
$buttonTheme = ButtonTheme::from($theme);
$isGroup = $isGroup ?? false;

/** Поле формы (form-input): название, поле, подсказка, ошибка; при групповом редактировании — «Изменять это поле» */
$drawInput = function (Field $field, string $input) use ($isGroup, $theme): string {
    $isWide = $field->isWide();
    $errors = $this->errors[$field->label] ?? [];
    $classes = 'form-input' . ($isWide ? ' form-input_wide' : '') . ($errors ? ' form-input_error' : '')
        . ($isGroup ? ' form-input_bulk' : '');
    $html = '<div class="' . $classes . '" data-field="' . htmlspecialchars($field->name) . '"'
        . ($errors ? ' data-sf-error' : '') . '>';
    if ($isGroup) {
        $html .= Checkbox::drawCheckbox(
            className: 'form-input__bulk',
            text: 'Изменять это поле',
            size: CheckboxSize::Small,
            theme: CheckboxTheme::from($theme),
            attributes: ['name' => 'set[' . $field->name . ']', 'data-sf-bulk' => ''],
        );
    }
    $html .= '<div class="form-input__label">' . $field->label
        . ($field->required ? ' <span class="form-input__required" aria-hidden="true">*</span>' : '') . '</div>'
        . '<div class="form-input__control">' . $input . '</div>';
    if ($field->help !== '') {
        $html .= '<div class="form-input__help">' . $field->help . '</div>';
    }
    foreach ($errors as $error) {
        $html .= '<div class="form-input__error" role="alert">' . $error . '</div>';
    }

    return $html . '</div>';
};

// секции: колонка (main / aside) => ключ => [title, tab, inputs]
$sections = ['main' => [], 'aside' => []];
$addInput = function (string $column, string $title, string $tab, string $html) use (&$sections): void {
    $key = $tab . '|' . $title;
    $sections[$column][$key] ??= ['title' => $title, 'tab' => $tab, 'inputs' => []];
    $sections[$column][$key]['inputs'][] = $html;
};

foreach ($this->fields as $field) {
    if ($field->hidden) {
        continue;
    }
    $column = ($field->params['pos'] ?? '') === 'right' ? 'aside' : 'main';
    $group = (string)($field->params['pos_group'] ?? '');
    $addInput(
        $column,
        $group !== '' ? $group : ($column === 'main' ? 'Основное' : 'Параметры'),
        (string)($field->params['tab'] ?? ''),
        $drawInput($field, $this->formFieldInput($field, $row))
    );
}

// параметры (params записи): без группы — секциями по group_name, группы — своими секциями
foreach (['left' => 'main', 'right' => 'aside'] as $position => $column) {
    foreach ($this->params[$position] as $param) {
        if (isset($param['field'])) {
            $field = $param['field'];
            Field::setFieldValue($field, null, $params, $row);
            $addInput(
                $column,
                ($param['group_name'] ?? '') ?: 'Параметры',
                (string)($param['tab'] ?? ''),
                $drawInput($field, $field->input($field->value))
            );
        }
    }
    foreach ($this->params[$position] as $group) {
        foreach ($group['fields'] ?? [] as $field) {
            Field::setFieldValue($field, $group, $params, $row);
            $addInput($column, (string)$group['label'], (string)($group['tab'] ?? ''), $drawInput($field, $field->input($field->value)));
        }
    }
}

$rightPortlets = $this->portlets('right');
$timeInfo = $isGroup ? [] : $this->getTimeInfo($row);
$hasAside = $sections['aside'] || $rightPortlets !== '' || $this->extraRight !== '' || $timeInfo;

// вкладки: в порядке появления, без вкладки — «Основное»
$tabs = [];
foreach ([...$sections['main'], ...$sections['aside']] as $section) {
    $tabs[$section['tab']] = $section['tab'] !== '' ? $section['tab'] : 'Основное';
}
$tabIds = [];
foreach ($tabs as $tab => $tabLabel) {
    $tabIds[$tab] = 'tab-' . (Str::translite($tabLabel) ?: md5($tabLabel));
}
$hasTabs = count($tabs) > 1;

$drawSection = function (array $section, int $index, string $column) use ($hasTabs, $tabIds): string {
    $id = 'sf-form-section-' . $column . '-' . $index;
    $tabAttr = $hasTabs ? ' data-sf-tab="' . $tabIds[$section['tab']] . '"' : '';

    return '<section class="form-section form-section_open"' . $tabAttr . ' data-sf-form-section>'
        . '<h2 class="form-section__title"><button type="button" class="form-section__head" aria-expanded="true"'
        . ' aria-controls="' . $id . '"><span class="form-section__name">' . $section['title'] . '</span>'
        . renderIcon('chevron-m-down', 'form-section__chevron') . '</button></h2>'
        . '<div class="form-section__body" id="' . $id . '"><div class="form-section__grid">'
        . implode('', $section['inputs']) . '</div></div></section>';
};

$errorTexts = [];
foreach ($this->errors as $key => $error) {
    foreach ((array)$error as $text) {
        $errorTexts[] = (is_string($key) ? strip_tags($key) . ': ' : '') . strip_tags((string)$text);
    }
}
$save = fn(string $class) => Button::drawButton(
    className: $class,
    text: 'Сохранить',
    size: ButtonSize::Small,
    theme: $buttonTheme,
    attributes: ['type' => 'submit', 'name' => 'submit_apply'],
    iconLeft: 'check',
);
?>
<form class="edit-form edit-form-theme_<?= $theme ?>" method="post" action="?action=save" enctype="multipart/form-data"
      data-sf="edit-form">
    <input id="sf-form-submit" type="hidden" name="submit_save" value=""/>
    <input type="hidden" name="request_uri" value="<?= htmlspecialchars($this->request->getUri()) ?>"/>
    <input type="hidden" id="info-table" value="<?= $this->table ?>"/>
    <input type="hidden" id="info-key-name" value="<?= @$this->pk->name ?>"/>
    <input type="hidden" id="info-key-value" value="<?= (int)@$row[$this->pk->name] ?>"/>
    <input type="hidden" id="group-ids" name="group_ids" value="<?= htmlspecialchars($ids ?? '') ?>"/>
    <?php foreach ($this->fields as $field): ?>
        <?php if ($field->hidden): ?>
            <?= $field->inputHidden($row[$field->name] ?? '') ?>
        <?php endif; ?>
    <?php endforeach; ?>

    <?= Page::get()->drawPageHead(strip_tags(html_entity_decode($title)), $save('page-head__save')) ?>

    <?php if ($errorTexts): ?>
        <?= Notice::drawNotice(
            'При сохранении возникли ошибки',
            implode('; ', $errorTexts),
            NoticeStyle::Error,
            NoticeTheme::from($theme),
            className: 'edit-form__errors',
        ) ?>
    <?php endif; ?>

    <?php if ($hasTabs): ?>
        <div class="edit-tabs" role="tablist" aria-label="Разделы формы">
            <?php foreach ($tabs as $tab => $tabLabel): ?>
                <?= Tab::drawTab(
                    className: 'edit-tabs__tab',
                    text: htmlspecialchars($tabLabel),
                    style: TabStyle::Underline,
                    size: TabSize::Small,
                    theme: TabTheme::from($theme),
                    attributes: ['role' => 'tab', 'data-sf-tab-button' => $tabIds[$tab], 'id' => $tabIds[$tab] . '-button'],
                    active: $tab === array_key_first($tabs),
                ) ?>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>

    <div class="edit-layout<?= $hasAside ? ' edit-layout_aside' : '' ?>">
        <div class="edit-main">
            <?php $index = 0; ?>
            <?php foreach ($sections['main'] as $section): ?>
                <?= $drawSection($section, ++$index, 'main') ?>
            <?php endforeach; ?>
            <?= $this->extraLeft ?>
            <?= $this->portlets('left') ?>
            <div class="ajax-params-left"></div>
        </div>

        <?php if ($hasAside): ?>
            <aside class="edit-aside" aria-label="Дополнительно" data-sf-edit-aside>
                <div class="edit-aside__head">
                    <span class="edit-aside__title">Дополнительно</span>
                    <?= ButtonIcon::drawButtonIcon(
                        icon: 'panel-right-close',
                        label: 'Скрыть панель',
                        className: 'edit-aside__toggle',
                        style: ButtonIconStyle::Secondary,
                        theme: ButtonIconTheme::from($theme),
                        attributes: ['data-sf-aside-toggle' => '', 'aria-expanded' => 'true'],
                    ) ?>
                </div>
                <div class="edit-aside__body">
                    <?php $index = 0; ?>
                    <?php foreach ($sections['aside'] as $section): ?>
                        <?= $drawSection($section, ++$index, 'aside') ?>
                    <?php endforeach; ?>
                    <?php if ($timeInfo): ?>
                        <dl class="edit-aside__times">
                            <?php foreach ($timeInfo as $label => $value): ?>
                                <div><dt><?= $label ?></dt><dd><?= htmlspecialchars($value) ?></dd></div>
                            <?php endforeach; ?>
                        </dl>
                    <?php endif; ?>
                    <?= $rightPortlets ?>
                    <?= $this->extraRight ?>
                    <div class="ajax-params"></div>
                </div>
            </aside>
        <?php endif; ?>
    </div>

    <div class="edit-bar edit-bar-theme_<?= $theme ?>" role="toolbar" aria-label="Сохранение">
        <?= $save('edit-bar__save') ?>
        <?= Button::drawButton(
            className: 'edit-bar__save-exit',
            text: 'Сохранить и выйти',
            style: ButtonStyle::Secondary,
            size: ButtonSize::Small,
            theme: $buttonTheme,
            attributes: ['type' => 'submit', 'name' => 'submit_save'],
        ) ?>
        <?= Button::drawButton(
            className: 'edit-bar__cancel',
            text: 'Отмена',
            link: Page::get()->getPath(),
            style: ButtonStyle::Outline,
            size: ButtonSize::Small,
            theme: $buttonTheme,
        ) ?>
    </div>
</form>
