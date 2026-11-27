<?php

namespace Simflex\Core\Layout\Components\Services\Hero\HeroMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Верх страницы услуги (Figma Services/Hero/main): бейджи, заголовок h1, описание, три преимущества ItemBenefit,
 * блок цены PriceMain и кнопка «Портфолио»; картинка или галерея HeroGallery справа (right), слева (left), фоном с
 * затемнением (cover — текст белый) или без неё (center). На планшете и телефоне — столбиком, картинка под текстом
 */
class Layout extends LayoutBase
{
    /**
     * @param string $title Название услуги (h1)
     * @param string $description Описание; пусто — без него
     * @param list<string> $badges Бейджи над заголовком (первый — primary-light, остальные — secondary)
     * @param list<array{title:string,text?:string,icon?:string}> $benefits Преимущества (до 3)
     * @param array<string,mixed> $price Параметры PriceMain::drawPriceMain() (price, from, time, orderText…); пусто — без цены
     * @param string $portfolioText Текст кнопки портфолио; пусто — без неё
     * @param string $portfolioLink Адрес портфолио
     * @param string $image Картинка (путь от корня сайта); пусто — без неё
     * @param string $imageAlt Описание картинки
     * @param string $media HTML вместо картинки (например, HeroGallery::drawHeroGallery())
     * @param string $className Дополнительные CSS-классы (hero_view_mobile — вид телефона для витрины)
     */
    public static function drawHeroMain(
        string         $title,
        string         $description = '',
        array          $badges = [],
        array          $benefits = [],
        array          $price = [],
        string         $portfolioText = 'Портфолио',
        string         $portfolioLink = '',
        string         $image = '',
        string         $imageAlt = '',
        string         $media = '',
        HeroMainLayout $layout = HeroMainLayout::Right,
        HeroMainTheme  $theme = HeroMainTheme::Light,
        string         $className = '',
    ): string {
        $benefits = array_slice(array_values(array_filter($benefits, static fn($b) => is_array($b) && ($b['title'] ?? '') !== '')), 0, 3);

        return static::draw(compact('title', 'description', 'badges', 'benefits', 'price', 'portfolioText', 'portfolioLink',
            'image', 'imageAlt', 'media', 'className') + [
            'layout' => $layout->value,
            'theme' => $theme->value,
        ]);
    }
}
