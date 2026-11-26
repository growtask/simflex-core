<?php

namespace Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo;

/** Платёжной системы (набор Figma payments); значение совпадает с именем файла знака в images/payment */
enum PaymentSystem: string
{
    case GooglePay = 'google-pay';
    case Maestro = 'maestro';
    case Mastercard = 'mastercard';
    case Mir = 'mir';
    case Paypal = 'paypal';
    case Qiwi = 'qiwi';
    case Visa = 'visa';
    case Yandex = 'yandex';

    /** Название для скринридера и подсказки */
    public function label(): string
    {
        return match ($this) {
            self::GooglePay => 'Google Pay',
            self::Maestro => 'Maestro',
            self::Mastercard => 'Mastercard',
            self::Mir => 'Мир',
            self::Paypal => 'PayPal',
            self::Qiwi => 'QIWI',
            self::Visa => 'Visa',
            self::Yandex => 'Яндекс Пэй',
        };
    }
}
