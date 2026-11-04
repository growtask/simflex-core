<?php

/**
 * Поле даты, даты и времени или времени (Inputs/date + Calendar): маска и календарь под полем.
 * Значение — в формате поля: ДД.ММ.ГГГГ, ДД.ММ.ГГГГ ЧЧ:ММ, ЧЧ:ММ (getPOST() поля переводит его в формат БД)
 * @var \Simflex\Core\Admin\Fields\Field $this
 * @var string $name
 * @var string $value
 * @var \Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputKind $kind
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
    className: 'form-input__text form-input__date',
    size: TextInputSize::Small,
    theme: TextInputTheme::from(Page::get()->getTheme()),
    id: 'field-' . $name . '-' . substr(md5((string)$this->table), 0, 6),
    attributes: $attributes,
    kind: $kind,
    value: $value,
) ?>
