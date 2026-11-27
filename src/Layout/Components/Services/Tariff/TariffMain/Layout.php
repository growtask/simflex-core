<?php

namespace Simflex\Core\Layout\Components\Services\Tariff\TariffMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Карточка тарифа (Figma Services/Tariff/main): название, ярлык, описание, цена с периодом, старой ценой и скидкой,
 * возможности (входит — check, не входит — close; описание и подсказка) и кнопка выбора. featured — рекомендуемый
 * (фон color1/lighter, рамка color1/main, кнопка primary). Наведение — тень, нажатие — фон color1/lighter.
 * Цены за год (year*) выводятся рядом с ценами за месяц: какие видны, решает период TariffList
 */
class Layout extends LayoutBase
{
    /**
     * @param string $name Название тарифа (Figma name text)
     * @param string $description Описание; пусто — без него
     * @param string $label Ярлык у названия; пусто — без него
     * @param string $price Цена
     * @param string $period Период («/ проект», «/ мес»); пусто — без него
     * @param string $oldPrice Старая цена; пусто — без неё
     * @param string $discount Скидка («-17%»); пусто — без неё
     * @param array{price?:string,period?:string,oldPrice?:string,discount?:string} $year Цена за год (для TariffList);
     *        пусто — одна цена
     * @param list<array{text:string,description?:string,hint?:string,included?:bool}> $features Возможности (до 8):
     *        included false — не входит (иконка close)
     * @param string $buttonText Текст кнопки; пусто — без неё
     * @param string $buttonLink Адрес кнопки; пусто — кнопка button
     * @param array<string,mixed> $buttonAttributes HTML-атрибуты кнопки
     * @param bool $featured Рекомендуемый тариф (в ряду — один)
     * @param bool $disabled Тариф недоступен: бледный, кнопка недоступна
     * @param int $headingLevel Уровень заголовка
     * @param string $className Дополнительные CSS-классы
     * @param array<string,mixed> $attributes HTML-атрибуты корня
     */
    public static function drawTariffMain(
        string          $name,
        string          $description = '',
        string          $label = '',
        string          $price = '',
        string          $period = '',
        string          $oldPrice = '',
        string          $discount = '',
        array           $year = [],
        array           $features = [],
        string          $buttonText = 'Выбрать',
        string          $buttonLink = '',
        array           $buttonAttributes = [],
        bool            $featured = false,
        bool            $disabled = false,
        TariffMainTheme $theme = TariffMainTheme::Light,
        int             $headingLevel = 3,
        string          $className = '',
        array           $attributes = [],
    ): string {
        $features = array_values(array_filter($features, static fn($f) => is_array($f) && ($f['text'] ?? '') !== ''));

        return static::draw(compact(
            'name', 'description', 'label', 'price', 'period', 'oldPrice', 'discount', 'year', 'features', 'buttonText',
            'buttonLink', 'buttonAttributes', 'featured', 'disabled', 'className', 'attributes'
        ) + [
            'theme' => $theme->value,
            'headingLevel' => min(6, max(1, $headingLevel)),
        ]);
    }
}
