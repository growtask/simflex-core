<?php

namespace Simflex\Core\Layout\Components\Common\Benefit;

/**
 * Тип знака преимущества: иконка в маркере или крупное число
 */
enum BenefitType: string
{
    case Icon = 'icon';
    case Number = 'number';
}
