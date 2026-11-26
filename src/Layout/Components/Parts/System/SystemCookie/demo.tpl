<?php

/**
 * Демо Cookie: вид default и settings, позиция bottom и top (витрина Layout\LayoutShowcase).
 * Плашки выведены в потоке страницы (inline); размеры Figma задаёт ширина окна
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\System\SystemCookie\SystemCookiePosition;
use Simflex\Core\Layout\Components\Parts\System\SystemCookie\SystemCookieState;
use Simflex\Core\Layout\Components\Parts\System\SystemCookie\SystemCookieTheme;
use Simflex\Core\Layout\Components\Parts\System\SystemCookie\Layout as Cookie;

$cookieTheme = SystemCookieTheme::from($theme);

?>
<?php foreach (SystemCookieState::cases() as $state): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $state->name ?></h3>
    <div class="ui-showcase__row">
        <?= Cookie::drawSystemCookie(state: $state, theme: $cookieTheme, inline: true) ?>
    </div>
<?php endforeach; ?>

<?php foreach (SystemCookiePosition::cases() as $position): ?>
    <h3 class="ui-showcase__subtitle ui-m">Позиция <?= $position->name ?>, без ссылки на политику</h3>
    <div class="ui-showcase__row">
        <?= Cookie::drawSystemCookie(theme: $cookieTheme, position: $position, policyUrl: '', inline: true) ?>
    </div>
<?php endforeach; ?>
