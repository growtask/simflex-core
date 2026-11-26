<?php

namespace Simflex\Core\Layout\Components\UI\Tab\TabMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Вкладка (набор Figma Tabs/main). Стили filled и soft — названия Figma для primary и secondary.
 * active отмечает текущую: у ссылки aria-current="page", у кнопки с role="tab" aria-selected.
 * disabled: у button атрибут disabled, у ссылки aria-disabled без href и вне порядка фокуса.
 */
class Layout extends LayoutBase
{
    public static function drawTabMain(
        string     $className = '',
        string     $text = '',
        string     $link = '',
        string     $iconLeft = '',
        string     $iconRight = '',
        string     $badge = '',
        TabMainStyle   $style = TabMainStyle::Primary,
        TabMainSize    $size = TabMainSize::Medium,
        TabMainTheme   $theme = TabMainTheme::Light,
        array      $attributes = [],
        bool       $active = false,
        bool       $disabled = false
    ): string {
        return static::draw(
            compact(
                'className',
                'text',
                'link',
                'iconLeft',
                'iconRight',
                'badge',
                'active',
                'disabled',
                'attributes'
            ) + [
                'style' => $style->value,
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }
}
