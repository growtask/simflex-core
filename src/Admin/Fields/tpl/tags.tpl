<?php

/**
 * Поле тегов формы (Inputs/tags, компонент TagsInput): FieldTags (свои значения и уже использованные в таблице),
 * FieldMultiKey (записи другой таблицы), FieldRelation (поиск записей раздела, действие searchTags)
 * @var \Simflex\Core\Admin\Fields\Field $this
 * @var string $name
 * @var array<int|string, string> $selected Значение => подпись
 * @var array<int|string, string> $options Подсказки: значение => подпись
 * @var string $searchUrl Поиск на сервере, пусто — по подсказкам
 * @var bool $allowNew Можно добавить свой текст
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\TagsInput\Layout as TagsInput;
use Simflex\Core\Layout\Components\UI\Core\TagsInput\TagsInputTheme;

?>
<?= TagsInput::drawTagsInput(
    name: $name,
    selected: $selected,
    options: $options,
    searchUrl: $searchUrl,
    allowNew: $allowNew,
    placeholder: $searchUrl !== '' ? 'Начните вводить название' : ($allowNew ? 'Введите тег' : 'Выберите'),
    label: strip_tags((string)$this->label),
    theme: TagsInputTheme::from(Page::get()->getTheme()),
    disabled: $this->readonly,
    className: 'form-input__tags',
) ?>
