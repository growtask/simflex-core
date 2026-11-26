<?php

namespace Simflex\Core\Layout\Components\Parts\Payment\PaymentList;

use Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo\PaymentLogoSystem;
use Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo\Layout as PaymentLogo;
use Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo\PaymentLogoStyle;
use Simflex\Core\Layout\LayoutBase;

/**
 * Ряд знаков (Figma, блок Payment): знаки с зазором 20, переносятся на новую строку. Знаки без файла пропускаются,
 * без знаков ничего не выводится
 */
class Layout extends LayoutBase
{
    /**
     * @param list<PaymentLogoSystem> $systems Какие знаки показать и в каком порядке; пусто - все
     * @param string $label Название списка для скринридера
     * @param array<string,mixed> $attributes Атрибуты списка
     */
    public static function drawPaymentList(
        array $systems = [],
        PaymentLogoStyle $style = PaymentLogoStyle::Color,
        string $label = 'Способы оплаты',
        string $className = '',
        array $attributes = []
    ): string {
        $items = [];
        foreach ($systems ?: PaymentLogoSystem::cases() as $system) {
            $logo = PaymentLogo::drawPaymentLogo($system, $style);
            if ($logo !== '') {
                $items[] = $logo;
            }
        }

        if ($items === []) {
            return '';
        }

        return static::draw([
            'items' => $items,
            'label' => $label,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }
}
