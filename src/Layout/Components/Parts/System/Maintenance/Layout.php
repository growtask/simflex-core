<?php

namespace Simflex\Core\Layout\Components\Parts\System\Maintenance;

use Simflex\Core\Layout\LayoutBase;

/**
 * Страница технических работ (Figma, блок System: maintenance): логотип, заголовок, текст и кнопка
 * «Связаться с нами» по центру экрана. Отдавайте её с кодом 503 и заголовком Retry-After;
 * указывайте ожидаемое время, если оно известно.
 */
class Layout extends LayoutBase
{
    /**
     * @param string $buttonLink Ссылка кнопки (mailto:, tel:, страница контактов); пусто - без кнопки
     * @param string $logoHtml HTML логотипа (Logo::drawLogo); пусто - без логотипа
     * @param bool $inline Не занимать весь экран, а выводить в рамке в потоке (витрина)
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawMaintenance(
        MaintenanceTheme $theme = MaintenanceTheme::Light,
        string           $title = 'Скоро вернёмся',
        string           $text = 'На сайте идут технические работы. Загляните позже.',
        string           $buttonText = 'Связаться с нами',
        string           $buttonLink = '',
        string           $logoHtml = '',
        bool             $inline = false,
        string           $className = '',
        array            $attributes = []
    ): string {
        return static::draw([
            'theme' => $theme->value,
            'title' => $title,
            'text' => $text,
            'buttonText' => $buttonText,
            'buttonLink' => $buttonLink,
            'logoHtml' => $logoHtml,
            'inline' => $inline,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }
}
