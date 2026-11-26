<?php

/**
 * Пароль (Inputs/password): значение не выводится, пустое поле — пароль не меняется; кнопка «Показать пароль»
 * @var string $name
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainKind;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;

?>
<?= TextInput::drawInputMain(
    className: 'form-input__text',
    placeholder: 'Оставьте пустым, если не требуется изменить',
    size: InputMainSize::Small,
    theme: InputMainTheme::from(Page::get()->getTheme()),
    id: 'field-' . $name,
    attributes: ['name' => $name, 'autocomplete' => 'new-password', 'aria-label' => strip_tags((string)$this->label)],
    kind: InputMainKind::Password,
) ?>
