<?php

namespace Simflex\Core\Layout\Components\Services\Hero\HeroGallery;

use Simflex\Core\Layout\Components\Base\Slider\SliderMain\Layout as SliderMain;
use Simflex\Core\Layout\LayoutBase;

/**
 * Галерея картинок страницы услуги (Figma Services/Hero/gallery): большая картинка и до четырёх миниатюр — нажатие на
 * миниатюру открывает картинку; на телефоне миниатюр нет, картинки листаются свайпом, под ними индикатор SliderStepItem.
 * Листание — swiper (script.js). Подставляется в HeroMain (media) или выводится отдельно
 */
class Layout extends LayoutBase
{
    public static function initAssets(): void
    {
        SliderMain::useSwiper();
        parent::initAssets();
    }

    /**
     * @param list<array{src:string,alt?:string}> $images Картинки (до 4)
     * @param int $active Номер открытой картинки, с 1 (Figma active)
     * @param string $label Доступное имя галереи
     * @param string $className Дополнительные CSS-классы (hero-gallery_view_mobile — вид телефона для витрины)
     */
    public static function drawHeroGallery(
        array            $images,
        int              $active = 1,
        HeroGalleryTheme $theme = HeroGalleryTheme::Light,
        string           $label = 'Галерея',
        string           $className = '',
    ): string {
        $images = array_slice(array_values(array_filter($images, static fn($i) => is_array($i) && ($i['src'] ?? '') !== '')), 0, 4);

        return static::draw([
            'images' => $images,
            'active' => max(0, min(count($images) - 1, $active - 1)),
            'theme' => $theme->value,
            'label' => $label,
            'className' => $className,
        ]);
    }
}
