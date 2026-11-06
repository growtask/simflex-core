<?php

/**
 * Текстовый фильтр колонки (меню фильтра в шапке, окно фильтров): Enter применяет фильтр (theme/js/list.js)
 * @var string $name
 * @var string $placeholder
 * @var string $value
 * @var bool $isDigits Только цифры (FieldInt): цифровая клавиатура, остальное не вводится
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputSize;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;

?>
<?= TextInput::drawInput(
    className: 'filter-search',
    placeholder: $placeholder !== '' ? $placeholder : 'Поиск',
    size: TextInputSize::Small,
    theme: TextInputTheme::from(Page::get()->getTheme()),
    icon: 'search',
    id: uniqid('filter-' . $name . '-'),
    attributes: ['name' => 'filter[' . $name . ']', 'data-sf-filter' => '', 'autocomplete' => 'off']
        + ($isDigits ? ['inputmode' => 'numeric', 'pattern' => '[0-9]*', 'data-sf-digits' => ''] : []),
    value: (string)$value,
) ?>
