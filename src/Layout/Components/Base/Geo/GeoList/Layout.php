<?php

namespace Simflex\Core\Layout\Components\Base\Geo\GeoList;

use Simflex\Core\Layout\LayoutBase;

/**
 * Список городов (Figma Base/GEO/list): совпадения, пока посетитель печатает в поиске GeoMain; пункты — Tabs/main
 * filled s. Фильтрует и выбирает город скрипт GeoModal; без совпадений — «Ничего не найдено...»
 */
class Layout extends LayoutBase
{
    /**
     * @param string[] $cities Города
     * @param string $id id списка (на него ссылается поле поиска через aria-controls)
     * @param bool $empty Показать «Ничего не найдено» вместо городов
     * @param bool $hidden Скрыт при выводе (откроет поиск)
     * @param string $className Дополнительные CSS-классы
     */
    public static function drawGeoList(
        array        $cities = [],
        string       $id = '',
        GeoListStyle $style = GeoListStyle::Desktop,
        GeoListTheme $theme = GeoListTheme::Light,
        bool         $empty = false,
        bool         $hidden = false,
        string       $className = '',
    ): string {
        $cities = array_values(array_unique(array_filter(array_map('strval', $cities), static fn($c) => $c !== '')));

        return static::draw([
            'cities' => $cities,
            'id' => $id !== '' ? $id : 'geo-list-' . substr(md5(implode(',', $cities)), 0, 8),
            'style' => $style->value,
            'theme' => $theme->value,
            'empty' => $empty,
            'hidden' => $hidden,
            'className' => $className,
        ]);
    }
}
