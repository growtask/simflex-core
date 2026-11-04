<?php

namespace Simflex\Core\Layout\Components\Common\Uploader;

/**
 * Что загружается: картинка (превью в строке файла) или любой файл (иконка и имя)
 */
enum UploaderKind: string
{
    case Image = 'image';
    case File = 'file';
}
