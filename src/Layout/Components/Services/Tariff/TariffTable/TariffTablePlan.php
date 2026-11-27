<?php

namespace Simflex\Core\Layout\Components\Services\Tariff\TariffTable;

/** Тариф, открытый на телефоне при выводе (Figma plan): All — первый; на широком экране видны все */
enum TariffTablePlan: string
{
    case All = 'all';
    case Basic = 'basic';
    case Standard = 'standard';
    case Premium = 'premium';
}
