<?php

namespace Simflex\Core\Layout\Components\Base\Form\FormResult;

/**
 * Результат отправки формы (Figma: Form/result, style)
 */
enum FormResultStyle: string
{
    case Success = 'success';
    case Error = 'error';
}
