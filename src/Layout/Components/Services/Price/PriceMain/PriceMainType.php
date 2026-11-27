<?php

namespace Simflex\Core\Layout\Components\Services\Price\PriceMain;

/** Цена (Figma price type): Fixed — сумма; Special — текст вроде «По запросу» */
enum PriceMainType: string
{
    case Fixed = 'fixed';
    case Special = 'special';
}
