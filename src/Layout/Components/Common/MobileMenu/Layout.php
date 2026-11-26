<?php

namespace Simflex\Core\Layout\Components\Common\MobileMenu;

use Simflex\Core\Layout\LayoutBase;

/**
 * Мобильное меню на весь экран (Figma: nav/menu и nav/menu-list): логотип и закрытие, пункты меню с подменю,
 * контакты, соцсети, кнопка. role="dialog" и aria-modal, ловушка фокуса, закрытие по Esc и кнопке, блокировка
 * прокрутки страницы, возврат фокуса на кнопку открытия. Открывается кнопкой с атрибутом data-mobile-menu-open="{id}"
 * (её выводит Header). Выводится один раз на страницу.
 *
 * Формат пунктов ($items) тот же, что у Common/Header: ['text', 'link', 'active', 'children' => [...]].
 */
class Layout extends LayoutBase
{
    /**
     * @param string $id Идентификатор окна (значение data-mobile-menu-open у кнопки открытия)
     * @param array<int,array<string,mixed>> $items Пункты меню
     * @param string $logoName Название сайта
     * @param string $logoSrc Адрес картинки логотипа
     * @param string $logoHref Адрес главной страницы
     * @param string $phone Телефон
     * @param string $email Почта
     * @param array<string,string> $socials Соцсети: значение ButtonSocialSmallNetwork => адрес
     * @param string $buttonText Текст кнопки; пусто - кнопки нет
     * @param string $buttonModal Значение data-modal кнопки
     * @param string $geo Слот под выбор города (пакет GeoIP): выводится над пунктами меню
     * @param string $label Доступное имя окна
     * @param string $closeLabel Доступное имя кнопки закрытия
     * @param string $className Дополнительные CSS-классы
     */
    public static function drawMobileMenu(
        string $id = 'mobile-menu',
        array  $items = [],
        string $logoName = '',
        string $logoSrc = '',
        string $logoHref = '/',
        string $phone = '',
        string $email = '',
        array  $socials = [],
        string $buttonText = 'Связаться с нами',
        string $buttonModal = 'callback',
        string $geo = '',
        string $label = 'Меню',
        string $closeLabel = 'Закрыть меню',
        string $className = ''
    ): string {
        return static::draw(
            compact(
                'id',
                'items',
                'logoName',
                'logoSrc',
                'logoHref',
                'phone',
                'email',
                'socials',
                'buttonText',
                'buttonModal',
                'geo',
                'label',
                'closeLabel',
                'className'
            )
        );
    }

    /**
     * Пункты для списка меню: у пункта с подпунктами и ссылкой сам раздел становится первой ссылкой подменю
     * (кнопка-заголовок только раскрывает список)
     *
     * @param array<int,array<string,mixed>> $items Пункты меню
     * @return array<int,array<string,mixed>>
     */
    public static function getListItems(array $items): array
    {
        $result = [];
        foreach ($items as $item) {
            $children = $item['children'] ?? [];
            if ($children !== [] && (string)($item['link'] ?? '') !== '') {
                array_unshift($children, [
                    'text' => $item['text'],
                    'link' => $item['link'],
                    'active' => !empty($item['active']) && !array_filter($children, fn($c) => !empty($c['active'])),
                ]);
            }
            $item['children'] = $children;
            $result[] = $item;
        }

        return $result;
    }
}
