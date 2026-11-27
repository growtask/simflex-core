<?php

namespace Simflex\Core\Layout\Components\Services\Price\PriceMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Блок цены на странице услуги (Figma Services/Price/main): цена «от», единица, старая цена и скидка, время работы,
 * кнопки «Заказать» и «Спросить» (или «Недоступно»). Style Default — на FullHD, HD и планшете одна строка, на
 * телефоне кнопки под ценой; Compact — без кнопок; Sticky — нижняя панель на телефоне: появляется, когда блок цены
 * страницы (watch) ушёл с экрана (script.js); на больших экранах её нет
 */
class Layout extends LayoutBase
{
    /**
     * @param string $price Сумма (Figma price text), например «10 000 ₽»
     * @param string $special Текст вместо цены у type=Special (Figma special text)
     * @param string $from Приставка «от»; пусто — без неё
     * @param string $unit Единица («/ проект»); пусто — без неё
     * @param string $oldPrice Старая цена (зачёркнута); пусто — без неё
     * @param string $discount Скидка («-17%»); пусто — без неё
     * @param string $time Время работы («10 часов»); пусто — без него
     * @param string $orderText Текст главной кнопки; пусто — без неё (Figma primary)
     * @param string $orderLink Адрес главной кнопки; пусто — кнопка button (атрибуты — orderAttributes)
     * @param string $askText Текст второй кнопки; пусто — без неё (Figma secondary)
     * @param string $askLink Адрес второй кнопки
     * @param bool $unavailable Услугу нельзя заказать: вместо главной кнопки недоступная «Недоступно»
     * @param string $watch id блока цены страницы, за которым следит Sticky: панель видна, пока его нет на экране
     * @param bool $inline Sticky в потоке страницы (витрина, макеты), без скрипта
     * @param array<string,mixed> $orderAttributes HTML-атрибуты главной кнопки (data-modal и т. п.)
     * @param array<string,mixed> $askAttributes HTML-атрибуты второй кнопки
     * @param string $className Дополнительные CSS-классы (price_view_tablet, price_view_mobile — вид этой ширины для витрины)
     * @param array<string,mixed> $attributes HTML-атрибуты корня
     */
    public static function drawPriceMain(
        string         $price = '',
        PriceMainType  $type = PriceMainType::Fixed,
        string         $special = 'По запросу',
        string         $from = '',
        string         $unit = '',
        string         $oldPrice = '',
        string         $discount = '',
        string         $time = '',
        string         $orderText = 'Заказать',
        string         $orderLink = '',
        string         $askText = 'Спросить',
        string         $askLink = '',
        bool           $unavailable = false,
        PriceMainStyle $style = PriceMainStyle::Default,
        PriceMainTheme $theme = PriceMainTheme::Light,
        string         $watch = '',
        bool           $inline = false,
        array          $orderAttributes = [],
        array          $askAttributes = [],
        string         $className = '',
        array          $attributes = [],
    ): string {
        return static::draw(compact(
            'price', 'special', 'from', 'unit', 'oldPrice', 'discount', 'time', 'orderText', 'orderLink', 'askText',
            'askLink', 'unavailable', 'watch', 'inline', 'orderAttributes', 'askAttributes', 'className', 'attributes'
        ) + [
            'type' => $type->value,
            'style' => $style->value,
            'theme' => $theme->value,
        ]);
    }
}
