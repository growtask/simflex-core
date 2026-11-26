<?php

namespace Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain;

enum ScrollbarMainStyle: string
{
    /** Дорожка и ползунок; полоса занимает место рядом с содержимым */
    case Classic = 'classic';
    /** Тонкий ползунок без дорожки поверх содержимого */
    case Overlay = 'overlay';
}
