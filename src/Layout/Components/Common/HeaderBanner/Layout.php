<?php

namespace Simflex\Core\Layout\Components\Common\HeaderBanner;

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Строка над шапкой (Figma: Promo/Header/static): текст, кнопка и закрытие. Закрытие запоминается в браузере
 * (localStorage, ключ simflex:header-banner): пока текст, текст кнопки и ссылка не изменились, строка не показывается.
 * Без текста компонент ничего не выводит.
 */
class Layout extends LayoutBase
{
    /**
     * @param string $className Дополнительные CSS-классы
     * @param string $text Текст предложения; если пуст, строка не выводится
     * @param string $buttonText Текст кнопки; без него или без ссылки кнопки нет
     * @param string $buttonLink Адрес кнопки
     * @param string $label Доступное имя региона
     * @param string $closeLabel Доступное имя кнопки закрытия
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты региона
     */
    public static function drawHeaderBanner(
        string $className = '',
        string $text = '',
        string $buttonText = '',
        string $buttonLink = '',
        string $label = 'Спецпредложение',
        string $closeLabel = 'Закрыть',
        array  $attributes = []
    ): string {
        if (trim($text) === '') {
            return '';
        }

        return static::draw(
            compact(
                'className',
                'text',
                'buttonText',
                'buttonLink',
                'label',
                'closeLabel',
                'attributes'
            ) + [
                'key' => static::getKey($text, $buttonText, $buttonLink),
                'buttonStyle' => ButtonStyle::Gray,
                'closeTheme' => ButtonTheme::Dark,
            ]
        );
    }

    /**
     * Ключ предложения: меняется вместе с содержимым, поэтому новое предложение показывается снова
     */
    public static function getKey(string $text, string $buttonText = '', string $buttonLink = ''): string
    {
        return substr(md5($text . '|' . $buttonText . '|' . $buttonLink), 0, 10);
    }
}
