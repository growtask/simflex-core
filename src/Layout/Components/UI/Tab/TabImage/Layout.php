<?php

namespace Simflex\Core\Layout\Components\UI\Tab\TabImage;

use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Таб с картинкой и описанием (Figma Tabs/image): картинка (или иконка) слева, заголовок и описание, бейдж
 * и иконка справа. Для наглядного выбора: категория, цвет, тип товара. Состояния active и disabled — как у TabMarker
 */
class Layout extends LayoutBase
{
    /**
     * @param string $text Заголовок (HTML вставляется как есть: экранируй сам)
     * @param string $description Описание под заголовком (HTML вставляется как есть)
     * @param string $link Ссылка; пусто — кнопка
     * @param string $image Адрес картинки; пусто — заглушка (с иконкой $icon, если задана)
     * @param string $imageAlt Альтернативный текст картинки (по умолчанию пустой: рядом есть заголовок)
     * @param string $icon Иконка в заглушке вместо картинки
     * @param string $badge Текст красного бейджа справа
     * @param string $iconRight Иконка справа (шеврон и т. п.)
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawTabImage(
        string        $text = '',
        string        $description = '',
        string        $link = '',
        string        $image = '',
        string        $imageAlt = '',
        string        $icon = '',
        string        $badge = '',
        string        $iconRight = '',
        TabImageStyle $style = TabImageStyle::Primary,
        TabImageSize  $size = TabImageSize::Medium,
        TabMainTheme      $theme = TabMainTheme::Light,
        array         $attributes = [],
        bool          $active = false,
        bool          $disabled = false,
        string        $className = '',
    ): string {
        return static::draw(compact(
            'text',
            'description',
            'link',
            'image',
            'imageAlt',
            'icon',
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
