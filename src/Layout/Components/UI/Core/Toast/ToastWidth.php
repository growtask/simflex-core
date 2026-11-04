<?php

namespace Simflex\Core\Layout\Components\UI\Core\Toast;

enum ToastWidth: string
{
    /** По тексту */
    case Hug = 'hug';
    /** На ширину контейнера */
    case Fill = 'fill';
}
