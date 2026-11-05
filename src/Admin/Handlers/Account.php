<?php

namespace Simflex\Core\Admin\Handlers;

use Simflex\Core\Admin\Page;
use Simflex\Core\Extensions\Alert\Alert;
use Simflex\Core\Admin\Handler;
use Simflex\Core\System\Container;
use Simflex\Core\Models\User as UserModel;

/**
 * Учётная запись текущего пользователя: имя, email и пароль. Не табличный раздел
 */
class Account extends Handler
{
    public function content(): string
    {
        $user = Container::getUser();
        if (!$user) {
            return '';
        }

        if ($this->request->post('email') !== null && $this->request->post('name') !== null) {
            $path = Page::get()->getPath();
            [$isSaved, $message] = $this->save(
                (int)$user->getId(),
                (string)$this->request->post('email'),
                (string)$this->request->post('name'),
                (string)$this->request->post('password'),
            );
            if ($isSaved) {
                Alert::success($message, $path);
            } else {
                Alert::error($message, $path);
            }
        }

        $data = [
            'role_name' => $user->role?->name ?? '',
            'login' => $user->login,
            'name' => $user->name,
            'email' => $user->email,
        ];
        return $this->render(__DIR__ . '/tpl/account.tpl', ['data' => $data]);
    }

    /**
     * Сохраняет профиль. Пустой e-mail хранится как NULL (у нескольких пользователей он может быть не задан);
     * e-mail другого пользователя и ошибка БД не роняют страницу, а возвращаются сообщением.
     *
     * @return array{bool, string} Успех и сообщение для пользователя
     */
    protected function save(int $userId, string $email, string $name, string $password): array
    {
        $email = trim($email);
        $owner = $email !== '' ? UserModel::findOne(['email' => $email]) : null;
        if ($owner && (int)$owner->getId() !== $userId) {
            return [false, 'Этот e-mail уже используется'];
        }
        $set = ['email' => $email === '' ? null : $email, 'name' => $name];
        if ($password !== '') {
            $set['password'] = md5($password);
        }
        try {
            $isSaved = UserModel::bulkUpdate($set, ['user_id' => $userId]);
        } catch (\PDOException $exception) {
            // пользователю — общее сообщение, причина — в журнал PHP
            error_log('Account: профиль ' . $userId . ' не сохранён: ' . $exception->getMessage());
            $isSaved = false;
        }
        return $isSaved ? [true, 'Данные успешно обновлены'] : [false, 'Данные не обновлены'];
    }
}
