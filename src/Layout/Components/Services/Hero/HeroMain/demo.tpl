<?php

/**
 * Демо HeroMain: картинка справа, слева, без картинки, фоном; галерея вместо картинки; вид телефона
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Services\Hero\HeroGallery\Layout as Gallery;
use Simflex\Core\Layout\Components\Services\Hero\HeroMain\HeroMainLayout;
use Simflex\Core\Layout\Components\Services\Hero\HeroMain\HeroMainTheme;
use Simflex\Core\Layout\Components\Services\Hero\HeroMain\Layout as Hero;

$heroTheme = HeroMainTheme::from($theme);
$hero = [
    'title' => 'Разработка сайтов',
    'description' => 'Делаем быстрые сайты, которые приводят клиентов',
    'badges' => ['Хит', 'Новое'],
    'benefits' => [
        ['title' => 'Под ключ', 'text' => 'От идеи до запуска', 'icon' => 'check'],
        ['title' => 'Быстро', 'text' => 'Первая версия за неделю', 'icon' => 'clock'],
        ['title' => 'Надёжно', 'text' => 'Гарантия на работу', 'icon' => 'star'],
    ],
    'price' => ['price' => '10 000 ₽', 'from' => 'от', 'unit' => '/ проект', 'time' => '10 часов'],
    'portfolioLink' => '#portfolio',
    'image' => '/assets/default/images/banner/main.webp',
    'theme' => $heroTheme,
];

?>
<?php foreach (HeroMainLayout::cases() as $layout): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $layout->name ?></h3>
    <div style="max-width:1264px"><?= Hero::drawHeroMain(...$hero, layout: $layout) ?></div>
<?php endforeach; ?>
<h3 class="ui-showcase__subtitle ui-m">Галерея вместо картинки</h3>
<div style="max-width:1264px">
    <?= Hero::drawHeroMain(...$hero, media: Gallery::drawHeroGallery([
        ['src' => '/assets/default/images/banner/main.webp'],
        ['src' => '/assets/default/images/banner/main-2.webp'],
        ['src' => '/assets/default/images/banner/main-3.webp'],
    ])) ?>
</div>
<h3 class="ui-showcase__subtitle ui-m">Вид телефона</h3>
<div style="max-width:382px"><?= Hero::drawHeroMain(...$hero, className: 'hero_view_mobile') ?></div>
