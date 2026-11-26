<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton;

/** Форма заглушки: строка текста, круг (аватар), прямоугольник (картинка) */
enum SkeletonShape: string
{
    case Text = 'text';
    case Circle = 'circle';
    case Rect = 'rect';
}
