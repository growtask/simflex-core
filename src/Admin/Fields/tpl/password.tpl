<?php

/**
 * Пароль (Inputs/password): значение не выводится, пустое поле — пароль не меняется; кнопка «Показать пароль»
 * @var string $name
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputKind;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputTheme;

?>
<?= TextInput::drawInput(
    className: 'form-input__text',
    placeholder: 'Оставьте пустым, если не требуется изменить',
    size: TextInputSize::Small,
    theme: TextInputTheme::from(Page::get()->getTheme()),
    id: 'field-' . $name,
    attributes: ['name' => $name, 'autocomplete' => 'new-password', 'aria-label' => strip_tags((string)$this->label)],
    kind: TextInputKind::Password,
) ?>
