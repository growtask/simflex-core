<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputCode;

/**
 * Состояние поля кода (Figma Inputs/code, свойство state; empty, filling и filled задаёт сам ввод)
 */
enum InputCodeState: string
{
    /** Обычное: поля подсвечиваются по вводу */
    case Default = 'default';
    /** Неверный код: красная обводка и сообщение под полем */
    case Error = 'error';
    /** Код принят: сообщение об успехе под полем */
    case Success = 'success';
}
