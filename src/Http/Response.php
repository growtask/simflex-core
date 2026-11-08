<?php

namespace Simflex\Core\Http;

abstract class Response implements \Simflex\Core\System\DI\Service
{
    protected int $statusCode = 200;
    protected array $cookies = [];
    protected array $headers = [];

    public function __construct()
    {
    }

    public static function getServiceName(): string
    {
        return 'response';
    }

    /**
     * Задает url редиректа
     * @param string $url URL для редиректа
     */
    public function redirect(string $url): static
    {
        $this->setHeader('Location', $url);
        if ($this->statusCode < 300 || $this->statusCode > 399) {
            $this->setStatusCode(302);
        }

        return $this;
    }

    /**
     * Редирект и завершение
     * @param string $url URL для редиректа
     */
    public function redirectNow(string $url): never
    {
        $this->redirect($url);
        $this->outputHeaders();
        exit;
    }

    /**
     * Устанавливает cookie
     *
     * @param string $name Имя
     * @param string $value Значение
     * @param array $options Параметры
     */
    public function setCookie(string $name, string $value = '', array $options = []): static
    {
        $this->cookies[$name] = [
            'value' => $value,
            'options' => $options,
        ];

        return $this;
    }

    /**
     * Устанавливает заголовок
     *
     * @param string $name Имя
     * @param string $value Значение
     */
    public function setHeader(string $name, string $value): static
    {
        $this->headers[$name] = $value;
        return $this;
    }

    /**
     * Отправляет заголовок с кодом статуса
     * @param int $code Код статуса
     */
    public function setStatusCode(int $code): static
    {
        $this->statusCode = $code;
        return $this;
    }

    /**
     * Устанавливает тип содержимого
     * @param string $contentType Тип содержимого
     */
    public function setContentType(string $contentType): static
    {
        $this->setHeader('Content-Type', $contentType);
        return $this;
    }

    /**
     * Устанавливает заголовок Content-Disposition
     * @param string $fileName Имя файла
     */
    public function setContentDisposition(string $fileName): static
    {
        $this->setHeader('Content-Disposition', 'attachment; filename=' . $fileName);
        return $this;
    }

    /**
     * Вспомогательная функция для отдачи файла
     *
     * @param string $fileName Имя файла
     * @param string $fileContent Содержимое файла
     */
    public function outputFile(string $fileName, string $fileContent): void
    {
        $this->outputHeaders();

        header('Content-Length: ' . strlen($fileContent));
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: ' . $fileName);

        echo $fileContent;
    }

    public function output(): void
    {
        $this->outputHeaders();
        echo $this->makeBody();
    }

    public function outputHeaders(): void
    {
        http_response_code($this->statusCode);

        foreach ($this->cookies as $cookieName => $cookie) {
            setcookie($cookieName, $cookie['value'], $cookie['options']);
        }

        foreach ($this->headers as $header => $value) {
            header($header . ': ' . $value);
        }
    }

    abstract protected function makeBody(): string;
}
