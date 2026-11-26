<?php

/**
 * Фильтр колонки в шапке списка (компоненты макета th-filter, th-actions): кнопка с бейджем и меню 240 px —
 * значения переключателями radio или фильтр поля (поиск), «Применить» и «Сбросить». Поведение — theme/js/list.js
 * @var \Simflex\Core\Admin\Table\Table $this
 * @var \Simflex\Core\Admin\Fields\Field $field
 * @var string $value Выбранное значение, '' — фильтр не задан
 * @var string $control Фильтр поля (Field::filter()), пусто — значения переключателями
 * @var string $theme
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Badge\BadgeStyle;
use Simflex\Core\Layout\Components\UI\Badge\Layout as Badge;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\Layout as Radio;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\SwitchRadioTheme;

$label = strip_tags($field->label);
$menuId = 'sf-th-filter-' . $field->name;
$isSet = $value !== '';
$buttonTheme = ButtonMainTheme::from($theme);
$reset = Page::get()->getPath() . '?' . http_build_query(['filter' => [$field->name => ''], 'p' => 0]);
?>
<div class="th-filter<?= $isSet ? ' th-filter_set' : '' ?>" data-sf-th-filter>
    <?= ButtonIcon::drawButtonIconSmall(
        icon: 'filter',
        label: 'Фильтр: ' . $label,
        className: 'th-filter__button',
        style: ButtonIconSmallStyle::Secondary,
        theme: ButtonIconSmallTheme::from($theme),
        attributes: [
            'aria-haspopup' => 'dialog',
            'aria-expanded' => 'false',
            'aria-controls' => $menuId,
            'data-sf-th-filter-toggle' => '',
        ],
    ) ?>
    <?php if ($isSet): ?>
        <?= Badge::drawBadge(
            className: 'th-filter__count',
            text: '1',
            style: BadgeStyle::Primary,
            attributes: ['aria-label' => 'Фильтр задан'],
        ) ?>
    <?php endif; ?>
    <div class="th-filter__menu" id="<?= $menuId ?>" role="dialog"
         aria-label="<?= htmlspecialchars('Фильтр: ' . $label) ?>" hidden>
        <?php if ($control !== ''): ?>
            <div class="th-filter__control"><?= $control ?></div>
        <?php else: ?>
            <div class="th-filter__options" role="radiogroup" aria-label="<?= htmlspecialchars($label) ?>">
                <?php foreach ($field->getFilterOptions() ?? [] as $optionValue => $optionLabel): ?>
                    <?php
                    $attributes = [
                        'name' => 'filter[' . $field->name . ']',
                        'value' => (string)$optionValue,
                        'data-sf-filter' => '',
                    ];
                    if ((string)$optionValue === $value) {
                        $attributes['checked'] = 'checked';
                    }
                    ?>
                    <?= Radio::drawSwitchRadio(
                        className: 'th-filter__option',
                        // подпись не длиннее 2 строк: полностью — во всплывающей подсказке браузера
                        text: '<span title="' . htmlspecialchars($optionLabel) . '">'
                            . htmlspecialchars($optionLabel) . '</span>',
                        id: $menuId . '-' . md5((string)$optionValue),
                        value: (string)$optionValue,
                        theme: SwitchRadioTheme::from($theme),
                        attributes: $attributes,
                    ) ?>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
        <div class="th-filter__buttons">
            <?= Button::drawButtonMain(
                className: 'th-filter__apply',
                text: 'Применить',
                size: ButtonMainSize::Small,
                theme: $buttonTheme,
                attributes: ['data-sf-th-filter-apply' => ''],
            ) ?>
            <?= Button::drawButtonMain(
                className: 'th-filter__reset',
                text: 'Сбросить',
                link: $reset,
                style: ButtonMainStyle::Secondary,
                size: ButtonMainSize::Small,
                theme: $buttonTheme,
            ) ?>
        </div>
    </div>
</div>
