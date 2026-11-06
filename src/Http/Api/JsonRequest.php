<?php

namespace Simflex\Core\Http\Api;

use Simflex\Core\Http\Request;

class JsonRequest extends Request
{
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Запрос с телом JSON из заданных данных, без суперглобальных массивов: тесты, внутренние запросы
     *
     * @param array<mixed> $json Тело запроса
     * @param array<string, mixed> $server Данные сервера, заголовки - HTTP_*
     */
    public static function createJson(string $uri, array $json, string $method = 'POST', array $server = []): static
    {
        $request = static::create($uri, null, [], [], [], $server + [
            'REQUEST_METHOD' => $method,
            'HTTP_CONTENT_TYPE' => 'application/json',
        ]);
        $request->requestBody = json_encode($json, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);

        return $request;
    }

    /**
     * Возвращает JSON в виде массива
     */
    public function json(): array
    {
        $json = json_decode($this->requestBody, true);

        return is_array($json) ? $json : [];
    }
}
