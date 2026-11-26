<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonStates;

/** Состояние кнопки (набор Figma Buttons/states) */
enum ButtonStatesState: string
{
    /** Кнопка недоступна: рядом нужна причина */
    case Disabled = 'disabled';
    /** Действие выполнено */
    case Success = 'success';
    /** Действие не удалось */
    case Error = 'error';
}
