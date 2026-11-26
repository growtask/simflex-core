<?php

namespace Simflex\Core\Layout\Components\Parts\Delivery\DeliveryLogo;

/** Службы доставки (набор Figma delivery); значение совпадает с именем файла знака в images/delivery */
enum DeliveryService: string
{
    case FivePost = '5post';
    case Cdek = 'cdek';
    case Ozon = 'ozon';
    case RussianPost = 'russian-post';
    case YandexDelivery = 'yandex-delivery';

    /** Название для скринридера и подсказки */
    public function label(): string
    {
        return match ($this) {
            self::FivePost => '5Post',
            self::Cdek => 'СДЭК',
            self::Ozon => 'Ozon',
            self::RussianPost => 'Почта России',
            self::YandexDelivery => 'Яндекс Доставка',
        };
    }
}
