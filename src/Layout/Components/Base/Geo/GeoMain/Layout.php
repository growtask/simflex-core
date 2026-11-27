<?php

namespace Simflex\Core\Layout\Components\Base\Geo\GeoMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Содержимое выбора города (Figma Base/GEO/main): вопрос «Ваш город: …?» с кнопками «Да» и «Нет», после
 * подтверждения — «Изменить» и «Принять», поиск по списку городов GeoList и «Сохранить». Выводится внутри GeoModal
 * (окно под кнопкой или ModalMain на телефоне); поведение — скрипт GeoModal. state задаёт вид при выводе: в живом
 * окне его меняет скрипт (static, active, choice), остальные — вид для витрины и макетов
 */
class Layout extends LayoutBase
{
    /**
     * @param string $city Подтверждённый город (state=active)
     * @param string $guess Угаданный город для вопроса «Ваш город — …?»
     * @param string[] $cities Города для поиска
     * @param string $id Префикс id (список — <id>-list)
     * @param string $query Текст в поле поиска (state=dropdown, selected, empty)
     * @param string $className Дополнительные CSS-классы
     */
    public static function drawGeoMain(
        string       $city = '',
        string       $guess = '',
        array        $cities = [],
        GeoMainState $state = GeoMainState::Static,
        GeoMainStyle $style = GeoMainStyle::Desktop,
        GeoMainTheme $theme = GeoMainTheme::Light,
        string       $id = '',
        string       $query = '',
        string       $className = '',
    ): string {
        $cities = array_values(array_unique(array_filter(array_map('strval', $cities), static fn($c) => $c !== '')));

        return static::draw([
            'city' => $city,
            'guess' => $guess,
            'cities' => $cities,
            'state' => $state->value,
            'style' => $style->value,
            'theme' => $theme->value,
            'id' => $id !== '' ? $id : 'geo-' . substr(md5($guess . implode(',', $cities)), 0, 8),
            'query' => $query,
            'className' => $className,
        ]);
    }
}
