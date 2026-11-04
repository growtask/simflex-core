<?php

/**
 * Переключатель в ячейке списка: меняет значение сразу (action=boolChange, theme/js/list.js)
 * @var bool $checked
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\ToggleSwitch\Layout as Toggle;
use Simflex\Core\Layout\Components\UI\Core\ToggleSwitch\ToggleSize;
use Simflex\Core\Layout\Components\UI\Core\ToggleSwitch\ToggleTheme;

$attributes = ['data-sf-bool-change' => '', 'aria-label' => strip_tags($this->label)];
if ($checked) {
    $attributes['checked'] = 'checked';
}
?>
<?= Toggle::drawToggle(
    className: 'td-toggle',
    icon: false,
    size: ToggleSize::Small,
    theme: ToggleTheme::from(Page::get()->getTheme()),
    attributes: $attributes,
) ?>
