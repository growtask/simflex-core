<?php

namespace Simflex\Core\Layout\Components\UI\Core\TextInput;

/**
 * Заготовка поля (примеры phone и email набора Figma Inputs)
 */
enum TextInputKind: string
{
    case Text = 'text';
    case Phone = 'phone';
    case Email = 'email';
    /** Пароль: кнопка «Показать пароль» справа */
    case Password = 'password';
    /** Дата ДД.ММ.ГГГГ: маска и календарь (Calendar) под полем */
    case Date = 'date';
    /** Дата и время ДД.ММ.ГГГГ ЧЧ:ММ: после дня в календаре — часы и минуты */
    case DateTime = 'datetime';
    /** Время ЧЧ:ММ: календарь в виде time */
    case Time = 'time';
}
