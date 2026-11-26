<?php

namespace Simflex\Core\Layout\Components\UI\Stepper\StepperMain;

enum StepperStyle: string
{
    /** Минус, число, плюс на одной плашке */
    case Default = 'default';
    /** Три плитки: минус, поле, плюс */
    case Input = 'input';
    /** Стрелки и счётчик «текущее/всего» (всего — `max`) на одной плашке, значение вводом не меняется */
    case Among = 'among';
}
