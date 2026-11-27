<?php

/**
 * Демо CardMain: карточка и строка списка, полная и минимальная, недоступная, вид телефона; образец фокуса
 * (Cards/focus) — Tab по карточкам (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Services\Card\CardMain\CardMainLayout;
use Simflex\Core\Layout\Components\Services\Card\CardMain\CardMainTheme;
use Simflex\Core\Layout\Components\Services\Card\CardMain\Layout as Card;

$cardTheme = CardMainTheme::from($theme);
$full = [
    'title' => 'Разработка сайта',
    'link' => '#service',
    'description' => 'Сайт на Simflex CMS под ключ',
    'image' => '/assets/default/images/banner/main.webp',
    'label' => 'Хит',
    'price' => '10 000 ₽',
    'oldPrice' => '12 000 ₽',
    'time' => '10 часов',
];

?>
<?php foreach (CardMainLayout::cases() as $layout): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $layout->name ?>: наведение — заголовок и стрелка, нажатие — фон; Tab — кольцо вокруг карточки</h3>
    <div class="ui-showcase__row" style="align-items:flex-start;flex-wrap:wrap">
        <div style="width:<?= $layout === CardMainLayout::Card ? 460 : 720 ?>px"><?= Card::drawCardMain(...$full, layout: $layout, theme: $cardTheme) ?></div>
        <div style="width:<?= $layout === CardMainLayout::Card ? 460 : 720 ?>px"><?= Card::drawCardMain(title: 'Консультация', link: '#consult', price: '3 000 ₽', layout: $layout, theme: $cardTheme) ?></div>
        <div style="width:<?= $layout === CardMainLayout::Card ? 460 : 720 ?>px"><?= Card::drawCardMain(...$full, disabled: true, layout: $layout, theme: $cardTheme) ?></div>
        <div style="width:382px"><?= Card::drawCardMain(...$full, layout: $layout, theme: $cardTheme, className: 'service-card_view_mobile') ?></div>
    </div>
<?php endforeach; ?>
