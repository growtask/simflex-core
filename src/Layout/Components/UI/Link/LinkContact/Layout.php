<?php

namespace Simflex\Core\Layout\Components\UI\Link\LinkContact;

use Simflex\Core\Layout\LayoutBase;

/**
 * Крупная ссылка-контакт: телефон, почта, любая другая ссылка (Figma: UI/links/contact)
 */
class Layout extends LayoutBase
{
    /**
     * @param string $className Дополнительные CSS-классы
     * @param string $text Видимый текст (номер или адрес); если пуст, берётся $value
     * @param string $value Номер телефона, адрес почты или адрес ссылки (для ContactType::Custom)
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты ссылки
     */
    public static function drawContact(
        string       $className = '',
        string       $text = '',
        string       $value = '',
        ContactType  $type = ContactType::Phone,
        ContactStyle $style = ContactStyle::Flat,
        ContactSize  $size = ContactSize::Small,
        ContactTheme $theme = ContactTheme::Light,
        array        $attributes = []
    ): string {
        return static::draw(
            compact(
                'className',
                'attributes'
            ) + [
                'text' => $text !== '' ? $text : $value,
                'href' => static::getHref($type, $value),
                'type' => $type->value,
                'style' => $style->value,
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }

    /**
     * Адрес ссылки: tel: с номером без пробелов, mailto: для почты
     */
    public static function getHref(ContactType $type, string $value): string
    {
        return match ($type) {
            ContactType::Phone => 'tel:' . preg_replace('/[^\d+]/', '', $value),
            ContactType::Email => 'mailto:' . trim($value),
            ContactType::Custom => $value,
        };
    }
}
