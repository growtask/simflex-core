<?php

namespace Simflex\Core\Http\Api;

use Simflex\Core\Logger\Log;
use Simflex\Core\System\Errors\ErrorCodes;

/**
 * Ответ JSON с «конвертом»: {"error": {"code": 0, "message": ""}, ...данные}.
 * Ассоциативный массив даёт ключи рядом с error, список - ключ items, скаляр и null - ключ result.
 * Ошибка - HTTP-статус 4xx/5xx и error.code/error.message (у ошибки полей - ещё error.errors)
 */
class JsonEnvelopeResponse extends JsonResponse
{
    protected int $errorCode = 0;
    protected string $errorMessage = '';
    /** @var array<string, string> */
    protected array $errors = [];
    /** @var array<int|string, mixed> */
    protected array $fields = [];

    /**
     * @param mixed $data Ассоциативный массив, список, скаляр, null, JsonSerializable, объект с toArray()
     *        или Throwable (как setError())
     * @throws \InvalidArgumentException Если тип данных не поддерживается или в данных есть ключ error
     */
    public function setData(mixed $data): static
    {
        if ($data instanceof \Throwable) {
            return $this->setError($data);
        }

        if (is_object($data) && $data instanceof \JsonSerializable) {
            $data = $data->jsonSerialize();
        } elseif (is_object($data)) {
            if (!method_exists($data, 'toArray')) {
                throw new \InvalidArgumentException('Неподдерживаемый тип данных ответа: ' . $data::class);
            }
            $data = $data->toArray();
        }

        if ($data === null || is_scalar($data)) {
            $this->fields = ['result' => $data];
        } elseif (is_array($data)) {
            if (array_key_exists('error', $data)) {
                throw new \InvalidArgumentException('Данные ответа не могут содержать ключ error');
            }
            $this->fields = $data && array_is_list($data) ? ['items' => $data] : $data;
        } else {
            throw new \InvalidArgumentException('Неподдерживаемый тип данных ответа');
        }

        return $this;
    }

    /**
     * Добавляет ключ к данным ответа
     */
    public function set(int|string $key, mixed $value): static
    {
        if ($key === 'error') {
            throw new \InvalidArgumentException('Данные ответа не могут содержать ключ error');
        }
        $this->fields[$key] = $value;
        return $this;
    }

    /**
     * Ошибка из исключения. ApiException - статус, код, текст и ошибки полей из исключения; прочие исключения -
     * статус 500 и общий текст, само исключение пишется в журнал. Статус, уже заданный setStatusCode(), не меняется
     */
    public function setError(\Throwable $ex): static
    {
        if ($ex instanceof ApiException) {
            $this->applyError($ex->getHttpStatus(), $ex->getCode(), $ex->getMessage(), $ex->getErrors());
            return $this;
        }

        Log::error(sprintf(
            'Ошибка API: %s (%s в %s:%d)',
            $ex->getMessage(),
            $ex::class,
            $ex->getFile(),
            $ex->getLine()
        ));
        $this->applyError(
            500,
            ErrorCodes::APP_INTERNAL_ERROR,
            ErrorCodes::getText(ErrorCodes::APP_INTERNAL_ERROR)
        );
        return $this;
    }

    /**
     * Ошибка без исключения
     *
     * @param int $code Код ошибки; 0 - равен HTTP-статусу
     */
    public function setErrorMessage(string $message, int $httpStatus = 400, int $code = 0): static
    {
        $this->applyError($httpStatus, $code ?: $httpStatus, $message);
        return $this;
    }

    /**
     * @param array<string, string> $errors
     */
    protected function applyError(int $httpStatus, int $code, string $message, array $errors = []): void
    {
        if ($this->statusCode === 200) {
            $this->statusCode = $httpStatus;
        }
        $this->errorCode = $code;
        $this->errorMessage = $message;
        $this->errors = $errors;
    }

    /**
     * Массив ответа: error и данные
     *
     * @return array<int|string, mixed>
     */
    public function toArray(): array
    {
        $error = ['code' => $this->errorCode, 'message' => $this->errorMessage];
        if ($this->errors) {
            $error['errors'] = $this->errors;
        }

        return ['error' => $error] + $this->fields;
    }

    protected function makeBody(): string
    {
        return json_encode($this->toArray(), JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
    }
}
