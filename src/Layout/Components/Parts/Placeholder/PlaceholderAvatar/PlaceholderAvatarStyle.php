<?php

namespace Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar;

enum PlaceholderAvatarStyle: string
{
    /** Силуэт (иконка user) */
    case Silhouette = 'silhouette';
    /** Инициалы имени */
    case Initials = 'initials';
}
