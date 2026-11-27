<?php

namespace Simflex\Core\Http;

use Simflex\Core\System\Container;

/**
 * Публикация статики, которая лежит рядом с кодом (ядро, пакеты из vendor, компоненты Layout).
 *
 * Корень веб-сервера - public/ (Container::getPaths()->getPublic()), поэтому такие файлы копируются в
 * public/cache/assets/<hash>/.
 * Копируются только файлы со статическими расширениями (self::EXTENSIONS): php, tpl, scss и прочий код
 * в публичную директорию не попадает, независимо от настроек веб-сервера.
 *
 * В режиме разработчика опубликованные файлы сверяются с исходниками на каждом запросе (по mtime).
 * В рабочем режиме каталог публикуется один раз, а в хеш входит версия исходника (у файла - mtime, у каталога -
 * пути, mtime и размеры файлов внутри): после деплоя или composer update опубликованная копия получает новый адрес.
 * Прежние копии остаются в public/cache/assets: это кэш, его можно удалить целиком.
 */
class Assets
{
    public const EXTENSIONS = [
        'js', 'mjs', 'css', 'map',
        'png', 'jpg', 'jpeg', 'gif', 'webp', 'avif', 'svg', 'ico', 'bmp',
        'woff', 'woff2', 'ttf', 'eot', 'otf',
        'mp4', 'webm', 'ogg', 'mp3', 'wav',
    ];

    /** Каталог публикации относительно public/ */
    public const DIR = '/cache/assets';

    /** @var string[] Опубликованные за текущий запрос пути: исходный путь => url */
    protected static array $published = [];

    /**
     * Публикует файл или каталог и возвращает его url
     * @param string $path Абсолютный путь к файлу или каталогу
     * @return string Url без завершающего слеша, например /cache/assets/1a2b3c4d5e6f7a8b/script.js
     */
    public static function publish(string $path): string
    {
        if (isset(static::$published[$path])) {
            return static::$published[$path];
        }

        $real = realpath($path);
        if ($real === false) {
            throw new \InvalidArgumentException("Asset not found: $path");
        }

        // уже лежит в публичной директории - публиковать нечего
        $public = realpath(Container::getPaths()->getPublic());
        if ($real === $public || str_starts_with($real, $public . DIRECTORY_SEPARATOR)) {
            return static::$published[$path] = str_replace('\\', '/', substr($real, strlen($public)));
        }

        $isDir = is_dir($real);
        if (!$isDir && !static::isStatic($real)) {
            throw new \InvalidArgumentException("Not a static asset: $path");
        }

        $devMode = Container::getConfig()->devMode;
        // версия - по содержимому: у каталога mtime самого каталога не меняется, когда меняются файлы внутри
        // (обновили пакет - копия осталась бы прежней)
        $version = $devMode ? '' : '|' . ($isDir ? static::getDirVersion($real) : filemtime($real));
        $hash = substr(md5(($isDir ? $real : dirname($real)) . $version), 0, 16);
        $target = Container::getPaths()->getPublic() . static::DIR . '/' . $hash;
        $url = static::DIR . '/' . $hash;

        if ($isDir) {
            if ($devMode) {
                static::sync($real, $target);
            } elseif (!is_dir($target)) {
                static::publishDirAtomic($real, $target);
            }
        } else {
            $url .= '/' . basename($real);
            if ($devMode || !is_file($target . '/' . basename($real))) {
                static::copyFile($real, $target . '/' . basename($real));
            }
        }

        return static::$published[$path] = $url;
    }

    protected static function isStatic(string $file): bool
    {
        return in_array(strtolower(pathinfo($file, PATHINFO_EXTENSION)), static::EXTENSIONS, true);
    }

    /**
     * Копирует каталог во временный и переименовывает, чтобы параллельные запросы не увидели его наполовину
     */
    protected static function publishDirAtomic(string $source, string $target): void
    {
        $tmp = $target . '.' . uniqid('', true) . '.tmp';
        static::sync($source, $tmp);
        if (!@rename($tmp, $target)) {
            // каталог уже опубликован параллельным запросом
            static::remove($tmp);
        }
    }

    /**
     * Версия каталога для адреса копии: путь, время изменения и размер каждого публикуемого файла внутри.
     * Меняется, когда файл добавлен, удалён или изменён (в том числе заменён более старым при откате)
     */
    protected static function getDirVersion(string $dir): string
    {
        $files = [];
        foreach (static::getStaticFiles($dir) as $file) {
            $files[] = substr($file->getPathname(), strlen($dir)) . ':' . $file->getMTime() . ':' . $file->getSize();
        }
        sort($files);

        return md5(implode('|', $files));
    }

    /**
     * Публикуемые файлы каталога со всеми вложенными: только статические, без скрытых (с точки)
     * @return iterable<\SplFileInfo>
     */
    protected static function getStaticFiles(string $dir): iterable
    {
        return new \RecursiveIteratorIterator(
            new \RecursiveCallbackFilterIterator(
                new \RecursiveDirectoryIterator($dir, \FilesystemIterator::SKIP_DOTS),
                fn(\SplFileInfo $file) => !str_starts_with($file->getFilename(), '.')
                    && ($file->isDir() || static::isStatic($file->getFilename()))
            )
        );
    }

    /**
     * Копирует из $source в $target статические файлы, которых там нет или которые изменились
     */
    protected static function sync(string $source, string $target): void
    {
        static::makeDir($target);

        foreach (static::getStaticFiles($source) as $file) {
            $dest = $target . substr($file->getPathname(), strlen($source));
            if (!is_file($dest) || filemtime($dest) !== $file->getMTime() || filesize($dest) !== $file->getSize()) {
                static::copyFile($file->getPathname(), $dest);
            }
        }
    }

    protected static function copyFile(string $source, string $dest): void
    {
        static::makeDir(dirname($dest));
        if (is_file($dest) && filemtime($dest) === filemtime($source) && filesize($dest) === filesize($source)) {
            return;
        }

        // пишем во временный файл, чтобы веб-сервер не отдал недописанный
        $tmp = $dest . '.' . uniqid('', true) . '.tmp';
        if (!copy($source, $tmp)) {
            throw new \RuntimeException("Cannot publish asset $source");
        }
        touch($tmp, filemtime($source));
        rename($tmp, $dest);
    }

    protected static function makeDir(string $dir): void
    {
        if (!is_dir($dir) && !@mkdir($dir, 0777, true) && !is_dir($dir)) {
            throw new \RuntimeException("Cannot create directory $dir");
        }
    }

    protected static function remove(string $dir): void
    {
        $it = new \RecursiveIteratorIterator(
            new \RecursiveDirectoryIterator($dir, \FilesystemIterator::SKIP_DOTS),
            \RecursiveIteratorIterator::CHILD_FIRST
        );
        foreach ($it as $file) {
            $file->isDir() ? rmdir($file->getPathname()) : unlink($file->getPathname());
        }
        rmdir($dir);
    }
}
