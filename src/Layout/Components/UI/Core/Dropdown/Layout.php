<?php

namespace Simflex\Core\Layout\Components\UI\Core\Dropdown;

use Simflex\Core\Layout\LayoutBase;

/**
 * Выпадающий список (Figma Dropdown/main, Dropdown/input, design-ui-dropdown.md).
 *
 * drawSelect() — поле-селект: кнопка с выбранным значением и шевроном, панель вариантов (listbox) со
 * скрытым полем формы, поиск по вариантам. drawMenu() — меню действий под своей кнопкой (menu).
 * Панель на 8 px от кнопки, не уже её, открывается вверх, если снизу нет места; стрелки, Enter, Esc, ввод
 * буквы — переход к пункту, клик снаружи закрывает (script.js). Выбор в селекте — событие change на скрытом поле
 */
class Layout extends LayoutBase
{
    private static int $counter = 0;

    /**
     * @param string $name Имя поля формы
     * @param array<int|string, string> $options Значение => подпись (экранируется)
     * @param string|int|null $value Выбранное значение; null — ничего не выбрано (виден placeholder)
     * @param bool $search Поле поиска по вариантам над списком
     * @param array<string,string> $attributes Атрибуты кнопки-поля (aria-label, если нет подписи рядом)
     * @param string $searchUrl Поиск вариантов на сервере: GET <searchUrl>&text=<строка>, ответ JSON [{id, name}]
     *        заменяет список (поиск включается сам)
     * @param array<string,string> $inputAttributes Атрибуты скрытого поля (onchange, data-*): выбор — событие change
     */
    public static function drawSelect(
        string          $name,
        array           $options,
        string|int|null $value = null,
        string          $placeholder = 'Выберите',
        DropdownSize    $size = DropdownSize::Medium,
        DropdownTheme   $theme = DropdownTheme::Light,
        bool            $search = false,
        bool            $disabled = false,
        string          $id = '',
        string          $className = '',
        array           $attributes = [],
        string          $searchUrl = '',
        array           $inputAttributes = [],
    ): string {
        $id = $id !== '' ? $id : 'sf-dropdown-' . ++self::$counter;
        $search = $search || $searchUrl !== '';
        $value = $value === null ? null : (string)$value;
        $selectedLabel = $value !== null && array_key_exists($value, $options) ? $options[$value] : null;

        return static::draw(['view' => 'select'] + compact(
            'name',
            'options',
            'value',
            'selectedLabel',
            'placeholder',
            'search',
            'disabled',
            'id',
            'className',
            'attributes',
            'searchUrl',
            'inputAttributes'
        ) + ['size' => $size->value, 'theme' => $theme->value]);
    }

    /**
     * @param string $trigger HTML кнопки, открывающей меню (Button, ButtonIcon)
     * @param list<array{text: string, link?: string, icon?: string, attributes?: array<string,string>,
     *        disabled?: bool, active?: bool}> $items Пункты: ссылка или кнопка (обработчик — по attributes, например
     *        data-action); active — выбранный пункт (меню выбора: «где искать» и т. п.)
     * @param DropdownAlign $align Left — пункты по левому краю (длинные тексты), Center — по центру
     * @param string $side Край кнопки, по которому выровнена панель: left или right
     */
    public static function drawMenu(
        string           $trigger,
        array            $items,
        DropdownSize     $size = DropdownSize::Small,
        DropdownTheme    $theme = DropdownTheme::Light,
        DropdownAlign    $align = DropdownAlign::Left,
        DropdownPosition $position = DropdownPosition::Bottom,
        string           $side = 'right',
        string           $label = 'Действия',
        string           $className = '',
    ): string {
        $id = 'sf-dropdown-' . ++self::$counter;
        // кнопке — роль кнопки меню
        $trigger = (string)preg_replace(
            '/^(\s*<[a-z][a-z0-9-]*)/i',
            '$1 aria-haspopup="menu" aria-expanded="false" aria-controls="' . $id . '-panel" data-sf-dropdown-trigger',
            $trigger,
            1
        );

        return static::draw(['view' => 'menu'] + compact('trigger', 'items', 'label', 'id', 'side', 'className') + [
            'size' => $size->value,
            'theme' => $theme->value,
            'align' => $align->value,
            'position' => $position->value,
        ]);
    }
}
