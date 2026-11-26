<?php

/**
 * Переключатель формы (Switches/toggle): значение 1 при включении
 * @var string $name
 * @var bool $checked
 * @var bool $readonly
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\Layout as Toggle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\SwitchToggleTheme;

$attributes = ['name' => $name, 'value' => '1', 'aria-label' => strip_tags((string)$this->label)];
if ($checked) {
    $attributes['checked'] = 'checked';
}
if ($readonly) {
    $attributes['disabled'] = 'disabled';
}
?>
<?= Toggle::drawSwitchToggle(
    className: 'form-input__toggle',
    theme: SwitchToggleTheme::from(Page::get()->getTheme()),
    attributes: $attributes,
) ?>
<?php if ($readonly && $checked): ?>
    <?php // недоступный переключатель не отправляется: значение — скрытым полем ?>
    <input type="hidden" name="<?= htmlspecialchars($name) ?>" value="1">
<?php endif; ?>
