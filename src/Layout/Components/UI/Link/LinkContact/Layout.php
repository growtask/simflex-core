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
     * @param string $value Номер телефона, адрес почты или адрес ссылки (для LinkContactType::Custom)
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты ссылки
     */
    public static function drawLinkContact(
        string       $className = '',
        string       $text = '',
        string       $value = '',
        LinkContactType  $type = LinkContactType::Phone,
        LinkContactStyle $style = LinkContactStyle::Flat,
        LinkContactSize  $size = LinkContactSize::Small,
        LinkContactTheme $theme = LinkContactTheme::Light,
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
    public static function getHref(LinkContactType $type, string $value): string
    {
        return match ($type) {
            LinkContactType::Phone => 'tel:' . preg_replace('/[^\d+]/', '', $value),
            LinkContactType::Email => 'mailto:' . trim($value),
            LinkContactType::Custom => $value,
        };
    }
}
