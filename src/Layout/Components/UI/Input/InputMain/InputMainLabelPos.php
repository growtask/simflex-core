<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputMain;

enum InputMainLabelPos: string
{
    case Hidden = 'hidden';
    case Standard = 'standard';
    /** Подпись внутри поля: в пустом поле на месте текста, при вводе и фокусе поднимается (Figma label=inside) */
    case Inside = 'inside';
}
