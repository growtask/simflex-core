<?php

namespace Simflex\Core\Media;

use Simflex\Core\System\Container;

/**
 * Загруженный файл сайта: public/uf/<pathBase>/<path>/<имя>.<расширение>.
 *
 * Имя генерируется при создании объекта (цифры из текущего времени), расширение берётся у загруженного файла.
 * Файлы с исполняемыми расширениями (FORBIDDEN_EXTENSIONS) не принимаются
 */
class File
{
    /** Расширения, которые нельзя сохранять в публичный каталог: сервер может их выполнить */
    public const array FORBIDDEN_EXTENSIONS = [
        'php', 'php3', 'php4', 'php5', 'php7', 'php8', 'phtml', 'pht', 'phps', 'phar', 'inc',
        'htaccess', 'htpasswd', 'ini', 'cgi', 'pl', 'py', 'sh', 'asp', 'aspx', 'jsp', 'shtml',
    ];

    /** Корень загрузок, null - public/uf. Подменяется в тестах */
    protected static ?string $uploadRoot = null;

    /** Подкаталог корня загрузок */
    public string $pathBase = 'files';

    /** Каталог файла с завершающим слешем */
    public string $path;

    /** Имя файла без расширения */
    public string $name;

    /** Расширение файла, '' - файл не загружен */
    public string $type = '';

    /**
     * @param string $path Подкаталог внутри <pathBase>, создаётся при необходимости
     */
    public function __construct(string $path = '')
    {
        $this->path = static::makeDir(
            (static::$uploadRoot ?? Container::getPaths()->getPublic('uf')) . '/' . $this->pathBase . '/' . trim($path, '/')
        );
        $this->name = static::generateName();
    }

    /**
     * Сохраняет загруженный файл запроса
     * @return bool false - файла нет или его расширение запрещено
     */
    public function loadPost(string $field): bool
    {
        $upload = (array)(Container::getRequest()?->file($field) ?? []);
        if (!is_uploaded_file((string)($upload['tmp_name'] ?? ''))) {
            return false;
        }

        $ext = strtolower(pathinfo((string)$upload['name'], PATHINFO_EXTENSION));
        if ($ext === '' || in_array($ext, static::FORBIDDEN_EXTENSIONS, true)) {
            return false;
        }
        if (!copy($upload['tmp_name'], $this->path . $this->name . '.' . $ext)) {
            return false;
        }

        $this->type = $ext;
        return true;
    }

    /**
     * Копирует файл с диска (выбранный в файловом менеджере) под сгенерированным именем
     * @return bool false - файла нет или его расширение запрещено
     */
    public function loadFile(string $filename): bool
    {
        $ext = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
        if (!is_file($filename) || $ext === '' || in_array($ext, static::FORBIDDEN_EXTENSIONS, true)) {
            return false;
        }
        if (!copy($filename, $this->path . $this->name . '.' . $ext)) {
            return false;
        }

        $this->type = $ext;
        return true;
    }

    /**
     * Дописывает файл на диск. Файл сохраняется уже в loadPost(), у изображений - здесь (Image::save())
     */
    public function save(): void
    {
    }

    /**
     * Имя файла с расширением, '' - файл не загружен
     */
    public function getName(): string
    {
        return $this->type !== '' ? $this->name . '.' . $this->type : '';
    }

    /**
     * Удаляет файл каталога по имени с расширением
     */
    public function delete(string $name): bool
    {
        return is_file($this->path . $name) && unlink($this->path . $name);
    }

    /**
     * Создаёт каталог, если его нет
     * @return string Каталог с завершающим слешем
     */
    protected static function makeDir(string $dir): string
    {
        $dir = rtrim(str_replace('//', '/', $dir), '/') . '/';
        if (!is_dir($dir) && !mkdir($dir, 0777, true) && !is_dir($dir)) {
            throw new \RuntimeException("Cannot create directory $dir");
        }

        return $dir;
    }

    protected static function generateName(): string
    {
        [$usec, $sec] = explode(' ', microtime());
        return substr($sec, 2, 7) . substr($usec, 2, 4);
    }
}
