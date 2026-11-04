<?php

/**
 * Верхняя панель планшета и телефона (компонент макета topbar-mobile): бургер (шторка меню), логотип, аватар
 * (профиль). На десктопе не выводится: крошки и «На сайт» — в page-head, выход — в профиле
 * @var \Simflex\Core\Admin\Page $page
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\Logo\Layout as Logo;
use Simflex\Core\Layout\Components\UI\Core\Logo\LogoTheme;
use Simflex\Core\Layout\Components\UI\Core\Logo\LogoType;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\AvatarSize;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\Layout as Placeholder;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\PlaceholderTheme;
use Simflex\Core\System\Container;

$theme = $page->getTheme();
$isDark = $theme === Page::THEME_DARK;
$user = Container::getUser();
$userName = (string)($user?->name ?: $user?->login);
?>
<header class="topbar topbar-theme_<?= $theme ?>">
    <?= Button::drawButton(
        className: 'topbar__burger',
        icon: 'menu',
        style: ButtonStyle::Secondary,
        size: ButtonSize::Small,
        theme: ButtonTheme::from($theme),
        attributes: [
            'aria-label' => 'Открыть меню',
            'aria-controls' => 'sf-menu',
            'aria-expanded' => 'false',
            'data-sf-menu-open' => '',
        ],
    ) ?>
    <?= Logo::drawLogo(
        className: 'topbar__logo',
        href: Page::url(''),
        name: 'Simflex CMS',
        label: 'Simflex CMS — главная админки',
        src: asset('img/brand/logo' . ($isDark ? '-dark' : '') . '.svg'),
        type: LogoType::Static,
        theme: $isDark ? LogoTheme::Dark : LogoTheme::Light,
    ) ?>
    <a class="topbar__account" href="<?= Page::url('account') ?>" aria-label="Профиль: <?= htmlspecialchars($userName) ?>">
        <?= Placeholder::drawAvatar($userName, size: AvatarSize::Small, theme: PlaceholderTheme::from($theme)) ?>
    </a>
</header>
