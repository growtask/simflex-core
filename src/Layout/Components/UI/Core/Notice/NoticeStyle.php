<?php

namespace Simflex\Core\Layout\Components\UI\Core\Notice;

enum NoticeStyle: string
{
    case Info = 'info';
    case Error = 'error';
    case Alert = 'alert';
    case Success = 'success';

    /**
     * @return string ID иконки набора notify
     */
    public function getIcon(): string
    {
        return match ($this) {
            self::Info => 'notify-info',
            self::Error => 'notify-close',
            self::Alert => 'notify-alert',
            self::Success => 'notify-check',
        };
    }
}
