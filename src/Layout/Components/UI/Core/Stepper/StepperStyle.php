<?php

namespace Simflex\Core\Layout\Components\UI\Core\Stepper;

enum StepperStyle: string
{
    /** Минус, число, плюс на одной плашке */
    case Default = 'default';
    /** Три плитки: минус, поле, плюс */
    case Input = 'input';
}
