<?php

namespace Simflex\Core\Layout\Components\Services\Hero\HeroMain;

/** Раскладка (Figma layout): картинка справа или слева, без картинки по центру, картинка фоном */
enum HeroMainLayout: string
{
    case Right = 'right';
    case Left = 'left';
    case Center = 'center';
    case Cover = 'cover';
}
