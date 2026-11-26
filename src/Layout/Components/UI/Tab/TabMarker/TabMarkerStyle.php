<?php

namespace Simflex\Core\Layout\Components\UI\Tab\TabMarker;

/** Стиль таба с описанием и слотом (Figma Tabs/marker): filled — карточка, soft — без фона до наведения */
enum TabMarkerStyle: string
{
    case Filled = 'filled';
    case Flat = 'flat';
    case Soft = 'soft';
    case Outline = 'outline';
}
