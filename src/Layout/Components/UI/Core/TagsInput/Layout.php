<?php

namespace Simflex\Core\Layout\Components\UI\Core\TagsInput;

use Simflex\Core\Layout\Components\UI\Core\Tab\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabSize;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabStyle;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabTheme;
use Simflex\Core\Layout\Components\UI\Core\Tag\Layout as Tag;
use Simflex\Core\Layout\Components\UI\Core\Tag\TagSize;
use Simflex\Core\Layout\Components\UI\Core\Tag\TagStyle;
use Simflex\Core\Layout\Components\UI\Core\Tag\TagTheme;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputSize;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputStyle;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Поле тегов (Figma Inputs/tags, design-ui-inputs.md): поле с подсказками и ряд удаляемых тегов (Tag secondary s
 * с крестиком) под ним. Выбранные значения — в скрытом поле name через запятую (событие change). Подсказки —
 * варианты options или поиск на сервере: GET <searchUrl>&text=<строка>, ответ [{id, name}]; allowNew — Enter
 * добавляет введённый текст как значение. Клавиатура: стрелки по подсказкам, Enter — выбрать, Esc — закрыть
 * подсказки, Backspace в пустом поле — удалить последний тег (script.js)
 */
class Layout extends LayoutBase
{
    private static int $counter = 0;

    /**
     * @param array<int|string, string> $selected Выбранные: значение => подпись (подпись экранируется)
     * @param array<int|string, string> $options Подсказки: значение => подпись
     * @param string $label Доступное имя поля
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawTagsInput(
        string         $name,
        array          $selected = [],
        array          $options = [],
        string         $searchUrl = '',
        bool           $allowNew = false,
        string         $placeholder = 'Начните вводить',
        string         $label = '',
        TagsInputTheme $theme = TagsInputTheme::Light,
        bool           $disabled = false,
        string         $id = '',
        string         $className = '',
        array          $attributes = [],
    ): string {
        $id = $id !== '' ? $id : 'sf-tags-input-' . ++self::$counter;
        $tag = fn(string|int $value, string $text) => Tag::drawTag(
            className: 'tags-input__tag',
            text: htmlspecialchars($text),
            style: TagStyle::Secondary,
            size: TagSize::Small,
            theme: TagTheme::from($theme->value),
            attributes: ['data-value' => (string)$value],
            close: !$disabled,
            closeLabel: 'Удалить ' . $text,
        );
        $option = fn(string|int $value, string $text) => Tab::drawTab(
            className: 'tags-input__option',
            text: htmlspecialchars($text),
            style: TabStyle::Flat,
            size: TabSize::Small,
            theme: TabTheme::from($theme->value),
            attributes: ['role' => 'option', 'data-value' => (string)$value, 'tabindex' => '-1'],
        );
        $tags = '';
        foreach ($selected as $value => $text) {
            $tags .= $tag($value, (string)$text);
        }
        $optionsHtml = '';
        foreach ($options as $value => $text) {
            $optionsHtml .= $option($value, (string)$text);
        }
        $field = TextInput::drawInput(
            className: 'tags-input__field',
            placeholder: $placeholder,
            style: TextInputStyle::Filled,
            size: TextInputSize::Small,
            theme: TextInputTheme::from($theme->value),
            icon: $searchUrl !== '' ? 'search' : '',
            reset: false,
            id: $id . '-text',
            attributes: [
                'role' => 'combobox',
                'aria-autocomplete' => 'list',
                'aria-expanded' => 'false',
                'aria-controls' => $id . '-list',
                'aria-label' => $label !== '' ? $label : $placeholder,
                'autocomplete' => 'off',
                'data-sf-tags-text' => '',
            ] + ($disabled ? ['disabled' => 'disabled'] : []),
        );

        return static::draw(compact(
            'name',
            'id',
            'className',
            'attributes',
            'searchUrl',
            'allowNew',
            'field',
            'tags',
            'disabled'
        ) + [
            'value' => implode(',', array_keys($selected)),
            'options' => $optionsHtml,
            'tagTemplate' => $tag('', ''),
            'optionTemplate' => $option('', ''),
            'theme' => $theme->value,
        ]);
    }
}
