<?php

/**
 * Демо HeroGallery: четыре картинки, открыта первая и третья; вид телефона — свайп и индикатор
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Services\Hero\HeroGallery\HeroGalleryTheme;
use Simflex\Core\Layout\Components\Services\Hero\HeroGallery\Layout as Gallery;

$images = [
    ['src' => '/assets/default/images/banner/main.webp', 'alt' => 'Пример 1'],
    ['src' => '/assets/default/images/banner/main-2.webp', 'alt' => 'Пример 2'],
    ['src' => '/assets/default/images/banner/main-3.webp', 'alt' => 'Пример 3'],
    ['src' => '/assets/default/images/banner/form.webp', 'alt' => 'Пример 4'],
];
$galleryTheme = HeroGalleryTheme::from($theme);

?>
<div class="ui-showcase__row" style="align-items:flex-start">
    <div style="width:480px"><?= Gallery::drawHeroGallery($images, theme: $galleryTheme) ?></div>
    <div style="width:480px"><?= Gallery::drawHeroGallery($images, active: 3, theme: $galleryTheme) ?></div>
    <div style="width:342px"><?= Gallery::drawHeroGallery($images, theme: $galleryTheme, className: 'hero-gallery_view_mobile') ?></div>
</div>
