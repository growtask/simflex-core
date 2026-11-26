<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonFeedback;

/** Что оценивает кнопка: Like — «нравится», Dislike — «не нравится» (иконка спрайта с тем же именем) */
enum ButtonFeedbackType: string
{
    case Like = 'like';
    case Dislike = 'dislike';
}
