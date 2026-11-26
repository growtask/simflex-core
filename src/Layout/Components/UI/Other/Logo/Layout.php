<?php

namespace Simflex\Core\Layout\Components\UI\Other\Logo;

use Simflex\Core\Layout\LayoutBase;

/**
 * Знаки бренда: логотип (с анимацией при наведении или статичный), отметки «Создано» (студия) и «На базе» (движок)
 * (Figma: Parts/brand). Знаки берутся из public/assets/<тема>/images/brand (logo, made-in, made-by, на тёмной теме
 * варианты *-dark). Если задан $src, вместо знака по умолчанию выводится эта картинка.
 * Анимация logo-anim: по наведению знак сменяется подписью «Главная» (CSS, учитывает prefers-reduced-motion).
 */
class Layout extends LayoutBase
{
    /**
     * @param string $className Дополнительные CSS-классы
     * @param string $href Адрес ссылки (для логотипа — главная страница)
     * @param string $name Название бренда: слово рядом со знаком и доступное имя ссылки
     * @param string $label Доступное имя ссылки; если пусто, берётся $name
     * @param string $src Адрес картинки знака (SVG); если пуст, берётся знак бренда по умолчанию
     * @param bool $text Показывать подпись $caption рядом со знаком logo-anim (свойство text)
     * @param string $caption Подпись: у logo-anim текст после разделителя (например «Shop»), у made-in и made-by
     *                        надпись над знаком (по умолчанию «Создано» и «На базе»)
     * @param string $homeText Подпись, которая появляется у logo-anim при наведении
     * @param bool $external Внешняя ссылка (новая вкладка, rel="noopener"), для made-in и made-by
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты ссылки
     */
    public static function drawLogo(
        string    $className = '',
        string    $href = '/',
        string    $name = '',
        string    $label = '',
        string    $src = '',
        bool      $text = true,
        bool      $external = false,
        string    $caption = '',
        string    $homeText = 'Главная',
        LogoType  $type = LogoType::Animated,
        LogoTheme $theme = LogoTheme::Light,
        array     $attributes = []
    ): string {
        if ($caption === '' && $type !== LogoType::Animated && $type !== LogoType::Static) {
            $caption = $type === LogoType::MadeIn ? 'Создано' : 'На базе';
        }
        $dark = $theme === LogoTheme::Dark ? '-dark' : '';
        $images = [
            LogoType::Animated->value => 'logo',
            LogoType::Static->value => 'logo',
            LogoType::MadeIn->value => 'made-in',
            LogoType::MadeBy->value => 'made-by',
        ];
        $brandSrc = $src !== '' ? $src : asset('images/brand/' . $images[$type->value] . $dark . '.svg');

        return static::draw(
            compact(
                'className',
                'href',
                'name',
                'src',
                'caption',
                'homeText',
                'text',
                'external',
                'attributes'
            ) + [
                'brandSrc' => $brandSrc,
                'label' => $label !== '' ? $label : $name,
                'type' => $type->value,
                'theme' => $theme->value,
            ]
        );
    }
}
