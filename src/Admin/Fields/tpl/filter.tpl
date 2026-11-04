<?php

/**
 * Текстовый фильтр в шапке колонки списка: Enter отправляет форму фильтров (theme/js/list.js)
 * @var string $name
 * @var string $placeholder
 * @var string $value
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputSize;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;

?>
<?= TextInput::drawInput(
    className: 'th-filter',
    placeholder: $placeholder !== '' ? $placeholder : 'Фильтр',
    size: TextInputSize::Small,
    theme: TextInputTheme::from(Page::get()->getTheme()),
    icon: 'filter',
    id: uniqid('filter-' . $name . '-'),
    attributes: ['name' => 'filter[' . $name . ']', 'data-sf-filter' => '', 'autocomplete' => 'off'],
    value: (string)$value,
) ?>
