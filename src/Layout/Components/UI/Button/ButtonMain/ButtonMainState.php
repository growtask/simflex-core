<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonMain;

/** Результат действия на кнопке (Figma Buttons/states); недоступная кнопка задаётся параметром `disabled` */
enum ButtonMainState: string
{
    /** Обычная кнопка */
    case Default = 'default';
    /** Действие выполнено */
    case Success = 'success';
    /** Действие не удалось */
    case Error = 'error';
}
