<?php

namespace Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo;

use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\PlaceholderImgMissing;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\Layout as PlaceholderImg;
use Simflex\Core\Layout\LayoutBase;

/**
 * Знак платёжной системы (Figma, блок Payment): цветной, одноцветный и одноцветный для тёмного фона. Высота знака 40.
 * С `href` знак выводится ссылкой
 */
class Layout extends LayoutBase
{
    /**
     * @param string $label Название для скринридера; пусто - название из PaymentLogoSystem::label()
     * @param string $href Адрес: с ним вместо span выводится ссылка a
     * @param string $src Адрес картинки знака (SVG); пусто - знак по умолчанию из images/payment, картинка проверяется на наличие, без файла ничего не выводится
     * @param array<string,mixed> $attributes Атрибуты корневого элемента
     */
    public static function drawPaymentLogo(
        PaymentLogoSystem $system,
        PaymentLogoStyle $style = PaymentLogoStyle::Color,
        string $label = '',
        string $href = '',
        string $src = '',
        string $className = '',
        array $attributes = []
    ): string {
        $image = PlaceholderImg::drawPlaceholderImg(
            src: $src !== '' ? $src : asset('images/payment/' . $system->value . $style->suffix() . '.svg'),
            alt: $label !== '' ? $label : $system->label(),
            missing: PlaceholderImgMissing::Hide,
            imgClass: 'payment-logo__image'
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
