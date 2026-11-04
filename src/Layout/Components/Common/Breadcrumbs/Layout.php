<?php

namespace Simflex\Core\Layout\Components\Common\Breadcrumbs;

use Simflex\Core\Layout\LayoutBase;

/**
 * Хлебные крошки (Figma nav/breadcrumbs, design-base-nav.md): кнопка «домой», пункты через «/», последний пункт —
 * текущая страница (не ссылка, aria-current="page"). На телефоне середина сворачивается: дом, «…», родитель,
 * текущая; «…» раскрывает скрытые пункты
 */
class Layout extends LayoutBase
{
    /**
     * @param list<array{name: string, link?: string}> $items Пункты от корня до текущей страницы (название
     *        экранируется); у последнего ссылка не выводится
     * @param string $homeLink Адрес кнопки «домой», пусто — без кнопки
     * @param string $homeLabel Доступное имя кнопки «домой»
     */
    public static function drawBreadcrumbs(
        array            $items,
        string           $homeLink = '/',
        string           $homeLabel = 'Главная',
        BreadcrumbsTheme $theme = BreadcrumbsTheme::Light,
        string           $label = 'Хлебные крошки',
        string           $className = '',
    ): string {
        $items = array_values($items);

        return static::draw(compact('items', 'homeLink', 'homeLabel', 'label', 'className') + [
            'theme' => $theme->value,
        ]);
    }
}
