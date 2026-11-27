<?php

namespace Simflex\Core\Layout\Components\Base\Geo\GeoModal;

use Simflex\Core\Layout\LayoutBase;

/**
 * Выбор города (Figma Base/GEO/modal): кнопка текущего города в шапке и окно «Ваш город» с содержимым GeoMain —
 * вопрос «Да / Нет», поиск по списку городов GeoList, «Сохранить». Поведение — script.js: на desktop окно под
 * кнопкой, на телефоне — окно ModalMain (выводится внутри блока), поиск на клиенте, выбор запоминается в localStorage
 * (ключ storageKey), событие sf-geo-change ({ detail: { city } }) на корне.
 */
class Layout extends LayoutBase
{
    /**
     * @param string $city Подтверждённый город (пусто — спросить угаданный)
     * @param string $guess Угаданный город для вопроса «Ваш город — …?»
     * @param string[] $cities Города для поиска
     * @param bool $ask Открыть окно с вопросом при загрузке, если город ещё не выбран
     * @param string $storageKey Ключ localStorage для выбора
     * @param string $placeholder Текст кнопки без города
     * @param bool $open Окно открыто при выводе, без скрипта (витрина, макеты): вид задаёт style
     * @param string $className Дополнительные CSS-классы
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты корня
     */
    public static function drawGeoModal(
        string        $city = '',
        string        $guess = '',
        array         $cities = [],
        bool          $ask = false,
        string        $storageKey = 'sf-geo-city',
        string        $placeholder = 'Выберите город',
        GeoModalTheme $theme = GeoModalTheme::Light,
        bool          $open = false,
        GeoModalStyle $style = GeoModalStyle::Desktop,
        string        $className = '',
        array         $attributes = [],
    ): string {
        $cities = array_values(array_unique(array_filter(array_map('strval', $cities), static fn($c) => $c !== '')));

        return static::draw([
            'city' => $city,
            'guess' => $guess,
            'cities' => $cities,
            'ask' => $ask,
            'storageKey' => $storageKey,
            'placeholder' => $placeholder,
            'theme' => $theme->value,
            'open' => $open,
            'style' => $style->value,
            'className' => $className,
            'attributes' => $attributes,
            'id' => 'geo-' . substr(md5($guess . implode(',', $cities) . uniqid('', true)), 0, 8),
        ]);
    }
}
