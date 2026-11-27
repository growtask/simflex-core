<?php

namespace Simflex\Core\Layout\Components\Base\Geo\GeoList;

/** Вид списка (Figma style): desktop — выпадает поверх, с подложкой; mobile — в потоке */
enum GeoListStyle: string
{
    case Desktop = 'desktop';
    case Mobile = 'mobile';
}
