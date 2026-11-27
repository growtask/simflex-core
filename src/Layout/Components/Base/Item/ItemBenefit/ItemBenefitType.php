<?php

namespace Simflex\Core\Layout\Components\Base\Item\ItemBenefit;

/**
 * Тип знака преимущества: иконка в маркере или крупное число
 */
enum ItemBenefitType: string
{
    case Icon = 'icon';
    case Number = 'number';
}
