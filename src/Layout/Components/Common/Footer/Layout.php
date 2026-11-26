<?php

namespace Simflex\Core\Layout\Components\Common\Footer;

use Simflex\Core\Http\Menu as SiteMenu;
use Simflex\Core\Layout\LayoutBase;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallNetwork;
use Simflex\Core\Models\Menu as MenuModel;
use Simflex\Core\System\Container;
use Simflex\Core\System\Settings;

/**
 * Подвал сайта (Figma: footer_market без каталога, магазина и иконок оплаты): логотип, кнопка «Связаться с нами»
 * (открывает окно по data-modal), телефон, почта, соцсети, колонки меню, вертикальная линия, нижняя строка
 * («© Компания год», отметки made-in и made-by).
 *
 * Значения, которые не переданы (null), берутся из настроек сайта: phone, email, company, site_name, vk, tg, whats_app.
 * Колонки меню по умолчанию - из таблицы menu: корневые пункты с place = footer - заголовки колонок, их вложенные
 * пункты - ссылки. Нижний отступ подвала задаёт css-переменная --footer-indent-bottom (на tablet и mobile в макете
 * 150 - место под нижнюю панель расширений каталога и магазина), см. public/assets/<тема>/css/site.css.
 * На tablet и mobile колонки меню и вертикальная линия скрыты, как в макете.
 */
class Layout extends LayoutBase
{
    /** Соответствие настроек сайта и соцсетей подвала */
    protected const SOCIAL_SETTINGS = [
        'vk' => ButtonSocialSmallNetwork::Vkontakte,
        'tg' => ButtonSocialSmallNetwork::Telegram,
        'whats_app' => ButtonSocialSmallNetwork::Whatsapp,
    ];

    /**
     * @param string $className Дополнительные CSS-классы
     * @param array<int, array{title: string, links: array<int, array{text: string, href: string, active?: bool}>}>|null $columns
     *        Колонки меню; null - из таблицы menu (см. getMenuColumns())
     * @param string|null $phone Телефон; null - настройка phone, пустой - не выводится
     * @param string|null $email Почта; null - настройка email, пустая - не выводится
     * @param array<string, string>|null $socials Соцсети: значение ButtonSocialSmallNetwork => адрес; null - настройки vk, tg,
     *        whats_app (пустые не выводятся)
     * @param string|null $company Название компании для строки «©»; null - настройка company, иначе site_name
     * @param string|null $logoName Слово рядом со знаком логотипа; null - настройка site_name
     * @param string $logoSrc Адрес картинки логотипа (SVG); пусто - знак-заглушка
     * @param string $callbackText Текст кнопки
     * @param string $modal Значение data-modal кнопки: какое окно открыть (пусто - кнопка без окна)
     * @param int|null $year Год в строке «©»; null - текущий
     * @param string $madeInHref Адрес студии-разработчика (made-in)
     * @param string $madeInName Название студии
     * @param string $madeByHref Адрес движка (made-by)
     * @param string $madeByName Название движка
     * @param string|null $currentPath Путь текущей страницы для отметки активной ссылки; null - из запроса
     */
    public static function drawFooter(
        string  $className = '',
        ?array  $columns = null,
        ?string $phone = null,
        ?string $email = null,
        ?array  $socials = null,
        ?string $company = null,
        ?string $logoName = null,
        string  $logoSrc = '',
        string  $callbackText = 'Связаться с нами',
        string  $modal = 'callback',
        ?int    $year = null,
        string  $madeInHref = 'https://growtask.ru',
        string  $madeInName = 'Гротеск',
        string  $madeByHref = 'https://simflexcms.ru',
        string  $madeByName = 'Симфлекс',
        ?string $currentPath = null
    ): string {
        // Настройки читаются только для значений, которые не переданы
        $setting = fn(string $alias): string => (string)Settings::get($alias, '');
        $columns ??= static::getMenuColumns($currentPath);
        $socials ??= static::getSocials();

        return static::draw(
            compact(
                'className',
                'columns',
                'logoSrc',
                'callbackText',
                'modal',
                'madeInHref',
                'madeInName',
                'madeByHref',
                'madeByName'
            ) + [
                'phone' => $phone ?? $setting('phone'),
                'email' => $email ?? $setting('email'),
                'socials' => array_filter($socials, fn($href) => (string)$href !== ''),
                'company' => $company ?? ($setting('company') ?: $setting('site_name')),
                'logoName' => $logoName ?? $setting('site_name'),
                'year' => $year ?? (int)date('Y'),
            ]
        );
    }

    /**
     * Колонки подвала из таблицы menu: корневые пункты с place = footer - заголовки, вложенные - ссылки колонки.
     * Колонки без ссылок не выводятся
     *
     * @return array<int, array{title: string, links: array<int, array{text: string, href: string, active: bool}>}>
     */
    public static function getMenuColumns(?string $currentPath = null): array
    {
        $path = $currentPath ?? Container::getRequest()->getPath();

        $columns = [];
        foreach (SiteMenu::getRoots(MenuModel::PLACE_FOOTER) as $id => $root) {
            $links = [];
            foreach (SiteMenu::getChildren((int)$id) as $item) {
                $links[] = [
                    'text' => (string)$item['name'],
                    'href' => (string)$item['link'],
                    'active' => static::isActive((string)$item['link'], $path),
                ];
            }
            if ($links) {
                $columns[] = ['title' => (string)$root['name'], 'links' => $links];
            }
        }

        return $columns;
    }

    /**
     * Соцсети подвала из настроек сайта: значение ButtonSocialSmallNetwork => адрес (пустые настройки пропускаются)
     *
     * @return array<string, string>
     */
    public static function getSocials(): array
    {
        $socials = [];
        foreach (static::SOCIAL_SETTINGS as $alias => $network) {
            if ($href = (string)Settings::get($alias, '')) {
                $socials[$network->value] = $href;
            }
        }
        return $socials;
    }

    /**
     * Ссылка активна, если это текущая страница или раздел, в который она входит (главная - только точное совпадение)
     */
    protected static function isActive(string $link, string $path): bool
    {
        if ($link === '' || $link === '/') {
            return $link === $path;
        }
        return str_starts_with($path, $link);
    }
}
