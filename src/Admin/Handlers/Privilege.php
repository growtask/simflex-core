<?php

namespace Simflex\Core\Admin\Handlers;

use Simflex\Core\Admin\Handler;
use Simflex\Core\Http\Api\ApiException;
use Simflex\Core\Http\Api\JsonEnvelopeResponse;
use Simflex\Core\System\Privilege as PrivilegeRegistry;
use Simflex\Core\System\Settings as SiteSettings;

/**
 * Привилегии объявлены в коде (\Simflex\Core\System\Privilege и подкласс приложения): раздел выводит их список
 * и переключает их активность, которая хранится в необязательной таблице user_privilege. Не табличный раздел:
 * только список и переключатель
 */
class Privilege extends Handler
{
    public function content(): string
    {
        return match ($this->request->get('action', '')) {
            '' => $this->show(),
            'switch' => $this->switchActive(),
            default => (string)SiteSettings::get('error404'),
        };
    }

    public function show(): string
    {
        $rows = [];
        foreach (PrivilegeRegistry::getAll() as $name => $params) {
            $rows[] = [
                'name' => $name,
                'title' => $params->title,
                'active' => PrivilegeRegistry::isActive($name),
                'switchable' => $params->switchable,
            ];
        }

        return $this->render(__DIR__ . '/tpl/privileges.tpl', ['rows' => $rows]);
    }

    /**
     * Задаёт активность привилегии: POST name, active (1/0). Ответ - конверт JSON API: active - активность
     * после изменения; непринятое изменение - ошибка 400
     */
    protected function switchActive(): never
    {
        $response = new JsonEnvelopeResponse();
        $name = (string)($this->request->post('name', ''));
        if ($this->request->isPost() && PrivilegeRegistry::setActive($name, !empty($this->request->post('active')))) {
            $response->setData(['active' => PrivilegeRegistry::isActive($name)]);
        } else {
            $response->setError(ApiException::badRequest('Не удалось изменить привилегию'));
        }

        $response->send();
    }
}
