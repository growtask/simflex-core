<?php

namespace Simflex\Core\Models;

use Exception;
use Simflex\Core\System\Buffer;
use Simflex\Core\System\ModelBase;
use Simflex\Core\System\Privilege;

/**
 * Модель пользователя
 *
 * @property int user_id
 * @property int role_id
 * @property bool active
 * @property string login
 * @property string password
 * @property string email
 * @property string name
 * @property string code
 */
class User extends ModelBase
{
    protected static string $table = 'user';
    protected static string $primaryKeyName = 'user_id';

    /**
     * @throws Exception
     */
    protected function offsetGetRole(): ?UserRole
    {
        return UserRole::findOne(['role_id' => $this->role_id]);
    }

    /**
     * @param string $privilege Имя привилегии, см. \Simflex\Core\System\Privilege
     */
    public function ican(string $privilege): bool
    {
        return isset($this->getPrivileges()[$privilege]);
    }

    /**
     * Привилегии роли и личные, объявленные в коде и включённые
     *
     * @return array<string, string> name => name
     */
    public function getPrivileges(): array
    {
        return Buffer::getOrSet('user-privilege-' . $this->id, function () {
            $names = UserRolePrivilege::findAdv()
                ->select('privilege')
                ->where(['role_id' => $this->role_id ? (int)$this->role_id : null])
                ->union(UserPrivilegePersonal::findAdv()->select('privilege')->where(['user_id' => (int)$this->id]))
                ->fetchColumn();
            $names = Privilege::granted(array_map('strval', $names));
            return array_combine($names, $names);
        });
    }

    /**
     * Пользователи, у которых есть любая из привилегий по роли или лично, и разработчики
     *
     * @example User::findAdv()->modify('hasPrivileges', ['privilege_name'])->all()
     */
    public static function aqModifyHasPrivileges(\Simflex\Core\DB\AQ $AQ, array $privileges): void
    {
        if (empty($privileges)) {
            return;
        }
        // у разработчиков есть все привилегии
        $privileges = array_values([...Privilege::filterActive($privileges), Privilege::DEV]);
        // привилегии - параметрами запроса: отдельный набор на каждый подзапрос
        $binds = [];
        $in = [];
        foreach (['personal', 'role'] as $set) {
            foreach ($privileges as $i => $privilege) {
                $binds["has_{$set}_$i"] = $privilege;
            }
            $in[$set] = ':has_' . $set . '_' . implode(", :has_{$set}_", array_keys($privileges));
        }
        $table = static::$table;
        $AQ->where("(
            $table.user_id IN(SELECT user_id FROM user_privilege_personal WHERE user_privilege_personal.privilege IN({$in['personal']}))
            OR $table.role_id IN(
                SELECT role_id FROM user_role_privilege JOIN user_role USING(role_id)
                WHERE user_role.active = 1 AND user_role_privilege.privilege IN({$in['role']})
            )
        )")->bind($binds);
    }
}
