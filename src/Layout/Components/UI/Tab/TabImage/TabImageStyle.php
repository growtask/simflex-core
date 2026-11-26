<?php

namespace Simflex\Core\Layout\Components\UI\Tab\TabImage;

/** Стиль таба с картинкой (Figma Tabs/image): primary — карточка, secondary — без фона до наведения */
enum TabImageStyle: string
{
    case Primary = 'primary';
    case Flat = 'flat';
    case Secondary = 'secondary';
    case Outline = 'outline';
}
