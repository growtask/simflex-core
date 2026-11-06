<?php

namespace Simflex\Core\Http;

use Simflex\Core\Http\Routing\Route;

/**
 * Запрос: параметры GET, POST, cookie, файлы, заголовки и данные сервера. Снимок суперглобальных массивов при
 * создании объекта; код читает запрос только через него (Container::getRequest() или зависимость конструктора),
 * а не через $_GET, $_POST, $_REQUEST, $_SERVER и т.п.
 */
class Request implements \Simflex\Core\System\DI\Service
{
    protected bool $isHttps;
    protected string $host;
    protected string $requestMethod;
    protected array $headers = [];
    protected array $getParams;
    protected array $postParams;
    protected array $reqParams;
    protected array $cookies;
    protected array $files;
    protected string $requestBody;
    protected string $urlPath;
    protected array $urlParts;
    protected array $serverInfo = [];
    public ?Route $route = null;

    public static function getServiceName(): string
    {
        return 'request';
    }

    /**
     * Конструктор Request.
     */
    public function __construct()
    {
        // кешируем значения
        $this->host = (string)($_SERVER['HTTP_HOST'] ?? '');
        $this->isHttps = !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off';
        $this->requestMethod = (string)($_SERVER['REQUEST_METHOD'] ?? 'GET');
        $this->getParams = $_GET;
        $this->postParams = $_POST;
        $this->reqParams = $_REQUEST;
        $this->cookies = $_COOKIE;
        $this->files = $_FILES;
        $this->requestBody = (string)file_get_contents('php://input');

        $this->setServer($_SERVER);
    }

    /**
     * Запрос из заданных данных, без суперглобальных массивов: тесты, внутренние запросы.
     * REQUEST - GET и POST вместе, метод - POST, если есть данные POST
     * @param string $uri Адрес: путь и строка запроса; GET по умолчанию - из строки запроса
     * @param array|null $get Параметры GET
     * @param array $server Данные сервера, заголовки - HTTP_*
     */
    public static function create(
        string $uri = '/',
        ?array $get = null,
        array $post = [],
        array $files = [],
        array $cookies = [],
        array $server = [],
    ): static {
        $request = new \ReflectionClass(static::class)->newInstanceWithoutConstructor();
        if ($get === null) {
            parse_str((string)parse_url($uri, PHP_URL_QUERY), $get);
        }
        $request->getParams = $get;
        $request->postParams = $post;
        $request->reqParams = array_merge($get, $post);
        $request->files = $files;
        $request->cookies = $cookies;
        $request->requestBody = '';
        $server += ['REQUEST_URI' => $uri, 'REQUEST_METHOD' => $post ? 'POST' : 'GET', 'HTTP_HOST' => 'localhost'];
        $request->host = (string)$server['HTTP_HOST'];
        $request->isHttps = !empty($server['HTTPS']) && $server['HTTPS'] !== 'off';
        $request->requestMethod = (string)$server['REQUEST_METHOD'];
        $request->setServer($server);

        return $request;
    }

    /**
     * Данные сервера: заголовки (HTTP_*) и путь (REQUEST_URI)
     */
    protected function setServer(array $server): void
    {
        $this->serverInfo = $server;
        $this->headers = [];
        foreach ($server as $key => $value) {
            if (str_starts_with($key, 'HTTP_')) {
                // превращаем HTTP_X_X в x-x
                $this->headers[strtolower(str_replace('_', '-', substr($key, 5)))] = $value;
            }
        }

        // разбираем и собираем URL
        $this->setPath(parse_url((string)($server['REQUEST_URI'] ?? '/'), PHP_URL_PATH) ?: '/');
    }

    public function setPath(string $path): void
    {
        $this->urlPath = $path;
        $this->urlParts = array_slice(explode('/', $this->urlPath), 1);
    }

    public function getFullUrl(): string
    {
        return ($this->isHttps ? 'https://' : 'http://') . $this->host . $this->urlPath;
    }

    /**
     * Возвращает полный путь URL
     */
    public function getPath(): string
    {
        return $this->urlPath;
    }

