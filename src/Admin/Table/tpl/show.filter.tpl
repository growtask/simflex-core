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
use Simflex\Core\Layout\Components\UI\Core\Badge\BadgeStyle;
use Simflex\Core\Layout\Components\UI\Core\Badge\Layout as Badge;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Core\RadioOption\Layout as Radio;
use Simflex\Core\Layout\Components\UI\Core\RadioOption\RadioTheme;

$label = strip_tags($field->label);
$menuId = 'sf-th-filter-' . $field->name;
$isSet = $value !== '';
$buttonTheme = ButtonTheme::from($theme);
$reset = Page::get()->getPath() . '?' . http_build_query(['filter' => [$field->name => ''], 'p' => 0]);
?>
<div class="th-filter<?= $isSet ? ' th-filter_set' : '' ?>" data-sf-th-filter>
    <?= ButtonIcon::drawButtonIcon(
        icon: 'filter',
        label: 'Фильтр: ' . $label,
        className: 'th-filter__button',
        style: ButtonIconStyle::Secondary,
        theme: ButtonIconTheme::from($theme),
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
                    <?= Radio::drawRadio(
                        className: 'th-filter__option',
                        // подпись не длиннее 2 строк: полностью — во всплывающей подсказке браузера
                        text: '<span title="' . htmlspecialchars($optionLabel) . '">'
                            . htmlspecialchars($optionLabel) . '</span>',
                        id: $menuId . '-' . md5((string)$optionValue),
                        value: (string)$optionValue,
                        theme: RadioTheme::from($theme),
                        attributes: $attributes,
                    ) ?>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
        <div class="th-filter__buttons">
            <?= Button::drawButton(
                className: 'th-filter__apply',
                text: 'Применить',
                size: ButtonSize::Small,
                theme: $buttonTheme,
                attributes: ['data-sf-th-filter-apply' => ''],
            ) ?>
            <?= Button::drawButton(
                className: 'th-filter__reset',
                text: 'Сбросить',
                link: $reset,
                style: ButtonStyle::Secondary,
                size: ButtonSize::Small,
                theme: $buttonTheme,
            ) ?>
        </div>
    </div>
</div>
