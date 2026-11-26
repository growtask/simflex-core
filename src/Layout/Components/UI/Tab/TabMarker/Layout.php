<?php

namespace Simflex\Core\Layout\Components\UI\Tab\TabMarker;

use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Таб с описанием и слотом (Figma Tabs/marker): слот слева (иконка в плитке или свой HTML), заголовок
 * и описание, бейдж и иконка справа. Для выбора из нескольких содержательных вариантов (тариф, способ доставки);
 * короткие названия — Tab. active отмечает текущий: у ссылки aria-current="page", у кнопки с role="tab"
 * aria-selected. disabled: у button атрибут disabled, у ссылки aria-disabled без href
 */
class Layout extends LayoutBase
{
    /**
     * @param string $text Заголовок (HTML вставляется как есть: экранируй сам)
     * @param string $description Описание под заголовком (HTML вставляется как есть)
     * @param string $link Ссылка; пусто — кнопка
     * @param string $icon Иконка в плитке слота; пусто и без $slot — слота нет
     * @param string $slot Свой HTML слота (вместо иконки в плитке)
     * @param string $badge Текст красного бейджа справа
     * @param string $iconRight Иконка справа (шеврон и т. п.)
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawTabMarker(
        string         $text = '',
        string         $description = '',
        string         $link = '',
        string         $icon = '',
        string         $slot = '',
        string         $badge = '',
        string         $iconRight = '',
        TabMarkerStyle $style = TabMarkerStyle::Filled,
        TabMarkerSize  $size = TabMarkerSize::Medium,
        TabMainTheme       $theme = TabMainTheme::Light,
        array          $attributes = [],
        bool           $active = false,
        bool           $disabled = false,
        string         $className = '',
    ): string {
        return static::draw(compact(
            'text',
            'description',
            'link',
            'icon',
            'slot',
            'badge',
            'iconRight',
            'attributes',
            'active',
            'disabled',
            'className'
        ) + [
            'style' => $style->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}
