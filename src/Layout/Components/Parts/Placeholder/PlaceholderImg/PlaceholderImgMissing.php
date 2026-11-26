<?php

namespace Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg;

/** Что выводить, если файла картинки нет */
enum PlaceholderImgMissing: string
{
    /** Картинка-заглушка темы (images/placeholders/fallback-img.webp) */
    case Placeholder = 'placeholder';
    /** Ничего: компонент возвращает пустую строку */
    case Hide = 'hide';
}
