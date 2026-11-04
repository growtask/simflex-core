<?php

/**
 * Поле ввода формы (Inputs/main)
 * @var string $name
 * @var mixed $value
 * @var string $placeholder
 * @var bool $readonly
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputSize;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;

$attributes = ['name' => $name, 'aria-label' => strip_tags((string)$this->label)];
if ($readonly) {
    $attributes['readonly'] = 'readonly';
}
?>
<?= TextInput::drawInput(
    className: 'form-input__text',
    placeholder: (string)$placeholder,
    size: TextInputSize::Small,
    theme: TextInputTheme::from(Page::get()->getTheme()),
    reset: !$readonly,
    id: 'field-' . $name . '-' . substr(md5((string)$this->table), 0, 6),
    attributes: $attributes,
    value: (string)$value,
) ?>
