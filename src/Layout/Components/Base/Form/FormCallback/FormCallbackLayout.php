<?php

namespace Simflex\Core\Layout\Components\Base\Form\FormCallback;

/**
 * Раскладка формы (Figma: Form/callback, layout)
 */
enum FormCallbackLayout: string
{
    /** Для страницы: имя и телефон в одной строке */
    case Grid = 'grid';
    /** Для модального окна и mobile: одна колонка */
    case Stack = 'stack';
}
