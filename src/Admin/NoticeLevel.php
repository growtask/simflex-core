<?php

namespace Simflex\Core\Admin;

use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\FeedbackNoticeStyle;

/**
 * Уровень уведомления админки (Notice): определяет оформление компонента Notice
 */
enum NoticeLevel: string
{
    case Info = 'info';
    case Warning = 'warning';
    case Error = 'error';

    public function getStyle(): FeedbackNoticeStyle
    {
        return match ($this) {
            self::Info => FeedbackNoticeStyle::Info,
            self::Warning => FeedbackNoticeStyle::Alert,
            self::Error => FeedbackNoticeStyle::Error,
        };
    }
}
