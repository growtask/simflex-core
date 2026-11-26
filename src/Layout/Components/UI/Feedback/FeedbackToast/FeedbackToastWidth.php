<?php

namespace Simflex\Core\Layout\Components\UI\Feedback\FeedbackToast;

enum FeedbackToastWidth: string
{
    /** По тексту */
    case Hug = 'hug';
    /** На ширину контейнера */
    case Fill = 'fill';
}
