<?php

namespace Simflex\Core\System\Errors;

class ErrorCodes
{
    /** @var int Дефолтная ошибка приложения */
    public const APP_INTERNAL_ERROR = 1000;

    /** @var int Не авторизован */
    public const APP_UNAUTHORIZED = 1004;

    public const BASIC_ERROR_MESSAGES = [
        self::APP_INTERNAL_ERROR => 'Внутренняя ошибка, повторите позже',
        self::APP_UNAUTHORIZED => 'Unauthorized',
    ];

    public const BASIC_ERROR_HTTP_CODES = [
        self::APP_UNAUTHORIZED => 403,
    ];

    public const ERROR_MESSAGES = [];
    public const ERROR_HTTP_CODES = [];

    /**
     * @param array $params Дополнительные необязательные параметры, например, для кастомизации текста ошибки.
     * Например текст ошибки "Required parameter {param}", тогда можно подставить через параметры значение:
     * ['param' => 'My awesome param']
     */
    public static function getText(int $code, bool $withCode = false, array $params = []): string
    {
        $text = static::ERROR_MESSAGES[$code] ?? static::BASIC_ERROR_MESSAGES[$code] ?? '';

        if ($params) {
            $paramsPrepared = [];
            foreach ($params as $key => $value) {
                $paramsPrepared['{' . $key . '}'] = $value;
            }

            $text = strtr($text, $paramsPrepared);
        }

        return $text ? (new Error($text, $code))->toString($withCode) : '';
    }

    /**
     * Возвращает HTTP-код статуса для кода ошибки или null, если подходит код по умолчанию
     * @param int $code Код ошибки
     * @return int|null HTTP-код статуса ответа
     */
    public static function getHttpStatusCode(int $code): ?int
    {
        return static::BASIC_ERROR_HTTP_CODES[$code] ?? static::ERROR_HTTP_CODES[$code] ?? null;
    }
}
