<?php

namespace Simflex\Core\Layout\Components\UI\Other\BadgeStock;

enum BadgeStockStyle: string
{
    case Many = 'many';
    case Normal = 'normal';
    case Few = 'few';
    case NoStock = 'no-stock';
}
