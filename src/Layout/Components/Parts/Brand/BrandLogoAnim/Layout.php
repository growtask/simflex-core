<?php

namespace Simflex\Core\Layout\Components\Parts\Brand\BrandLogoAnim;

use Simflex\Core\Layout\LayoutBase;

/**
 * Логотип с анимацией для шапки (Figma, блок Brand: logo-anim): по наведению знак сменяется подписью «Главная».
 * Всегда ссылка на главную страницу; поле вокруг логотипа не занимай
 */
class Layout extends LayoutBase
{
    /**
     * @param bool $text Показывать разделитель и подпись $caption справа (свойство text)
     * @param string $caption Подпись рядом со знаком, например «Shop»
     * @param string $homeText Подпись, которая появляется при наведении
     * @param string $href Адрес ссылки; по умолчанию главная страница
     * @param string $name Название бренда: подпись для скринридера и alt знака
     * @param string $label Доступное имя ссылки; пусто - $name
     * @param string $src Адрес картинки знака (SVG); пусто - знак по умолчанию из images/brand
     * @param array<string,mixed> $attributes Атрибуты ссылки
     */
    public static function drawBrandLogoAnim(
        LogoAnimTheme $theme = LogoAnimTheme::Light,
        bool          $text = true,
        string        $caption = '',
        string        $homeText = 'Главная',
        string        $href = '/',
        string        $name = '',
        string        $label = '',
        string        $src = '',
        string        $className = '',
        array         $attributes = []
    ): string {
        $dark = $theme === LogoAnimTheme::Dark ? '-dark' : '';
        $brandSrc = $src !== '' ? $src : asset('images/brand/logo' . $dark . '.svg');

        return static::draw([
            'theme' => $theme->value,
            'text' => $text,
            'caption' => $caption,
            'homeText' => $homeText,
            'href' => $href,
            'brandSrc' => $brandSrc,
            'label' => $label !== '' ? $label : $name,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }
}
