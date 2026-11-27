<?php

namespace Simflex\Core\Layout\Components\Services\Price\PriceMain;

/** Вид (Figma style): Default — desktop и tablet в строку, на телефоне кнопки под ценой; Compact — без кнопок; Sticky — нижняя панель на телефоне */
enum PriceMainStyle: string
{
    case Default = 'default';
    case Compact = 'compact';
    case Sticky = 'sticky';
}
