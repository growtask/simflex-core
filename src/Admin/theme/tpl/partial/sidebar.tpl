<?php

/**
 * Боковое меню админки (компонент макета menu): логотип, сворачивание до 72 px (на планшете и телефоне — шторка
 * 320 px, кнопка закрытия), поиск по пунктам, группы с прокруткой, внизу menu-actions (поддержка, тема), аккаунт
 * и версия. По умолчанию свёрнуто (Page::isMenuCollapsed(), cookie), раскрытые группы — в localStorage
 * (theme/js/menu.js)
 * @var \Simflex\Core\Admin\Page $page
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\Layout as Tooltip;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainPosition;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainTheme;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\PlaceholderAvatarSize;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\Layout as Placeholder;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\PlaceholderAvatarTheme;
use Simflex\Core\System\Container;

$theme = $page->getTheme();
$isDark = $theme === Page::THEME_DARK;
$buttonTheme = ButtonMainTheme::from($theme);
$tooltipTheme = TooltipMainTheme::from($theme);
$user = Container::getUser();
$userName = (string)($user?->name ?: $user?->login);
$isCollapsed = $page->isMenuCollapsed();
$action = fn(string $icon, string $label, array $attributes) => Tooltip::drawTooltipMain(
    Button::drawButtonMain(
        className: 'menu-actions__button',
        icon: $icon,
        style: ButtonMainStyle::Secondary,
        size: ButtonMainSize::Small,
        theme: $buttonTheme,
        attributes: $attributes + ['aria-label' => $label],
    ),
    $label,
    position: TooltipMainPosition::Bottom,
    theme: $tooltipTheme,
    className: 'menu-actions__item',
);
?>
<aside class="menu menu-theme_<?= $theme ?><?= $isCollapsed ? ' menu_collapsed' : '' ?>" id="sf-menu" data-sf="menu"
       aria-label="Меню админки">
    <div class="menu__head">
        <?= $page->drawLogo('menu__logo', Page::url(''), isHomeLink: true) ?>
        <?= Button::drawButtonMain(
            className: 'menu__collapse',
            icon: 'chevron-m-left',
            style: ButtonMainStyle::Secondary,
            size: ButtonMainSize::Small,
            theme: $buttonTheme,
            attributes: [
                'aria-label' => $isCollapsed ? 'Развернуть меню' : 'Свернуть меню',
                'aria-expanded' => $isCollapsed ? 'false' : 'true',
                'data-sf-menu-collapse' => '',
            ],
        ) ?>
        <?= Button::drawButtonMain(
            className: 'menu__close',
            icon: 'close',
            style: ButtonMainStyle::Secondary,
            size: ButtonMainSize::Small,
            theme: $buttonTheme,
            attributes: ['aria-label' => 'Закрыть меню', 'data-sf-menu-close' => ''],
        ) ?>
    </div>
    <div class="menu__search">
        <?= TextInput::drawInputMain(
            placeholder: 'Поиск',
            size: InputMainSize::Small,
            theme: InputMainTheme::from($theme),
            icon: 'search',
            id: 'sf-menu-search',
            attributes: ['data-sf-menu-search' => '', 'autocomplete' => 'off', 'aria-label' => 'Поиск по меню'],
        ) ?>
    </div>
    <nav class="menu__scroll" aria-label="Разделы">
        <?= $page->getPosition('menu') ?>
    </nav>
    <div class="menu__bottom">
        <div class="menu-actions">
            <?= $action('phone', 'Поддержка', ['data-sf-support-open' => '']) ?>
            <?= $action(
                $isDark ? 'sun' : 'sun-moon',
                $isDark ? 'Светлая тема' : 'Тёмная тема',
                ['data-sf-theme-toggle' => $isDark ? Page::THEME_LIGHT : Page::THEME_DARK]
            ) ?>
        </div>
        <hr class="menu__divider">
        <a class="menu-account" href="<?= Page::url('account') ?>">
            <?= Placeholder::drawPlaceholderAvatar(
                $userName,
                size: PlaceholderAvatarSize::Medium,
                theme: PlaceholderAvatarTheme::from($theme),
                className: 'menu-account__avatar',
            ) ?>
            <span class="menu-account__text">
                <span class="menu-account__name"><?= htmlspecialchars($userName) ?></span>
                <span class="menu-account__hint">Профиль и выход</span>
            </span>
            <?= renderIcon('chevron-m-right', 'menu-account__chevron') ?>
        </a>
        <p class="menu__version">Simflex CMS v<?= htmlspecialchars(getSimflexVersion()) ?></p>
    </div>
</aside>
<div class="menu-overlay" data-sf-menu-close hidden></div>
