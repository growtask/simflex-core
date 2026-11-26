<?php

namespace Simflex\Core\Layout\Components\Parts\Brand\BrandLogo;

use Simflex\Core\Layout\LayoutBase;

/**
 * Статичный логотип (Figma, блок Brand: logo): знак бренда для подвала, документов и мест без анимации.
 * На тёмной теме берётся знак logo-dark.svg; знак не перекрашивай и не растягивай
 */
class Layout extends LayoutBase
{
    /**
     * @param string $href Адрес ссылки; по умолчанию главная страница
     * @param string $name Название бренда: подпись для скринридера и alt знака
     * @param string $label Доступное имя ссылки; пусто - $name
     * @param string $src Адрес картинки знака (SVG); пусто - знак по умолчанию из images/brand
     * @param array<string,mixed> $attributes Атрибуты ссылки
     */
    public static function drawBrandLogo(
        LogoTheme $theme = LogoTheme::Light,
        string    $href = '/',
        string    $name = '',
        string    $label = '',
        string    $src = '',
        string    $className = '',
        array     $attributes = []
    ): string {
        $dark = $theme === LogoTheme::Dark ? '-dark' : '';
        $brandSrc = $src !== '' ? $src : asset('images/brand/logo' . $dark . '.svg');

        return static::draw([
            'theme' => $theme->value,
            'href' => $href,
            'brandSrc' => $brandSrc,
            'label' => $label !== '' ? $label : $name,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }
}
