<?php

namespace Simflex\Core\Http\Api;

/**
 * Ошибка JSON API, текст которой показывается клиенту: HTTP-статус, код и сообщение попадают в ответ
 * (JsonEnvelopeResponse). Прочие исключения клиенту не показываются: ответ 500 с общим текстом.
 */
class ApiException extends \RuntimeException
{
    /**
     * @param string $message Текст для клиента
     * @param int $httpStatus HTTP-статус ответа
     * @param int $code Код ошибки в ответе; 0 - равен HTTP-статусу
     * @param array<string, string> $errors Ошибки полей: поле => текст
     */
    public function __construct(
        string $message,
        protected int $httpStatus = 400,
        int $code = 0,
        ?\Throwable $previous = null,
        protected array $errors = [],
    ) {
        parent::__construct($message, $code ?: $httpStatus, $previous);
    }

    public function getHttpStatus(): int
    {
        return $this->httpStatus;
    }

    /**
     * @return array<string, string> Ошибки полей: поле => текст
     */
    public function getErrors(): array
    {
        return $this->errors;
    }

    public static function badRequest(string $message = 'Неверный запрос'): static
    {
        return new static($message, 400);
    }

    public static function unauthorized(string $message = 'Требуется авторизация'): static
    {
        return new static($message, 401);
    }

    public static function forbidden(string $message = 'Доступ запрещён'): static
    {
        return new static($message, 403);
    }

    public static function notFound(string $message = 'Не найдено'): static
    {
        return new static($message, 404);
    }

    /**
     * @param array<string, string> $errors Ошибки полей: поле => текст
     */
    public static function unprocessable(string $message, array $errors = []): static
    {
        return new static($message, 422, 0, null, $errors);
    }
}
