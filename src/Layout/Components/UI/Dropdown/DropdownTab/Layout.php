<?php

namespace Simflex\Core\Layout\Components\UI\Dropdown\DropdownTab;

use Simflex\Core\Layout\LayoutBase;

/**
 * Вкладка с подменю (шаблон disclosure): триггер aria-expanded и aria-controls, меню — список ссылок.
 * Открывается по наведению, по клику (для button) и при фокусе с клавиатуры внутри, Esc закрывает.
 * Стили filled и soft — названия Figma для primary и secondary.
 * active отмечает текущий раздел (aria-current у ссылки), disabled — недоступный триггер.
 */
class Layout extends LayoutBase
{
    public static function drawDropdownTab(
        string               $className = '',
        string               $text = '',
        string               $link = '',
        string               $icon = '',
        string               $badge = '',
        DropdownTabMenuTheme $menuTheme = DropdownTabMenuTheme::Light,
        DropdownTabStyle     $style = DropdownTabStyle::Primary,
        DropdownTabSize      $size = DropdownTabSize::Medium,
        DropdownTabTheme     $theme = DropdownTabTheme::Light,
        array                $options = [],
        array                $attributes = [],
        bool                 $active = false,
        bool                 $disabled = false,
        string               $id = ''
    ): string {
        if ($id === '') {
            $id = 'dropdown-tab-' . substr(md5($text . json_encode($options)), 0, 8);
        }

        return static::draw(
            compact(
                'className',
                'text',
                'link',
                'icon',
                'badge',
                'options',
                'attributes',
                'active',
                'disabled',
                'id'
            ) + [
                'menuTheme' => $menuTheme->value,
                'style' => $style->value,
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }
}
