<?php

/**
 * Переключатель в ячейке списка: меняет значение сразу (action=boolChange, theme/js/list.js)
 * @var bool $checked
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\Layout as Toggle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\SwitchToggleSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\SwitchToggleTheme;

$attributes = ['data-sf-bool-change' => '', 'aria-label' => strip_tags($this->label)];
if ($checked) {
    $attributes['checked'] = 'checked';
}
?>
<?= Toggle::drawSwitchToggle(
    className: 'td-toggle',
    icon: false,
    size: SwitchToggleSize::Small,
    theme: SwitchToggleTheme::from(Page::get()->getTheme()),
    attributes: $attributes,
) ?>
