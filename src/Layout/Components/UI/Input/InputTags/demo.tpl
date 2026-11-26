<?php

/**
 * Демо TagsInput: пустое поле, с выбранными тегами, с подсказками, с созданием новых, отключённое
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Input\InputTags\Layout as TagsInput;
use Simflex\Core\Layout\Components\UI\Input\InputTags\InputTagsTheme;

$tagsTheme = InputTagsTheme::from($theme);
$options = ['red' => 'Красный', 'green' => 'Зелёный', 'blue' => 'Синий', 'yellow' => 'Жёлтый'];

?>
<div class="ui-showcase__row ui-showcase__row_dropdowns">
    <span class="ui-showcase__field">
        <?= TagsInput::drawInputTags(
            name: 'ui_tags_empty_' . $theme,
            options: $options,
            label: 'Пустое',
            theme: $tagsTheme,
            id: 'ui-tags-empty-' . $theme,
        ) ?>
    </span>
    <span class="ui-showcase__field">
        <?= TagsInput::drawInputTags(
            name: 'ui_tags_selected_' . $theme,
            selected: ['red' => 'Красный', 'blue' => 'Синий'],
            options: $options,
            label: 'С выбранными',
            theme: $tagsTheme,
            id: 'ui-tags-selected-' . $theme,
        ) ?>
    </span>
    <span class="ui-showcase__field">
        <?= TagsInput::drawInputTags(
            name: 'ui_tags_new_' . $theme,
            selected: ['green' => 'Зелёный'],
            options: $options,
            allowNew: true,
            placeholder: 'Введите и нажмите Enter',
            label: 'С созданием новых',
            theme: $tagsTheme,
            id: 'ui-tags-new-' . $theme,
        ) ?>
    </span>
    <span class="ui-showcase__field">
        <?= TagsInput::drawInputTags(
            name: 'ui_tags_disabled_' . $theme,
            selected: ['red' => 'Красный'],
            label: 'Отключённое',
            theme: $tagsTheme,
            disabled: true,
            id: 'ui-tags-disabled-' . $theme,
        ) ?>
    </span>
</div>
