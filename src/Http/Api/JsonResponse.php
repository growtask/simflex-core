<?php

namespace Simflex\Core\Http\Api;

use Simflex\Core\Http\Response;

/**
 * Ответ JSON без предустановленной структуры: тело - ровно то, что передано в setData()
 * (массив, список, скаляр, null, JsonSerializable или объект с toArray()).
 * Ответ со структурой error и данными - JsonEnvelopeResponse
 */
class JsonResponse extends Response
{
    protected mixed $data = null;

    public function __construct()
    {
        parent::__construct();
        $this->setContentType('application/json; charset=utf-8');
    }

    /**
     * @param mixed $data Массив, скаляр, null, JsonSerializable или объект с toArray()
     * @throws \InvalidArgumentException Если тип данных не поддерживается
     */
    public function setData(mixed $data): static
    {
        if (is_object($data) && !$data instanceof \JsonSerializable) {
            if (!method_exists($data, 'toArray')) {
                throw new \InvalidArgumentException('Неподдерживаемый тип данных ответа: ' . $data::class);
            }
            $data = $data->toArray();
        } elseif (is_resource($data)) {
            throw new \InvalidArgumentException('Неподдерживаемый тип данных ответа: resource');
        }

        $this->data = $data;
        return $this;
    }

    /**
     * Тело ответа
     */
    public function getBody(): string
    {
        return $this->makeBody();
    }

    protected function makeBody(): string
    {
        return json_encode($this->data, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
    }

    /**
     * Выводит ответ и завершает работу
     */
    public function send(): never
    {
        $this->output();
        exit;
    }
}
