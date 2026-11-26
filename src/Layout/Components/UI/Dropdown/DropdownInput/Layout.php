<?php

namespace Simflex\Core\Layout\Components\UI\Dropdown\DropdownInput;

use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainSize;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainTheme;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\Layout as DropdownMain;
use Simflex\Core\Layout\LayoutBase;

/**
 * Поле, раскрывающее выпадающую панель (набор Figma Dropdown/input): выбор из списка вместо ввода текста.
 * Поле-селект DropdownMain::drawDropdownMainSelect(); разметка, стили и скрипт общие с DropdownMain
 */
class Layout extends LayoutBase
{
    /**
     * @param array<int|string, string> $options Значение => подпись
     * @param string|int|null $value Выбранное значение; null — виден placeholder
     */
    public static function drawDropdownInput(
        string          $name,
        array           $options,
        string|int|null $value = null,
        string          $placeholder = 'Выберите',
        DropdownMainSize    $size = DropdownMainSize::Medium,
        DropdownMainTheme   $theme = DropdownMainTheme::Light,
        bool            $search = false,
        bool            $disabled = false,
        string          $className = '',
        array           $attributes = [],
    ): string {
        return DropdownMain::drawDropdownMainSelect(
            name: $name,
            options: $options,
            value: $value,
            placeholder: $placeholder,
            size: $size,
            theme: $theme,
            search: $search,
            disabled: $disabled,
            className: $className,
            attributes: $attributes,
        );
    }
}
