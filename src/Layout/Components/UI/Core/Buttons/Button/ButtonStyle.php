<?php

namespace Simflex\Core\Layout\Components\UI\Core\Buttons\Button;

enum ButtonStyle: string
{
    case Primary = 'primary';
    case Secondary = 'secondary';
    case Accent = 'accent';
    case Gray = 'gray';
    case Outline = 'outline';
    case Monochrome = 'monochrome';
    case Flat = 'flat';
    /** Buttons/states: успех */
    case Success = 'success';
    /** Buttons/states: ошибка */
    case Error = 'error';
}
