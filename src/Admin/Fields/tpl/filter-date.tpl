<?php

/**
 * Фильтр периода у полей даты (меню фильтра колонки, окно фильтров): «От» и «До» с календарём. Значение
 * ГГГГ-ММ-ДД|ГГГГ-ММ-ДД собирает theme/js/list.js в скрытое поле filter[name] ([data-sf-filter])
 * @var string $name
 * @var string $label Название поля
 * @var string $value ГГГГ-ММ-ДД|ГГГГ-ММ-ДД или пусто
 * @var string $from ДД.ММ.ГГГГ
 * @var string $to ДД.ММ.ГГГГ
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputKind;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputSize;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;

$theme = TextInputTheme::from(Page::get()->getTheme());
$draw = fn(string $side, string $placeholder, string $date) => TextInput::drawInput(
    className: 'filter-date__input',
    placeholder: $placeholder,
    size: TextInputSize::Small,
    theme: $theme,
    id: uniqid('filter-' . $name . '-' . $side . '-'),
    attributes: [
        'data-sf-date-range' => $side,
        'autocomplete' => 'off',
        'aria-label' => $label . ': ' . mb_strtolower($placeholder),
    ],
    kind: TextInputKind::Date,
    value: $date,
);
?>
<div class="filter-date" data-sf-date-range-box>
    <?= $draw('from', 'От', $from) ?>
    <?= $draw('to', 'До', $to) ?>
    <input type="hidden" name="filter[<?= htmlspecialchars($name) ?>]" value="<?= htmlspecialchars($value) ?>"
           data-sf-filter data-sf-date-range-value>
</div>
