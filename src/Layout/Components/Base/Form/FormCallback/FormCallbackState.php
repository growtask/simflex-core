<?php

namespace Simflex\Core\Layout\Components\Base\Form\FormCallback;

/**
 * Состояние формы (Figma: Form/callback, state)
 */
enum FormCallbackState: string
{
    case Default = 'default';
    /** Поля с ошибками из $errors помечены */
    case Error = 'error';
    /** Кнопка отправки в состоянии load, поля недоступны */
    case Sending = 'sending';
}
