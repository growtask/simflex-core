<?php

namespace Simflex\Core\Layout\Components\Parts\Brand\BrandMadeIn;

use Simflex\Core\Layout\LayoutBase;

/**
 * Отметка студии-разработчика для подвала (Figma, блок Brand: made-in): флаг, подпись «Сайт сделан в студии»
 * и знак студии. Только в подвале, мелко; ссылка на сайт студии открывается в новой вкладке
 */
class Layout extends LayoutBase
{
    /**
     * @param bool $flag Флаг рядом с подписью (свойство flag)
     * @param string $caption Подпись над знаком студии
     * @param string $href Адрес сайта студии
     * @param string $name Название бренда: подпись для скринридера и alt знака
     * @param string $label Доступное имя ссылки; пусто - $name
     * @param string $src Адрес картинки знака (SVG); пусто - знак по умолчанию из images/brand
     * @param array<string,mixed> $attributes Атрибуты ссылки
     */
    public static function drawBrandMadeIn(
        BrandMadeInTheme $theme = BrandMadeInTheme::Light,
        bool        $flag = true,
        string      $caption = 'Сайт сделан в студии',
        string      $href = '',
        string      $name = '',
        string      $label = '',
        string      $src = '',
        string      $className = '',
        array       $attributes = []
    ): string {
        $dark = $theme === BrandMadeInTheme::Dark ? '-dark' : '';
        $brandSrc = $src !== '' ? $src : asset('images/brand/made-in' . $dark . '.svg');

        return static::draw([
            'theme' => $theme->value,
            'flag' => $flag,
            'caption' => $caption,
            'href' => $href,
            'brandSrc' => $brandSrc,
            'label' => $label !== '' ? $label : $name,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }
}
