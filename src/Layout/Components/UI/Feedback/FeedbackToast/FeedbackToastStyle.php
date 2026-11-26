<?php

namespace Simflex\Core\Layout\Components\UI\Feedback\FeedbackToast;

enum FeedbackToastStyle: string
{
    case Default = 'default';
    case Success = 'success';
    case Error = 'error';

    /**
     * @return string ID иконки набора notify
     */
    public function getIcon(): string
    {
        return match ($this) {
            self::Default => 'notify-info',
            self::Success => 'notify-check',
            self::Error => 'notify-close',
        };
    }
}
