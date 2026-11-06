<?php

/**
 * Боковое меню админки (компонент макета menu): логотип, сворачивание до 72 px (на планшете и телефоне — шторка
 * 320 px, кнопка закрытия), поиск по пунктам, группы с прокруткой, внизу menu-actions (поддержка, тема), аккаунт
 * и версия. По умолчанию свёрнуто (Page::isMenuCollapsed(), cookie), раскрытые группы — в localStorage
 * (theme/js/menu.js)
 * @var \Simflex\Core\Admin\Page $page
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputSize;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;
use Simflex\Core\Layout\Components\UI\Core\Tooltip\Layout as Tooltip;
use Simflex\Core\Layout\Components\UI\Core\Tooltip\TooltipPosition;
use Simflex\Core\Layout\Components\UI\Core\Tooltip\TooltipTheme;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\AvatarSize;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\Layout as Placeholder;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\PlaceholderTheme;
use Simflex\Core\System\Container;

$theme = $page->getTheme();
$isDark = $theme === Page::THEME_DARK;
$buttonTheme = ButtonTheme::from($theme);
$tooltipTheme = TooltipTheme::from($theme);
$user = Container::getUser();
$userName = (string)($user?->name ?: $user?->login);
$isCollapsed = $page->isMenuCollapsed();
$action = fn(string $icon, string $label, array $attributes) => Tooltip::drawTooltip(
    Button::drawButton(
        className: 'menu-actions__button',
        icon: $icon,
        style: ButtonStyle::Secondary,
        size: ButtonSize::Small,
        theme: $buttonTheme,
        attributes: $attributes + ['aria-label' => $label],
    ),
    $label,
    position: TooltipPosition::Bottom,
    theme: $tooltipTheme,
    className: 'menu-actions__item',
);
?>
<aside class="menu menu-theme_<?= $theme ?><?= $isCollapsed ? ' menu_collapsed' : '' ?>" id="sf-menu" data-sf="menu"
       aria-label="Меню админки">
    <div class="menu__head">
        <?= $page->drawLogo('menu__logo', Page::url(''), isHomeLink: true) ?>
        <?= Button::drawButton(
            className: 'menu__collapse',
            icon: 'chevron-m-left',
            style: ButtonStyle::Secondary,
            size: ButtonSize::Small,
            theme: $buttonTheme,
            attributes: [
                'aria-label' => $isCollapsed ? 'Развернуть меню' : 'Свернуть меню',
                'aria-expanded' => $isCollapsed ? 'false' : 'true',
                'data-sf-menu-collapse' => '',
            ],
        ) ?>
        <?= Button::drawButton(
            className: 'menu__close',
            icon: 'close',
            style: ButtonStyle::Secondary,
            size: ButtonSize::Small,
            theme: $buttonTheme,
            attributes: ['aria-label' => 'Закрыть меню', 'data-sf-menu-close' => ''],
        ) ?>
    </div>
    <div class="menu__search">
        <?= TextInput::drawInput(
            placeholder: 'Поиск',
            size: TextInputSize::Small,
            theme: TextInputTheme::from($theme),
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
            <?= Placeholder::drawAvatar(
                $userName,
                size: AvatarSize::Medium,
                theme: PlaceholderTheme::from($theme),
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
