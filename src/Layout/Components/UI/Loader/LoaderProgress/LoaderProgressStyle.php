<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderProgress;

/** Цвет заполнения: основной, успех, ошибка */
enum LoaderProgressStyle: string
{
    case Primary = 'primary';
    case Success = 'success';
    case Error = 'error';
}