    /**
     * Возвращает URL, разобранный на части
     */
    public function getUrlParts(): array
    {
        return $this->urlParts;
    }

    /**
     * Возвращает последнюю часть пути URL
     * @return string  Последняя часть пути URL
     */
    public function getUrlLastPart(): string
    {
        return $this->urlParts[count($this->urlParts) - 2] ?? '/';
    }

    /**
     * Проверяет, что запрос - POST
     */
    public function isPost(): bool
    {
        return $this->requestMethod === 'POST';
    }

    /**
     * Проверяет, что тело запроса - JSON (Content-Type application/json, в том числе с charset)
     */
    public function isJson(): bool
    {
        $type = (string)($this->header('Content-Type') ?? $this->server('CONTENT_TYPE', ''));

        return stripos($type, 'application/json') !== false;
    }

    /**
     * Проверяет, что запрос - AJAX
     */
    public function isAjax(): bool
    {
        return $this->header('X-Requested-With') === 'XMLHttpRequest';
    }

    public function getRequestMethod(): string
    {
        return $this->requestMethod;
    }

    /**
     * Параметры GET
     */
    public function get(int|string|null $k = null, mixed $default = null): mixed
    {
        return $k === null ? $this->getParams : ($this->getParams[$k] ?? $default);
    }

    /**
     * Параметры POST
     */
    public function post(int|string|null $k = null, mixed $default = null): mixed
    {
        return $k === null ? $this->postParams : ($this->postParams[$k] ?? $default);
    }

    /**
     * Параметры REQUEST
     */
    public function request(int|string|null $k = null, mixed $default = null): mixed
    {
        return $k === null ? $this->reqParams : ($this->reqParams[$k] ?? $default);
    }

    /**
     * Входящие cookies
     */
    public function cookie(int|string|null $k = null, mixed $default = null): mixed
    {
        return $k === null ? $this->cookies : ($this->cookies[$k] ?? $default);
    }

    /**
     * Входящие файлы
     */
    public function file(int|string|null $k = null): mixed
    {
        return $k === null ? $this->files : ($this->files[$k] ?? null);
    }

    /**
     * Входящие заголовки
     */
    public function header(?string $k = null): mixed
    {
        return $k ? ($this->headers[strtolower($k)] ?? null) : $this->headers;
    }

    public function isHttps(): bool
    {
        return $this->isHttps;
    }

    public function getHost(): string
    {
        return $this->host;
    }

    public function getServerInfo(): array
    {
        return $this->serverInfo;
    }

    /**
     * Данные сервера ($_SERVER на момент создания запроса), например server('REMOTE_ADDR')
     */
    public function server(?string $k = null, mixed $default = null): mixed
    {
        return $k === null ? $this->serverInfo : ($this->serverInfo[$k] ?? $default);
    }

    /**
     * Адрес запроса: путь и строка запроса, например /catalog/?page=2
     */
    public function getUri(): string
    {
        return (string)$this->server('REQUEST_URI', $this->urlPath);
    }

    /**
     * IP клиента: X-Forwarded-For (за прокси) или REMOTE_ADDR
     */
    public function getIp(): string
    {
        return (string)($this->header('X-Forwarded-For') ?: $this->server('REMOTE_ADDR', ''));
    }

    public function getUserAgent(): string
    {
        return (string)$this->header('User-Agent');
    }

    public function getBody(): string
    {
        return $this->requestBody;
    }

    /**
     * Собирает строку запроса из текущих GET-параметров.
     * @param array $extra Дополнительные параметры
     * @param array $ignore Ключи, которые нужно пропустить
     * @return string Строка запроса
     */
    public function buildQuery(array $extra = [], array $ignore = []): string
    {
        $get = [];
        foreach ($this->getParams as $key => $value) {
            if (!in_array($key, $ignore)) {
                $get[$key] = $value;
            }
        }

        foreach ($extra as $key => $value) {
            $get[$key] = $value;
        }

        return http_build_query($get);
    }
}
