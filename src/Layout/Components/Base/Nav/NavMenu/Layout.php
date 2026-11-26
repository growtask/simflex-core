<?php

namespace Simflex\Core\Layout\Components\Base\Nav\NavMenu;

use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallNetwork;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactType;
use Simflex\Core\Layout\LayoutBase;

/**
 * Мобильное меню сайта (Figma nav/menu, design-base-nav.md): панель на весь экран из шапки — логотип и закрытие,
 * город, список пунктов (nav/menu-list), контакты, соцсети и кнопка. Панель — role="dialog"; открытие, ловушку
 * фокуса и блокировку прокрутки задаёт шапка (она в шаблоне), закрывает кнопка с data-sf-nav-menu-close
 */
class Layout extends LayoutBase
{
    /**
     * @param list<array<string, mixed>> $items Пункты для NavMenuList::drawNavMenuList()
     * @param string $location Город (вкладка с иконкой «marker»), пусто — без города
     * @param list<array{type: LinkContactType, value: string, text?: string}> $contacts Контакты
     * @param list<array{network: ButtonSocialSmallNetwork, href: string}> $socials Соцсети
     * @param string $buttonText Текст кнопки, пусто — без кнопки
     * @param string $buttonLink Адрес кнопки; пусто — кнопка без перехода (открывает форму через атрибуты $buttonAttributes)
     * @param array<string, mixed> $buttonAttributes Атрибуты кнопки
     * @param string $logoHref Адрес логотипа, пусто — без логотипа
     */
    public static function drawNavMenu(
        array        $items,
        string       $location = '',
        array        $contacts = [],
        array        $socials = [],
        string       $buttonText = '',
        string       $buttonLink = '',
        array        $buttonAttributes = [],
        string       $logoHref = '/',
        NavMenuTheme $theme = NavMenuTheme::Light,
        string       $label = 'Меню сайта',
        string       $closeLabel = 'Закрыть меню',
        string       $className = '',
    ): string {
        return static::draw(compact(
            'items',
            'location',
            'contacts',
            'socials',
            'buttonText',
            'buttonLink',
            'buttonAttributes',
            'logoHref',
            'label',
            'closeLabel',
            'className',
        ) + ['theme' => $theme->value]);
    }
}
