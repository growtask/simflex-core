<?php

namespace Simflex\Core\Layout\Components\Base\Form\FormResult;

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Marker\Layout as Marker;
use Simflex\Core\Layout\Components\UI\Marker\MarkerSize;
use Simflex\Core\Layout\Components\UI\Marker\MarkerStyle;
use Simflex\Core\Layout\Components\UI\Marker\MarkerTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Результат отправки формы (Figma: Base/Form/result): маркер, заголовок, текст и кнопка.
 * Встаёт на место формы; успех озвучивается role="status", ошибка - role="alert".
 */
class Layout extends LayoutBase
{
    /**
     * @param string $title Заголовок
     * @param string $text Описание
     * @param string $buttonText Текст кнопки, пусто - кнопки нет
     * @param bool $marker Показывать ли маркер
     * @param string $className Дополнительные CSS-классы корня
     * @param array<string,mixed> $attributes HTML-атрибуты корня
     * @param array<string,mixed> $buttonAttributes HTML-атрибуты кнопки (например, data-callback-action)
     */
    public static function drawFormResult(
        string $title = '',
        string $text = '',
        string $buttonText = 'OK',
        bool $marker = true,
        FormResultStyle $style = FormResultStyle::Success,
        FormResultType $type = FormResultType::Horizontal,
        FormResultTheme $theme = FormResultTheme::Light,
        string $className = '',
        array $attributes = [],
        array $buttonAttributes = []
    ): string {
        $dark = $theme === FormResultTheme::Dark;
        $markerHtml = $marker ? Marker::drawMarker(
            size: MarkerSize::Medium,
            style: $style === FormResultStyle::Success ? MarkerStyle::Success : MarkerStyle::Error,
            theme: $dark ? MarkerTheme::Dark : MarkerTheme::Light,
        ) : '';
        $buttonHtml = $buttonText !== '' ? Button::drawButtonMain(
            className: 'result__button',
            text: htmlspecialchars($buttonText),
            style: ButtonMainStyle::Primary,
            size: ButtonMainSize::Medium,
            theme: $dark ? ButtonMainTheme::Dark : ButtonMainTheme::Light,
            attributes: ['type' => 'button'] + $buttonAttributes,
        ) : '';

        return static::draw(
            compact('title', 'text', 'className', 'attributes', 'markerHtml', 'buttonHtml') + [
                'style' => $style->value,
                'type' => $type->value,
                'theme' => $theme->value,
            ]
        );
    }
}
