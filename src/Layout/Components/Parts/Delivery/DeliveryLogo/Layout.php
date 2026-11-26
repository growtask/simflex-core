<?php

namespace Simflex\Core\Layout\Components\Parts\Delivery\DeliveryLogo;

use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\PlaceholderImgMissing;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\Layout as PlaceholderImg;
use Simflex\Core\Layout\LayoutBase;

/**
 * Знак службы доставки (Figma, блок Delivery): цветной, одноцветный и одноцветный для тёмного фона. Высота знака 40.
 * С `href` знак выводится ссылкой
 */
class Layout extends LayoutBase
{
    /**
     * @param string $label Название для скринридера; пусто - название из DeliveryLogoService::label()
     * @param string $href Адрес: с ним вместо span выводится ссылка a
     * @param string $src Адрес картинки знака (SVG); пусто - знак по умолчанию из images/delivery, картинка проверяется на наличие, без файла ничего не выводится
     * @param array<string,mixed> $attributes Атрибуты корневого элемента
     */
    public static function drawDeliveryLogo(
        DeliveryLogoService $service,
        DeliveryLogoStyle $style = DeliveryLogoStyle::Color,
        string $label = '',
        string $href = '',
        string $src = '',
        string $className = '',
        array $attributes = []
    ): string {
        $image = PlaceholderImg::drawPlaceholderImg(
            src: $src !== '' ? $src : asset('images/delivery/' . $service->value . $style->suffix() . '.svg'),
            alt: $label !== '' ? $label : $service->label(),
            missing: PlaceholderImgMissing::Hide,
            imgClass: 'delivery-logo__image'
        );
        // Нет файла знака - ничего не выводим
        if ($image === '') {
            return '';
        }

        return static::draw([
            'style' => $style->value,
            'href' => $href,
            'image' => $image,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }
}
