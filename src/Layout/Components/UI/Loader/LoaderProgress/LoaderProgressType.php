<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderProgress;

/** Determinate — известна доля выполненного (value), Indeterminate — конец неизвестен, полоса бежит */
enum LoaderProgressType: string
{
    case Determinate = 'determinate';
    case Indeterminate = 'indeterminate';
}
