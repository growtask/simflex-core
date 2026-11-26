<?php

namespace Simflex\Core\Layout\Components\Common\Header;

use Simflex\Core\Http\Menu as SiteMenu;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownTab\Layout as DropdownTab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabStyle;
use Simflex\Core\Layout\LayoutBase;
use Simflex\Core\System\Container;

/**
 * Шапка сайта (Figma: header_market без каталога, поиска, меню пользователя и выбора города).
 * Состав: строка над шапкой ($banner), top (логотип), bottom (слот $geo, пункты меню, соцсети, контакты, кнопка),
 * line. Закреплённая копия (header--fixed) появляется при прокрутке страницы без сдвига вёрстки. На tablet и mobile
 * вместо bottom — бургер и мобильное меню (Common/MobileMenu).
 *
 * Формат пунктов меню ($items): список ['text' => string, 'link' => string, 'active' => bool, 'children' => список
 * таких же пунктов без вложенных]. Получить из таблицы menu можно через getMenuItems().
 */
class Layout extends LayoutBase
{
    /**
     * @param string $className Дополнительные CSS-классы
     * @param string $banner Готовый HTML строки над шапкой (Common/HeaderBanner), пусто - строки нет
     * @param string $geo Слот под выбор города (пакет GeoIP): выводится в bottom слева от пунктов меню
     * @param array<int,array<string,mixed>> $items Пункты меню
     * @param string $logoName Название сайта: слово рядом со знаком и доступное имя логотипа
     * @param string $logoSrc Адрес картинки логотипа (SVG); пусто - знак-заглушка
     * @param string $logoHref Адрес главной страницы
     * @param string $phone Телефон (текст и значение для tel:); пусто - не выводится
     * @param string $email Почта; пусто - не выводится
     * @param array<string,string> $socials Соцсети: значение SocialNetwork (telegram, vkontakte, whatsapp...) => адрес
     * @param string $buttonText Текст кнопки; пусто - кнопки нет
     * @param string $buttonModal Значение data-modal кнопки: окно, которое она открывает
     * @param string $mobileMenuId Идентификатор мобильного меню (его выводит сама шапка)
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты элемента header
     */
    public static function drawHeader(
        string $className = '',
        string $banner = '',
        string $geo = '',
        array  $items = [],
        string $logoName = '',
        string $logoSrc = '',
        string $logoHref = '/',
        string $phone = '',
        string $email = '',
        array  $socials = [],
        string $buttonText = 'Связаться с нами',
        string $buttonModal = 'callback',
        string $mobileMenuId = 'mobile-menu',
        array  $attributes = []
    ): string {
        return static::draw(
            compact(
                'className',
                'banner',
                'geo',
                'items',
                'logoName',
                'logoSrc',
                'logoHref',
                'phone',
                'email',
                'socials',
                'buttonText',
                'buttonModal',
                'mobileMenuId',
                'attributes'
            )
        );
    }

    /**
     * Навигация шапки: Tab для простых пунктов и DropdownTab для пунктов с подпунктами
     *
     * @param array<int,array<string,mixed>> $items Пункты меню
     * @param string $idPrefix Префикс идентификаторов подменю (в закреплённой копии шапки другой)
     * @param string $className Дополнительные CSS-классы списка
     * @param string $label Доступное имя навигации
     */
    public static function drawNav(
        array  $items,
        string $idPrefix = 'nav',
        string $className = '',
        string $label = 'Основное меню'
    ): string {
        if ($items === []) {
            return '';
        }

        $html = '<nav class="main-nav ' . htmlspecialchars($className) . '" aria-label="' . htmlspecialchars($label) . '">'
            . '<ul class="main-nav__list">';
        foreach (array_values($items) as $i => $item) {
            $html .= '<li class="main-nav__item">';
            if (!empty($item['children'])) {
                $options = [];
                foreach ($item['children'] as $child) {
                    $options[] = [
                        'text' => htmlspecialchars((string)$child['text']),
                        'link' => (string)$child['link'],
                        'active' => !empty($child['active']),
                    ];
                }
                $html .= DropdownTab::drawDropdownTab(
                    text: htmlspecialchars((string)$item['text']),
                    link: (string)($item['link'] ?? ''),
                    style: \Simflex\Core\Layout\Components\UI\Dropdown\DropdownTab\DropdownTabStyle::Secondary,
                    size: \Simflex\Core\Layout\Components\UI\Dropdown\DropdownTab\DropdownTabSize::Small,
                    options: $options,
                    active: !empty($item['active']),
                    id: $idPrefix . '-' . $i
                );
            } else {
                $html .= Tab::drawTab(
                    text: htmlspecialchars((string)$item['text']),
                    link: (string)$item['link'],
                    style: TabStyle::Secondary,
                    size: TabSize::Small,
                    active: !empty($item['active'])
                );
            }
            $html .= '</li>';
        }

        return $html . '</ul></nav>';
    }

    /**
     * Пункты меню в формате шапки из дерева таблицы menu (Simflex\Core\Http\Menu::getTree()): скрытые пропускаются,
     * активным считается пункт текущей страницы или раздела (главная - только при пути «/»),
     * пункт с активным подпунктом тоже активен.
     *
     * @param array<int,array<int,array<string,mixed>>>|null $tree Дерево: id родителя => id пункта => пункт; null - меню сайта
     * @param int $pid Родитель, пункты которого выводятся
     * @param int $maxLevel Сколько уровней подпунктов выводить (0 - только первый уровень)
     * @param string|null $path Путь текущей страницы; null - из запроса
     * @return array<int,array<string,mixed>>
     */
    public static function getMenuItems(?array $tree = null, int $pid = 0, int $maxLevel = 1, ?string $path = null): array
    {
        $tree ??= SiteMenu::getTree();
        $path ??= Container::getRequest()->getPath();

        $items = [];
        foreach ($tree[$pid] ?? [] as $id => $row) {
            // колонки подвала (menu.place = footer) в шапку не попадают
            if (!empty($row['hidden']) || ($pid === 0 && ($row['place'] ?? 'main') !== 'main')) {
                continue;
            }
            $link = (string)$row['link'];
            $children = $maxLevel > 0 ? static::getMenuItems($tree, (int)$id, $maxLevel - 1, $path) : [];
            $active = ($link === '/' ? $path === '/' : ($link !== '' && ($path === $link || str_starts_with($path, rtrim($link, '/') . '/'))))
                || array_filter($children, fn(array $child) => $child['active']) !== [];
            $items[] = [
                'text' => (string)$row['name'],
                'link' => $link,
                'active' => $active,
                'children' => $children,
            ];
        }

        return $items;
    }
}
