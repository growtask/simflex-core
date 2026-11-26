<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderProgress;

/**
 * Размер: полоса и шаги — толщина 12, 8, 4 px; кольцо — 72, 56, 40 px; полоса с процентами — Large и Medium
 * одного размера (высота 48 px), Small — компактная (40 px)
 */
enum LoaderProgressSize: string
{
    case Large = 'l';
    case Medium = 'm';
    case Small = 's';
}
