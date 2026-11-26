<?php

/**
 * Поле даты, даты и времени или времени (Inputs/date + Calendar): маска и календарь под полем.
 * Значение — в формате поля: ДД.ММ.ГГГГ, ДД.ММ.ГГГГ ЧЧ:ММ, ЧЧ:ММ (getPOST() поля переводит его в формат БД)
 * @var \Simflex\Core\Admin\Fields\Field $this
 * @var string $name
 * @var string $value
 * @var \Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainKind $kind
 * @var bool $readonly
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;

$attributes = ['name' => $name, 'aria-label' => strip_tags((string)$this->label)];
if ($readonly) {
    $attributes['readonly'] = 'readonly';
}
?>
<?= TextInput::drawInputMain(
    className: 'form-input__text form-input__date',
    size: InputMainSize::Small,
    theme: InputMainTheme::from(Page::get()->getTheme()),
    id: 'field-' . $name . '-' . substr(md5((string)$this->table), 0, 6),
    attributes: $attributes,
    kind: $kind,
    value: $value,
) ?>
