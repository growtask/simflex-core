<?php

namespace Simflex\Core\Layout\Components\Services\Tariff\TariffList;

/** Период цен при выводе (Figma period) */
enum TariffListPeriod: string
{
    case Month = 'month';
    case Year = 'year';
}
