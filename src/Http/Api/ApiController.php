<?php

namespace Simflex\Core\Http\Api;

use Simflex\Core\Http\ControllerBase;
use Simflex\Core\Http\Csrf;
use Simflex\Core\Http\Request;
use Simflex\Core\Http\Response;

/**
 * Контроллер JSON API. Действия объявляются атрибутом Action и возвращают данные (массив, список, скаляр,
 * модель с toArray()), контроллер отдаёт их в JsonEnvelopeResponse. ApiException и прочие исключения превращаются
 * в JSON-ошибку со статусом, действие не найдено - 404 (fallback()).
 *
 * Параметры метода действия берутся по имени: из переменных пути (:id), затем из тела JSON, затем из GET и POST;
 * значение приводится к типу параметра (int, float, bool, string, array), не заданный обязательный параметр
 * или значение неподходящего типа - 400. Параметры типа Request, JsonRequest, Response подставляются
 * текущими объектами. Адрес - обычный маршрут в provider/routes.php
 */
class ApiController extends ControllerBase
{
    protected JsonRequest $jsonRequest;
    protected JsonEnvelopeResponse $envelope;

    public function __construct(Request $request, Response $response)
    {
        if (!$request instanceof JsonRequest) {
            $jsonRequest = new JsonRequest();
            $jsonRequest->route = $request->route;
            $request = $jsonRequest;
        }
        $this->jsonRequest = $request;
        $this->envelope = $response instanceof JsonEnvelopeResponse ? $response : new JsonEnvelopeResponse();

        parent::__construct($request, $this->envelope);
    }

    /**
     * Подбирает и вызывает действие, результат - ответ (с ошибкой, если действие бросило исключение).
     * Ответ - $this->response: заголовки и cookie, заданные действием, уходят вместе с данными
     */
    public function handle(): JsonEnvelopeResponse
    {
        $response = $this->envelope;
        try {
            $this->checkForgery();
            $matcher = $this->resolve();
            if (!$matcher) {
                $this->fallback();
            }
            $response->setData($this->invokeAction($matcher));
        } catch (\Throwable $ex) {
            $response->setError($ex);
        }

        return $response;
    }

    /**
     * Защита от подделки запроса: изменяющий запрос (не GET, HEAD, OPTIONS) принимается только с телом JSON
     * (с чужого сайта браузер не отправит его без CORS preflight) или с CSRF-токеном (обычная форма с сессией)
     *
     * @throws ApiException 403, если запрос не JSON и без верного токена
     */
    protected function checkForgery(): void
    {
        $method = strtoupper($this->jsonRequest->getRequestMethod());
        if (!in_array($method, ['GET', 'HEAD', 'OPTIONS'], true)) {
            Csrf::checkMutation($this->jsonRequest);
        }
    }

    /**
     * Действие не найдено
     *
     * @throws ApiException
     */
    protected function fallback(): never
    {
        throw ApiException::notFound('Метод API не найден');
    }

    /**
     * Отправляет ответ и завершает работу
     */
    protected function content(): never
    {
        $this->handle()->send();
    }

    /**
     * @param array<string, string> $vars
     * @return array<int, mixed>
     * @throws ApiException
     */
    protected function resolveArguments(\ReflectionMethod $method, array $vars): array
    {
        $json = $this->jsonRequest->isJson() ? $this->jsonRequest->json() : [];
        $query = $this->jsonRequest->request();

        $arguments = [];
        foreach ($method->getParameters() as $param) {
            $type = $param->getType();
            $typeName = $type instanceof \ReflectionNamedType ? $type->getName() : null;

            if ($typeName !== null && is_a($typeName, Request::class, true)) {
                $arguments[] = $this->jsonRequest;
                continue;
            }
            if ($typeName !== null && is_a($typeName, Response::class, true)) {
                $arguments[] = $this->response;
                continue;
            }

            $name = $param->getName();
            foreach ([$vars, $json, $query] as $source) {
                if (array_key_exists($name, $source)) {
                    $arguments[] = $this->cast($source[$name], $typeName, $param);
                    continue 2;
                }
            }

            if ($param->isDefaultValueAvailable()) {
                $arguments[] = $param->getDefaultValue();
            } elseif ($param->allowsNull() && $type !== null) {
                $arguments[] = null;
            } else {
                throw ApiException::badRequest("Не задан параметр $name");
            }
        }

        return $arguments;
    }

    /**
     * Приводит значение параметра к типу параметра метода
     *
     * @throws ApiException Если значение не приводится к типу
     */
    protected function cast(mixed $value, ?string $type, \ReflectionParameter $param): mixed
    {
        $error = ApiException::badRequest('Параметр ' . $param->getName() . ' неверного типа');
        if ($value === null) {
            if ($param->allowsNull()) {
                return null;
            }
            throw $error;
        }

        switch ($type) {
            case 'int':
                if (is_int($value) || (is_string($value) && preg_match('/^-?\d+$/', trim($value)))) {
                    return (int)$value;
                }
                if (is_float($value) && floor($value) === $value) {
                    return (int)$value;
                }
                throw $error;
            case 'float':
                if (is_int($value) || is_float($value) || (is_string($value) && is_numeric($value))) {
                    return (float)$value;
                }
                throw $error;
            case 'bool':
                $bool = filter_var($value, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
                if ($bool === null) {
                    throw $error;
                }
                return $bool;
            case 'string':
                if (is_scalar($value)) {
                    return (string)$value;
                }
                throw $error;
            case 'array':
                if (is_array($value)) {
                    return $value;
                }
                throw $error;
            default:
                return $value;
        }
    }
}
