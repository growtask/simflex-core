<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderProgressLabel;

/** Вид полосы с процентами: Progress — идёт, Active — выбрана (рамка бренда), Disabled — недоступна */
enum ProgressLabelStyle: string
{
    case Progress = 'progress';
    case Active = 'active';
    case Disabled = 'disabled';
}
