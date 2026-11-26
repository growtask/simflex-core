<?php

namespace Simflex\Core\Layout\Components\UI\Dropdown\DropdownInput;

use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownSize;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownTheme;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\Layout as DropdownMain;
use Simflex\Core\Layout\LayoutBase;

/**
 * Поле, раскрывающее выпадающую панель (набор Figma Dropdown/input): выбор из списка вместо ввода текста.
 * Поле-селект DropdownMain::drawSelect(); разметка, стили и скрипт общие с DropdownMain
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
        DropdownSize    $size = DropdownSize::Medium,
        DropdownTheme   $theme = DropdownTheme::Light,
        bool            $search = false,
        bool            $disabled = false,
        string          $className = '',
        array           $attributes = [],
    ): string {
        return DropdownMain::drawSelect(
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
