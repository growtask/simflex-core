<?php

namespace Simflex\Core\Layout\Components\Base\Player\PlayerWave;

/** Стиль волны (Figma style): проигранная часть main, остальное lighter (primary) или light (accent) */
enum PlayerWaveStyle: string
{
    case Primary = 'primary';
    case Accent = 'accent';
}
