<?php

namespace Simflex\Core\Layout\Components\Parts\Brand\BrandMadeBy;

use Simflex\Core\Layout\LayoutBase;

/**
 * Отметка движка для подвала (Figma, блок Brand: made-by): подпись «Powered by» и знак Simflex.
 * Только в подвале; свойство dark (off, on) в Figma здесь theme. Ссылка открывается в новой вкладке
 */
class Layout extends LayoutBase
{
    /**
     * @param string $caption Подпись над знаком движка
     * @param string $href Адрес сайта движка
     * @param string $name Название бренда: подпись для скринридера и alt знака
     * @param string $label Доступное имя ссылки; пусто - $name
     * @param string $src Адрес картинки знака (SVG); пусто - знак по умолчанию из images/brand
     * @param array<string,mixed> $attributes Атрибуты ссылки
     */
    public static function drawBrandMadeBy(
        BrandMadeByTheme $theme = BrandMadeByTheme::Light,
        string      $caption = 'Powered by',
        string      $href = '',
        string      $name = '',
        string      $label = '',
        string      $src = '',
        string      $className = '',
        array       $attributes = []
    ): string {
        $dark = $theme === BrandMadeByTheme::Dark ? '-dark' : '';
        $brandSrc = $src !== '' ? $src : asset('images/brand/made-by' . $dark . '.svg');

        return static::draw([
            'theme' => $theme->value,
            'caption' => $caption,
            'href' => $href,
            'brandSrc' => $brandSrc,
            'label' => $label !== '' ? $label : $name,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }
}
