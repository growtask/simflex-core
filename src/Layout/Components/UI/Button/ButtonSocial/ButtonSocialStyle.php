<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonSocial;

/**
 * Стиль кнопки соцсети (Figma Buttons/social): три нейтральных и по стилю на сеть. Цвета сетей — только в стилях сетей.
 * Значение сети совпадает с иконкой спрайта social-<значение>
 */
enum ButtonSocialStyle: string
{
    case Primary = 'primary';
    case Secondary = 'secondary';
    case Gray = 'gray';
    case Figma = 'figma';
    case Google = 'google';
    case Instagram = 'instagram';
    case Max = 'max';
    case Rutube = 'rutube';
    case Telegram = 'telegram';
    case Vkontakte = 'vkontakte';
    case Whatsapp = 'whatsapp';
    case Yandex = 'yandex';
    case YandexZen = 'yandex-zen';
    case Youtube = 'youtube';

    /** Кнопка сети: у неё свой цвет и логотип */
    public function isNetwork(): bool
    {
        return !in_array($this, [self::Primary, self::Secondary, self::Gray], true);
    }

    /** Название сети для подписи по умолчанию */
    public function label(): string
    {
        return match ($this) {
            self::Primary, self::Secondary, self::Gray => 'Button',
            self::Figma => 'Figma',
            self::Google => 'Google',
            self::Instagram => 'Instagram',
            self::Max => 'MAX',
            self::Rutube => 'RUTUBE',
            self::Telegram => 'Telegram',
            self::Vkontakte => 'ВКонтакте',
            self::Whatsapp => 'WhatsApp',
            self::Yandex => 'Яндекс',
            self::YandexZen => 'Дзен',
            self::Youtube => 'YouTube',
        };
    }
}
