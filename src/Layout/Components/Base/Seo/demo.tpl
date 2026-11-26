<?php

/**
 * Демо Seo: колонки 1–3, свёрнутый и раскрытый текст, без ссылки, с облаком запросов (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Seo\Layout as Seo;
use Simflex\Core\Layout\Components\Base\Seo\SeoState;
use Simflex\Core\Layout\Components\Base\Seo\SeoTheme;

$theme = SeoTheme::from($theme);
$text = '<p>Мебель для дома и офиса с доставкой по всей России: диваны, кровати, шкафы и столы из массива и плиты. '
    . 'Мы работаем напрямую с фабриками, поэтому цены ниже рыночных, а срок изготовления не превышает двух недель.</p>'
    . '<p>В каталоге есть <a href="#sofas">диваны</a> любых размеров, ткани и механизмы трансформации. '
    . 'Консультанты помогут выбрать модель под комнату и бюджет, а сборщики установят её в удобное время.</p>';
$columns = [
    ['title' => 'Купить мебель в интернет-магазине', 'text' => $text],
    ['title' => 'Доставка и сборка', 'text' => $text],
    ['title' => 'Гарантия и возврат', 'text' => $text],
];
$tags = [
    ['name' => 'Диваны', 'link' => '#sofas'],
    ['name' => 'Угловые диваны', 'link' => '#corner'],
    ['name' => 'Кровати', 'link' => '#beds'],
    ['name' => 'Шкафы-купе', 'link' => '#wardrobes'],
    ['name' => 'Письменные столы', 'link' => '#desks'],
];

?>
<?php foreach (SeoState::cases() as $state): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $state->name ?></h3>
    <?php foreach ([1, 2, 3] as $count): ?>
        <div class="ui-showcase__row" style="display: block;">
            <?= Seo::drawSeo(array_slice($columns, 0, $count), state: $state, theme: $theme) ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Без ссылки «Читать далее», с облаком запросов</h3>
<div class="ui-showcase__row" style="display: block;">
    <?= Seo::drawSeo(array_slice($columns, 0, 2), tags: $tags, more: false, theme: $theme) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Свёрнуто, с облаком запросов</h3>
<div class="ui-showcase__row" style="display: block;">
    <?= Seo::drawSeo(array_slice($columns, 0, 2), tags: $tags, theme: $theme) ?>
</div>
