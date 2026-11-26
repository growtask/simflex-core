<?php

namespace Simflex\Core\Admin;

use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\NoticeStyle;

/**
 * Уровень уведомления админки (Notice): определяет оформление компонента Notice
 */
enum NoticeLevel: string
{
    case Info = 'info';
    case Warning = 'warning';
    case Error = 'error';

    public function getStyle(): NoticeStyle
    {
        return match ($this) {
            self::Info => NoticeStyle::Info,
            self::Warning => NoticeStyle::Alert,
            self::Error => NoticeStyle::Error,
        };
    }
}
