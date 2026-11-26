<?php

/**
 * Верхняя панель планшета и телефона (компонент макета topbar-mobile): бургер (шторка меню), логотип, аватар
 * (профиль). На десктопе не выводится: крошки и «На сайт» — в page-head, выход — в профиле
 * @var \Simflex\Core\Admin\Page $page
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\PlaceholderAvatarSize;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\Layout as Placeholder;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\PlaceholderAvatarTheme;
use Simflex\Core\System\Container;

$theme = $page->getTheme();
$user = Container::getUser();
$userName = (string)($user?->name ?: $user?->login);
?>
<header class="topbar topbar-theme_<?= $theme ?>">
    <?= Button::drawButtonMain(
        className: 'topbar__burger',
        icon: 'menu',
        style: ButtonMainStyle::Secondary,
        size: ButtonMainSize::Small,
        theme: ButtonMainTheme::from($theme),
        attributes: [
            'aria-label' => 'Открыть меню',
            'aria-controls' => 'sf-menu',
            'aria-expanded' => 'false',
            'data-sf-menu-open' => '',
        ],
    ) ?>
    <?= $page->drawLogo('topbar__logo', Page::url(''), isHomeLink: true) ?>
    <?php if (($slotsHtml = $page->drawHeadSlots()) !== '') : ?>
        <div class="topbar__slots"><?= $slotsHtml ?></div>
    <?php endif ?>
    <a class="topbar__account" href="<?= Page::url('account') ?>" aria-label="Профиль: <?= htmlspecialchars($userName) ?>">
        <?= Placeholder::drawPlaceholderAvatar($userName, size: PlaceholderAvatarSize::Small, theme: PlaceholderAvatarTheme::from($theme)) ?>
    </a>
</header>
