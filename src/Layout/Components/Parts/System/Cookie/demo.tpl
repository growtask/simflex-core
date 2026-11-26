<?php

/**
 * Демо Cookie: вид default и settings, позиция bottom и top (витрина Layout\LayoutShowcase).
 * Плашки выведены в потоке страницы (inline); размеры Figma задаёт ширина окна
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\System\Cookie\CookiePosition;
use Simflex\Core\Layout\Components\Parts\System\Cookie\CookieState;
use Simflex\Core\Layout\Components\Parts\System\Cookie\CookieTheme;
use Simflex\Core\Layout\Components\Parts\System\Cookie\Layout as Cookie;

$cookieTheme = CookieTheme::from($theme);

?>
<?php foreach (CookieState::cases() as $state): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $state->name ?></h3>
    <div class="ui-showcase__row">
        <?= Cookie::drawCookie(state: $state, theme: $cookieTheme, inline: true) ?>
    </div>
<?php endforeach; ?>

<?php foreach (CookiePosition::cases() as $position): ?>
    <h3 class="ui-showcase__subtitle ui-m">Позиция <?= $position->name ?>, без ссылки на политику</h3>
    <div class="ui-showcase__row">
        <?= Cookie::drawCookie(theme: $cookieTheme, position: $position, policyUrl: '', inline: true) ?>
    </div>
<?php endforeach; ?>
