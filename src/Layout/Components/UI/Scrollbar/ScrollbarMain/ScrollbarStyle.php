<?php

namespace Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain;

enum ScrollbarStyle: string
{
    /** Дорожка и ползунок; полоса занимает место рядом с содержимым */
    case Classic = 'classic';
    /** Тонкий ползунок без дорожки поверх содержимого */
    case Overlay = 'overlay';
}
