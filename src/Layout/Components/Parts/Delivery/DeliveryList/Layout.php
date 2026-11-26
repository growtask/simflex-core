<?php

namespace Simflex\Core\Layout\Components\Parts\Delivery\DeliveryList;

use Simflex\Core\Layout\Components\Parts\Delivery\DeliveryLogo\DeliveryService;
use Simflex\Core\Layout\Components\Parts\Delivery\DeliveryLogo\Layout as DeliveryLogo;
use Simflex\Core\Layout\Components\Parts\Delivery\DeliveryLogo\DeliveryStyle;
use Simflex\Core\Layout\LayoutBase;

/**
 * Ряд знаков (Figma, блок Delivery): знаки с зазором 20, переносятся на новую строку. Знаки без файла пропускаются,
 * без знаков ничего не выводится
 */
class Layout extends LayoutBase
{
    /**
     * @param list<DeliveryService> $services Какие знаки показать и в каком порядке; пусто - все
     * @param string $label Название списка для скринридера
     * @param array<string,mixed> $attributes Атрибуты списка
     */
    public static function drawDeliveryList(
        array $services = [],
        DeliveryStyle $style = DeliveryStyle::Color,
        string $label = 'Способы доставки',
        string $className = '',
        array $attributes = []
    ): string {
        $items = [];
        foreach ($services ?: DeliveryService::cases() as $service) {
            $logo = DeliveryLogo::drawDeliveryLogo($service, $style);
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
