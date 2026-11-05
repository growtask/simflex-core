<?php

namespace Simflex\Core\Admin\Table;

use Simflex\Core\Admin\Fields\FieldMultiKey;
use Simflex\Core\Admin\Fields\FieldAlias;
use Simflex\Core\Admin\Fields\FieldDateTime;
use Simflex\Core\Admin\Fields\FieldFile;
use Simflex\Core\Admin\Fields\FieldImage;
use Simflex\Core\Admin\Fields\FieldPassword;
use Simflex\Core\Admin\Fields\FieldPath;
use Simflex\Core\Admin\Fields\FieldString;
use Simflex\Core\Admin\Fields\FieldVirtual;
use Simflex\Core\Admin\Fields\Helper;
use Simflex\Core\Admin\Page;
use Simflex\Core\Admin\Handler;
use Simflex\Core\Extensions\Alert\Alert;
use Simflex\Core\Admin\Plugins\Pagination\Pagination;
use Simflex\Core\System\Container;
use Simflex\Core\DB\DB;
use Simflex\Core\DB\AQ;
use Simflex\Core\DB\Expr;
use Simflex\Core\DB\ExprOr;
use Simflex\Core\Admin\Fields\Field;
use Simflex\Core\Admin\Fields\FieldInt;
use Simflex\Core\Media\File;
use Simflex\Core\Media\Image;
use Simflex\Core\System\ModelBase;
use Simflex\Core\System\Privilege;
use Simflex\Core\Helpers\Tree;
use Simflex\Core\Helpers\Time;
use Simflex\Core\System\Session;
use Simflex\Core\System\Settings;

/**
 * Табличный раздел: список и форма записей таблицы БД. Подкласс объявляет таблицу:
 * $model, getFields(), при необходимости getParams() и статические свойства ниже, и может менять поведение
 */
abstract class Table extends Handler
{
    /** @var class-string<ModelBase> Модель таблицы: имя таблицы, первичный ключ, запросы раздела. Обязательно */
    protected static string $model;

    /** Колонка сортировки списка, пока пользователь не выбрал другую. Null — первичный ключ */
    protected static ?string $defaultOrderBy = null;

    protected static bool $defaultOrderDesc = false;

    /** Имена привилегий (\Simflex\Core\System\Privilege) для добавления, изменения, удаления записей. Null — любой админ */
    protected static ?string $privilegeAdd = null;
    protected static ?string $privilegeEdit = null;
    protected static ?string $privilegeDelete = null;

    /** Записей на странице списка. Дерево (таблица с родителем) показывается на одной странице до 200 записей */
    protected static int $perPage = 20;

    /**
     * Каталог файлов, загружаемых в колонки image/file полей-таблиц (FieldTable, FieldVirtualTable), см.
     * uploadTableFile(): изображения — в /uf/images/<каталог>/, остальное — в /uf/files/<каталог>/.
     * Пусто — имя таблицы раздела
     */
    protected static string $uploadDir = '';

    /** @var string[] расширения изображений, которые можно загрузить в поле-таблицу */
    protected static array $uploadImageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'avif', 'svg'];

    /** @var string[] расширения остальных файлов, которые можно загрузить в поле-таблицу */
    protected static array $uploadFileExtensions = [
        'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'odt', 'ods', 'rtf', 'txt', 'csv', 'zip', 'rar', '7z',
        'mp4', 'webm',
    ];

    /** Имя таблицы, из модели */
    protected string $table {
        get => static::getTableName();
    }
    /** @var array<string, Field> поля по имени */
    protected array $fields = [];
    /** @var array<string, Field> поля внешних ключей по имени */
    protected array $fks = [];
    protected ?FieldInt $pk = null;
    /** Родитель записи в той же таблице: список показывается деревом */
    protected ?FieldInt $pid = null;
    protected bool $isHierarchy = false;
    protected array $params = ['left' => [], 'right' => []];
    protected array $errors = [];
    /** По какому-то полю есть фильтр (FieldDefinition::$filter): список показывает панель фильтров */
    protected bool $isFilter = false;
    protected array $actionHandlers = [
        '' => ['method' => 'show'],
        'form' => ['method' => 'form'],
        'save' => ['method' => 'save'],
        'delete' => ['method' => 'delete'],
        'validate' => ['method' => 'validate'],
        'change_enum' => ['method' => 'changeENUM'],
        'change_npp' => ['method' => 'changeNPP'],
        'delete_field' => ['method' => 'deleteField'],
        'upload_img' => ['method' => 'uploadImg'],
        'upload_file' => ['method' => 'uploadFile'],
        'upload_table_file' => ['method' => 'uploadTableFile'],
        'showDetail' => ['method' => 'showDetail'],
        'searchTags' => ['method' => 'searchTags'],
    ];
    /** Запрос показываемого списка, для полей со связанными записями его записей (FieldMultiKey) */
    public static ?AQ $currentQuery = null;
    protected bool $canAdd = false;
    protected bool $canCopy = false;
    protected bool $canEdit = false;
    protected bool $canEditGroup = false;
    protected bool $canDelete = false;
    public bool $selectAll = false;
    public array $selectAdditional = [];
    /**
     * HTML, который раздел добавляет в форму под полями: в левую (основную) колонку и в правую.
     * Непустой $extraRight показывает правую колонку даже без полей в ней. Задаётся, например, в form()
     * до parent::form()
     */
    public string $extraLeft = '';
    public string $extraRight = '';

    /**
     *
     * @var string ID записей при групповом редактировании (через запятую)
     */
    public string $ids;

    public function __construct()
    {
        parent::__construct();
        $this->ids = (string)$this->request->get('ids', '');
        if ($this->request->post('group_ids') !== null) {
            $this->ids = (string)$this->request->post('group_ids');
        }

        // фильтруем это
        $this->ids = implode(',', array_filter(array_map(fn($val) => intval($val), explode(',', $this->ids))));

        $this->canAdd = static::allowed(static::$privilegeAdd);
        $this->canCopy = $this->canAdd;
        $this->canEdit = static::allowed(static::$privilegeEdit);
        $this->canEditGroup = $this->canEdit;
        $this->canDelete = static::allowed(static::$privilegeDelete);
    }

    /**
     * У текущего пользователя есть привилегия, нужная для действия, см. $privilegeAdd и остальные
     */
    protected static function allowed(?string $privilege): bool
    {
        return !$privilege || (Container::getUser()?->ican($privilege) ?? false);
    }

    /**
     * @return class-string<ModelBase>
     */
    public static function getModel(): string
    {
        if (!isset(static::$model)) {
            throw new \LogicException(static::class . ': declare the model of the table, protected static string $model');
        }

        return static::$model;
    }

    /**
     * Поля списка и формы, по порядку
     *
     * @return FieldDefinition[]
     */
    abstract public static function getFields(): array;

    /**
     * Параметры боковых панелей формы, хранятся сериализованными в колонке params
     *
     * @return ParamDefinition[]
     */
    public static function getParams(): array
    {
        return [];
    }

    public static function getTableName(): string
    {
        return static::getModel()::getTableName();
    }

    /**
     * Поля в виде записей, из которых создаются поля админки
     */
    public static function getFieldRows(): array
    {
        return array_map(fn(FieldDefinition $field) => Repository::toFieldRow($field, static::getTableName()), static::getFields());
    }

    public static function getFieldRow(string $name): array
    {
        foreach (static::getFieldRows() as $row) {
            if ($row['name'] === $name) {
                return $row;
            }
        }

        return [];
    }

    /**
     * Параметры в виде записей, из которых создаются поля админки
     *
     * @return array<string, array<string, array>> param_pid => param_id => запись
     */
    public static function getParamRows(): array
    {
        $out = [];
        foreach (static::getParams() as $param) {
            $row = Repository::toParamRow($param, static::getTableName());
            $out[(string)$row['param_pid']][(string)$row['param_id']] = $row;
        }

        return $out;
    }

    /**
     * Запрос записей таблицы в виде массивов, через модель
     */
    protected function getQuery(): AQ
    {
        return static::getModel()::findAdv()->asArray();
    }

    protected function deleteField(): string
    {
        $fieldName = (string)$this->request->get('field_name');
        $keyName = $this->pk->name;
        $keyValue = (int)$this->request->request($keyName);
        $where = [$keyName => $keyValue];
        if (!isset($this->fields[$fieldName])) {
            // поле из параметров
            $data = $this->getQuery()->select('params')->where($where)->fetchOne();
            if (!$data) {
                return json_encode(['success' => false]);
            }

            $data = unserialize($data['params']) ?: [];
            $data[$fieldName] = '';
            $data = serialize($data);

            static::getModel()::bulkUpdate(['params' => $data], $where);
            return json_encode(['success' => true, 'd' => $data, 't' => $this->table, 'k' => $keyName, 'v' => $keyValue]);
        }
        $field = $this->fields[$fieldName];
        $row = $this->getQuery()->select(DB::wrapName($field->name))->where($where)->fetchOne();
        $success = $field->delete($row[$field->name] ?? '');
        if ($success) {
            $success = static::getModel()::bulkUpdate([$field->name => ''], $where);
        }
        return json_encode(['success' => !!$success]);
    }

    /**
     * Ajax: сохраняет изображение (файл img запроса) в /uf/images/<path>/, возвращает имя файла (пустое — не принято).
     * Нужно право добавлять или менять записи; path — только буквы, цифры, «_», «-» и «/»
     */
    public function uploadImg(): never
    {
        $path = $this->getUploadPath((string)($this->request->request('path', '')));
        if (!($this->canAdd || $this->canEdit) || $path === null) {
            die('');
        }

        $img = new Image($path);
        // source — файл из файлового менеджера (адрес в /uf), иначе — загруженный файл img
        $source = $this->getLibrarySource();
        $source !== null ? $img->load($source) : $img->loadPost('img');
        $name = $img->getName();
        $img->save();

        die($name);
    }

    /**
     * Ajax: сохраняет файл (файл file запроса) в /uf/files/, возвращает имя файла (пустое — не принято).
     * Нужно право добавлять или менять записи; расширения — $uploadImageExtensions и $uploadFileExtensions
     */
    public function uploadFile(): never
    {
        $source = $this->getLibrarySource();
        $fileName = $source ?? (string)($this->request->file('file')['name'] ?? '');
        $ext = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));
        $allowed = array_merge(static::$uploadImageExtensions, static::$uploadFileExtensions);
        if (!($this->canAdd || $this->canEdit) || !in_array($ext, $allowed, true)) {
            die('');
        }

        $f = new File();
        $source !== null ? $f->loadFile($source) : $f->loadPost('file');
        $name = $f->getName();
        $f->save();

        die($name);
    }

    /**
     * Файл из файлового менеджера (параметр source — адрес вида /uf/images/a.png): путь на диске, если файл лежит
     * в каталоге загрузок; null — параметра нет или файл вне /uf
     */
    protected function getLibrarySource(): ?string
    {
        $source = (string)$this->request->request('source', '');
        if ($source === '') {
            return null;
        }
        $root = realpath(Container::getPaths()->getPublic('uf'));
        $path = realpath(Container::getPaths()->getPublic(ltrim(rawurldecode($source), '/')));
        if ($root === false || $path === false || !is_file($path) || !str_starts_with($path, $root . DIRECTORY_SEPARATOR)) {
            return null;
        }

        return $path;
    }

    /**
     * Подкаталог загрузки из запроса: null, если в нём есть «..» или недопустимые символы
     */
    protected function getUploadPath(string $path): ?string
    {
        $path = trim($path, '/');
        if (str_contains($path, '..') || !preg_match('@^[A-Za-z0-9_/-]*$@', $path)) {
            return null;
        }

        return $path === '' ? '' : $path . '/';
    }

    /**
     * Ajax: сохраняет файл (файл file запроса), загруженный в колонку image/file поля-таблицы (FieldTable,
     * FieldVirtualTable), возвращает его адрес. Принимаются файлы с расширениями из $uploadImageExtensions
     * (в /uf/images/<$uploadDir>/) и $uploadFileExtensions (в /uf/files/<$uploadDir>/), имя файла — случайное.
     * Пустая строка — файл не принят: нет прав на добавление и изменение записей, ошибка загрузки, другое расширение
     */
    public function uploadTableFile(): string
    {
        $file = $this->request->file('file');
        if (!($this->canAdd || $this->canEdit) || !is_array($file) || ($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
            return '';
        }

        $ext = strtolower(pathinfo((string)$file['name'], PATHINFO_EXTENSION));
        if (in_array($ext, static::$uploadImageExtensions, true)) {
            $type = 'images';
        } elseif (in_array($ext, static::$uploadFileExtensions, true)) {
            $type = 'files';
        } else {
            return '';
        }

        $dir = '/uf/' . $type . '/' . trim(static::$uploadDir ?: $this->table, '/') . '/';
        $path = Container::getPaths()->getPublic($dir);
        if (!is_dir($path) && !mkdir($path, 0777, true) && !is_dir($path)) {
            return '';
        }

        $name = bin2hex(random_bytes(8)) . '.' . $ext;
        if (!move_uploaded_file($file['tmp_name'], $path . $name)) {
            return '';
        }

        return $dir . $name;
    }

    public function searchTags(): never
    {
        /** @var Field $field */
        $field = $this->fields[$this->request->request('name')];

        $name = $field->params['name'];
        $rows = $this->getQuery()
            ->select([DB::wrapName($this->pk->name), DB::wrapName($name)])
            ->where(DB::wrapName($name) . ' LIKE :text')
            ->bind(['text' => '%' . $this->request->request('text') . '%'])
            ->limit(50)
            ->all();

        $out = [];
        foreach ($rows as $r) {
            $out[] = ['id' => $r[$this->pk->name], 'name' => $r[$name]];
        }

        exit(json_encode($out, JSON_UNESCAPED_UNICODE));
    }

    /**
     * Содержимое раздела: результат запрошенного действия. Действия возвращают HTML
     * (или JSON для ajax-запросов)
     */
    public function content(): string
    {
        $this->initTable();

        $action = $this->request->get('action', '');

        if ($action === 'save') {
            // запись, её связи и то, что дописывают наследники в save(), сохраняются вместе или не сохраняются
            if ($keyValue = DB::transaction(fn() => $this->save())) {
                if ($this->request->request('submit_apply') !== null) {
                    $href = Page::get()->getPath() . '?action=form&' . $this->pk->name . '=' . $keyValue;
                    header('location: ' . $href);
                } elseif ($this->request->request('submit_save_add') !== null) {
                    header('location: ' . Page::get()->getPath() . '?action=form');
                } else {
                    header('location: ' . Page::get()->getPath() . "?save_id=$keyValue");
                }
                exit();
            }
            // не сохранено: снова форма, с ошибками
            return $this->form();
        }

        $method = isset($this->actionHandlers[$action]) ? $this->actionHandlers[$action]['method'] : $action;
        if (!method_exists($this, $method)) {
            return (string)Settings::get('error404');
        }
        $out = $this->$method();
        return is_string($out) ? $out : '';
    }

    protected function beforeChangeENUM(Field $field, $row, $newValue): mixed
    {
        if (!$this->canEdit) {
            Alert::error('В этом разделе запрещено редактировать записи', Page::get()->getPath());
        }
        if ($field->readonly) {
            Alert::error("Поле <b>{$field->label}</b> только для чтения!", Page::get()->getPath());
        }
        return $newValue;
    }

    protected function afterChangeENUM(Field $field, $row, $newValue, $success): void
    {
    }

    protected function changeENUM(bool $withRedirect = true): void
    {
        $fieldName = $this->request->request('field');
        $newValue = $this->request->request('newstatus');
        $field = $this->fields[$fieldName] ?? null;
        if (!$field) {
            Alert::error('Некорректный запрос. Поле не найдено.', Page::get()->getPath());
        }

        $where = [$this->pk->name => (int)$this->request->request($this->pk->name)];
        $row = $this->getQuery()->where($where)->fetchOne();

        $newValue = $this->beforeChangeENUM($field, $row, $newValue);

        $success = static::getModel()::bulkUpdate([$field->name => $newValue ?: null], $where);

        $this->afterChangeENUM($field, $row, $newValue, $success);

        if ($withRedirect) {
            exit(json_encode(['success' => true]));
        }
    }

    protected function changeNPP(): never
    {
        $field = (string)$this->request->request('field');
        if (!isset($this->fields[$field])) {
            Alert::error('Некорректный запрос. Поле не найдено.', Page::get()->getPath());
        }

        $fieldDB = static::getFieldRow($field);
        $fieldParams = $fieldDB['params'] ?? [];
        if (@$fieldParams['main']['readonly']) {
            Alert::error("Поле <b>{$fieldDB['label']}</b> только для чтения!", Page::get()->getPath());
        }

        $where = [$this->pk->name => (int)$this->request->request($this->pk->name)];
        if ($this->request->get('val') !== null) {
            $value = (int)$this->request->get('val');
        } else {
            $value = (int)$this->getQuery()->select(DB::wrapName($field))->where($where)->fetchScalar();
            $value += $this->request->get('up') !== null ? -1 : 1;
        }
        static::getModel()::bulkUpdate([$field => $value], $where);

        header('location: ' . Page::get()->getPath());
        exit;
    }

    /**
     * Колонка для SQL: `table`.`column`
     */
    protected function wrapColumn(string $column): string
    {
        return implode('.', array_map(fn(string $part) => DB::wrapName($part), explode('.', $column)));
    }

    /**
     * Записи, которые пользователь может видеть и менять: не разработчик — только записи своих привилегий
     * (колонка привилегии) и ролей этих привилегий (колонка роли).
     * В виде, который принимает \\Simflex\\Core\\DB\\Where: для чтения и записи
     */
    protected function getScope(): array
    {
        $user = Container::getUser();
        if ($user?->ican(Privilege::DEV)) {
            return [];
        }

        $privileges = array_values($user?->getPrivileges() ?? []) ?: [''];
        $scope = [];
        if (isset($this->fields['privilege'])) {
            $column = $this->table . '.privilege';
            $scope[] = $this->fields['privilege']->isnull
                ? new ExprOr([$column => $privileges, new Expr($this->wrapColumn($column) . ' IS NULL')])
                : new ExprOr([$column => $privileges]);
        }
        if (isset($this->fields['role_id'])) {
            $names = implode(',', array_map(fn(string $name) => DB::wrapString($name), $privileges));
            $scope[] = new Expr(
                $this->wrapColumn($this->table . '.role_id') . " IN (SELECT r.role_id FROM user_role r WHERE r.privilege IN ($names))"
            );
        }

        return $scope;
    }

    /**
     * Колонки списка: видимые поля и подписи внешних ключей
     *
     * @return string[]
     */
    protected function getListColumns(): array
    {
        $columns = [];
        foreach ($this->fks as $field) {
            $label = $field->fk->table . $field->name . '.' . $field->fk->label . ' ' . $field->name . '_label';
            if ($field->fk->table === $this->table) {
                $label = '(SELECT ' . $field->fk->label . ' FROM `' . $field->fk->table . '` t_' . $this->table
                    . ' WHERE ' . $this->pk->name . ' = ' . $this->table . '.' . $field->name . ') ' . $field->name . '_label';
            }
            $columns[] = $this->table . '.' . $field->name;
            $columns[] = $label;
        }
        foreach ($this->fields as $field) {
            if ($field->isVisible && !isset($this->fks[$field->name]) && ($column = $field->selectQueryField())) {
                $columns[] = $column;
            }
        }

        return array_merge($columns, $this->selectAdditional);
    }

    /**
     * Запрос списка без фильтров, сортировки и страниц: колонки, таблицы внешних ключей
     * и записи, которые пользователь может видеть (getScope())
     */
    protected function getListQuery(): AQ
    {
        $query = new AQ()->asArray()->from($this->table)->select($this->selectAll ? '*' : $this->getListColumns());
        foreach ($this->fks as $field) {
            if ($field->fk->table !== $this->table) {
                // алиас: на одну таблицу могут ссылаться несколько полей
                $alias = $field->fk->table . $field->name;
                $query->join(
                    $field->fk->table,
                    $this->table . '.' . $field->name,
                    $alias . '.' . $field->fk->key,
                    $field->isnull ? 'LEFT' : 'INNER',
                    alias: $alias,
                );
            }
        }

        return $query->where($this->getScope());
    }

    protected function getListOrder(): string
    {
        $column = $this->getSortColumn();
        $order = [$column . ($this->isSortDesc() ? ' DESC' : '')];
        if ($this->pk->name !== $column) {
            $order[] = $this->pk->name;
        }

        return implode(', ', $order);
    }

    /**
     * Сортировка, выбранная в шапке колонки: ?o=column&d=0|1 (по возрастанию, по убыванию); без d повторный выбор
     * колонки меняет порядок на обратный. Хранится в сессии
     */
    protected function changeSorting(): void
    {
        $column = (string)($this->request->request('o', ''));
        if (!isset($this->fields[$column])) {
            return;
        }

        $state = $this->getState();
        $direction = $this->request->request('d');
        if ($direction !== null) {
            // явное направление: кнопки «по возрастанию» и «по убыванию» в шапке
            $state['order_desc'] = (int)((string)$direction === '1');
        } else {
            $state['order_desc'] = ($state['order_by'] ?? '') === $column ? (int)!($state['order_desc'] ?? 0) : 0;
        }
        $state['order_by'] = $column;
        $this->setState($state);
    }

    /**
     * Колонка сортировки списка: выбранная, по умолчанию $defaultOrderBy или первичный ключ
     */
    public function getSortColumn(): string
    {
        $column = (string)($this->getState()['order_by'] ?? '');
        return isset($this->fields[$column]) ? $column : (static::$defaultOrderBy ?? $this->pk->name);
    }

    public function isSortDesc(): bool
    {
        $state = $this->getState();
        return isset($this->fields[(string)($state['order_by'] ?? '')])
            ? (bool)($state['order_desc'] ?? false)
            : static::$defaultOrderDesc;
    }

    /**
     * Состояние списка раздела в сессии: сортировка (order_by, order_desc) и фильтры (filter: поле => значение)
     */
    public function getState(): array
    {
        return (array)(Session::get($this->table) ?? []);
    }

    protected function setState(array $state): void
    {
        Session::set($this->table, $state);
    }

    /**
     * Значение фильтра списка, выбранное в сессии; '' - не выбрано
     */
    protected function getFilterValue(string $name): mixed
    {
        return $this->getState()['filter'][$name] ?? '';
    }

    protected function getListCount(AQ $query): int
    {
        return (int)(clone $query)->select('COUNT(*)')->fetchScalar();
    }

    protected function filterReset(): never
    {
        // сбрасываются сортировка, фильтры и поиск
        $this->setState([]);
        header('location: ' . Page::get()->getPath());
        exit;
    }

    /**
     * Добавляет в запрос фильтры списка (выбранные в списке, хранятся в сессии), значения передаются
     * параметрами запроса
     */
    protected function applyFilters(AQ $query): void
    {
        $state = $this->getState();
        $posted = (array)($this->request->request('filter') ?? []);
        foreach ($this->fields as $field) {
            $state['filter'][$field->name] = $posted[$field->name] ?? $state['filter'][$field->name] ?? '';
        }
        if ($posted) {
            $this->setState($state);
        }

        // поиск: подстрока в любой текстовой колонке с фильтром (поле поиска над таблицей)
        $search = $this->request->request('q');
        if ($search !== null) {
            $state['q'] = trim((string)$search);
            $this->setState($state);
        }
        $searchColumns = $this->getSearchFields();
        if (($state['q'] ?? '') !== '' && $searchColumns) {
            $conditions = [];
            foreach ($searchColumns as $field) {
                $conditions[] = $this->wrapColumn($this->table . '.' . $field->name) . ' LIKE :filter_q';
            }
            $query->andWhere('(' . implode(' OR ', $conditions) . ')')->bind(['filter_q' => '%' . $state['q'] . '%']);
            $this->isHierarchy = false;
        }

        foreach ($this->fields as $field) {
            $filter = $state['filter'][$field->name];
            if ($filter === '') {
                continue;
            }

            $column = $this->table . '.' . $field->name;
            $bind = 'filter_' . $field->name;
            if ($filter === 'null') {
                $query->andWhere([$column => null]);
                continue;
            }

            $this->isHierarchy = false;
            if ($field instanceof FieldDateTime) {
                $query->andWhere($this->wrapColumn($column) . " LIKE :$bind")->bind([$bind => Time::mysql($filter) . '%']);
            } elseif ($field instanceof FieldMultiKey) {
                $relations = DB::wrapName($field->params['table_relations']);
                $query->andWhere(
                    "EXISTS (SELECT 1 FROM $relations rls WHERE " . $this->wrapColumn($this->table . '.' . $this->pk->name)
                    . ' = rls.' . DB::wrapName($field->getRelationKey())
                    . ' AND rls.' . DB::wrapName($field->params['key']) . " = :$bind)"
                )->bind([$bind => $filter]);
            } elseif ($field instanceof FieldString) {
                $query->andWhere($this->wrapColumn($column) . " LIKE :$bind")->bind([$bind => "%$filter%"]);
            } elseif (str_contains($filter, '%')) {
                $query->andWhere($this->wrapColumn($column) . " LIKE :$bind")->bind([$bind => $filter]);
            } else {
                $query->andWhere([$column => $filter]);
            }
        }
        unset($filter);
    }

    /**
     * Поля, по которым ищет поле поиска над таблицей: видимые текстовые поля с фильтром
     * @return array<string, Field>
     */
    public function getSearchFields(): array
    {
        return array_filter(
            $this->fields,
            fn(Field $field) => $field->isVisible && $field->filter && $field instanceof FieldString
        );
    }

    /**
     * Фильтры, выбранные в списке, для тегов над таблицей: название поля, подпись значения, адрес сброса
     * @return list<array{name: string, label: string, value: string, reset: string}>
     */
    public function getAppliedFilters(): array
    {
        $filters = [];
        foreach ($this->getState()['filter'] ?? [] as $name => $value) {
            $field = $this->fields[$name] ?? null;
            if ($field === null || !$field->filter || (string)$value === '') {
                continue;
            }
            $filters[] = [
                'name' => $name,
                'label' => $field->label,
                'value' => $field->getFilterLabel((string)$value),
                'reset' => Page::get()->getPath() . '?' . http_build_query(['filter' => [$name => ''], 'p' => 0]),
            ];
        }

        return $filters;
    }

    public function show(): string
    {
        $this->changeSorting();
        $query = $this->getListQuery();
        $this->applyFilters($query);

        $cnt = $this->getListCount($query);
        if ($cnt > 200 && $this->isHierarchy) {
            $this->isHierarchy = false;
            if (($parentId = $this->getFilterValue($this->pid->name)) !== '') {
                $query->andWhere([$this->table . '.' . $this->pid->name => $parentId]);
                $cnt = $this->getListCount($query);
            }
        }

        $query->orderBy($this->getListOrder());
        // запись, к которой ведёт ссылка (?show_id=) или которая только что сохранена (?save_id=): без ?p= список
        // открывается на её странице, шаблон прокручивает к ней и подсвечивает
        $highlightId = (int)($this->request->get('save_id') ?: $this->request->get('show_id'));
        $page = (int)$this->request->get('p', 0);
        if ($highlightId && $this->request->get('p') === null && !$this->isHierarchy) {
            $ids = array_map('intval', (clone $query)->select($this->table . '.' . $this->pk->name)->fetchColumn());
            $index = array_search($highlightId, $ids, true);
            $page = $index === false ? 0 : intdiv($index, static::$perPage);
        }
        $pagination = new Pagination($page, $this->isHierarchy ? 200 : static::$perPage, $cnt);
        if (!$this->isHierarchy) {
            $query->limit($pagination->limit());
        }
        self::$currentQuery = $query;
        $listRows = $query->all();
        $rows = [];
        if ($this->isHierarchy) {
            $tree_name = $this->pid->name;
            foreach ($this->fields as $field) {
                if ($field->isVisible && $field instanceof FieldString) {
                    $tree_name = $field->name;
                    break;
                }
            }

            $tree = [];
            foreach ($listRows as $row) {
                $tree[(int)$row[$this->pid->name]][(int)$row[$this->pk->name]] = $row;
            }
            $id_start = (int)$this->getFilterValue($this->pid->name);
            // уровень вложенности (tree_level) шаблон выводит классом ячейки колонки $tree_name
            $rows = Tree::toList($tree, $id_start);
        } else {
            $rows = $listRows;
        }

        $treeName = $this->isHierarchy ? $tree_name : '';
        $filters = $this->getAppliedFilters();
        $search = (string)($this->getState()['q'] ?? '');

        return $this->render(__DIR__ . '/tpl/show.tpl', [
            'rows' => $rows,
            'pagination' => $pagination,
            'highlightId' => $highlightId,
            'treeName' => $treeName,
            'filters' => $filters,
            'search' => $search,
            'count' => $cnt,
            'theme' => Page::get()->getTheme(),
        ]);
    }

    protected function showCell(Field $field, array $row): string
    {
        return $field->show($row);
    }

    protected function initTable(): void
    {
        $fields = static::getFieldRows();
        $pkName = '';
        foreach ($fields as $field) {
            if (!empty($field['params']['main']['filter'])) {
                $this->isFilter = true;
            }
            if (!empty($field['params']['main']['pk'])) {
                $pkName = $field['name'];
            }

            $this->addField(Helper::create($field));
        }

        foreach ($this->fields as $field) {
            $field->tablePk = $pkName;
        }

        //ПАРАМЕТРЫ ТАБЛИЦЫ
        $this->tableParamsInit();
    }

    /**
     * Загрузка параметров из БД
     */
    protected function tableParamsLoad(): array
    {
        return static::getParamRows();
    }

    /**
     * Инициализация параметров. Загружаются из $this->tableParamsLoad()
     */
    protected function tableParamsInit(): void
    {
        $params = $this->tableParamsLoad();
        if (count($params)) {
            foreach ($params[''] as $group_id => $group) {
                $this->params[$group['pos']][$group_id] = $group;
                $this->params[$group['pos']][$group_id]['fields'] = [];

                if (isset($params[$group_id])) {
                    foreach ($params[$group_id] as $param) {
                        $field = Helper::create($param);
                        $field->form = $group['name'];
                        if ($dv = $param['default_value']) {
                            $field->defaultValue = $dv;
                        }
                        $this->params[$group['pos']][$group_id]['fields'][$param['name']] = $field;
                    }
                } elseif ($group['class']) {
                    $field = Helper::create($group);
                    if ($dv = $group['default_value']) {
                        $field->defaultValue = $dv;
                    }
                    $this->params[$group['pos']][$group_id]['field'] = $field;
                }
            }
        }
    }

    protected function filter(): string
    {
        return $this->isFilter ? $this->render(__DIR__ . '/tpl/filter.tpl') : '';
    }

    protected function filterField(Field $field): string
    {
        // значение из запроса или выбранное раньше (хранится в сессии)
        return $field->filter($this->request->request('filter')[$field->name] ?? $this->getFilterValue($field->name));
    }

    public function addField(Field $field): void
    {
        $this->fields[$field->name] = $field;
        if ($field->pk) {
            $this->pk = $field;
        }
        if ($field->fk) {
            $this->fks[$field->name] = $field;
            if ($field->fk->table === $this->table) {
                $this->pid = $field;
                $this->isHierarchy = true;
            }
        }
    }

    /**
     * Переключает булево поле, возвращает новое значение ('1' / '0') или 'error'
     */
    public function boolChange(): string
    {
        $pk = (int)$this->request->request('pk');
        $field = $this->request->request('field');
        if ($pk && isset($this->fields[$field])) {
            $fieldDB = static::getFieldRow($field);
            $fieldParams = $fieldDB['params'] ?? [];
            $where = [$this->pk->name => $pk];
            $value = $this->getQuery()->select(DB::wrapName($field))->where($where)->fetchScalar();
            if ($value === null) {
                return 'error';
            }
            if (!@$fieldParams['main']['readonly']) {
                $value = $value ? 0 : 1;
                static::getModel()::bulkUpdate([$field => $value], $where);
            }
            return $value ? '1' : '0';
        }
        return 'error';
    }

    public function form(): string
    {
        if ($this->request->get('ids') !== null && count(explode(',', $this->request->get('ids'))) === 1) {
            header("location: ?action=form&{$this->pk->name}={$this->request->get('ids')}");
            exit;
        }

        $where = $this->getScope();

        $title = 'Добавить запись';

        $isGroup = !empty($this->request->get('ids'));
        $isAdd = !$isGroup && empty($this->request->request($this->pk->name));
        $isEdit = !$isGroup && !$isAdd;

        if ($isAdd && !$this->canAdd) {
            Alert::error('Ошибка! Недостаточно прав для добавления записей в данный раздел', Page::get()->getPath());
        }
        if ($isEdit && !$this->canEdit) {
            Alert::error('Ошибка! Недостаточно прав для редактирования записей в данном разделе', Page::get()->getPath());
        }

        $row = [];
        foreach ($this->fields as $index => $field) {
            if ($field instanceof FieldVirtual) {
                unset($this->fields[$index]);
            }
        }
        $ui = '';
        foreach ($this->fields as $field) {
            $row[$field->name] = $field->defval();
            $ui .= $field->loadUI(true);
        }

        foreach ($this->fks as $field) {
            $fv = $this->getFilterValue($field->name);
            if ($fv !== '' && $fv !== null) {
                $row[$field->name] = (int)$fv;
            }
        }

        if ($this->request->post()) {
            $row = $this->request->post() + $row;
        }

        $pk = 0;
        if (!empty($this->request->request($this->pk->name))) {
            $pk = (int)$this->request->request($this->pk->name);
            $where[$this->pk->name] = $pk;
            if ($rrow = $this->getQuery()->where($where)->fetchOne()) {
                $row = $rrow;
                if ($this->title) {
                    $title = $this->title;
                } else {
                    $title = 'Редактировать запись №' . $pk;
                    $rowName = '';

                    if (isset($row['title'])) {
                        $rowName = $row['title'];
                    } elseif (isset($row['name'])) {
                        $rowName = $row['name'];
                    } elseif (isset($row['label'])) {
                        $rowName = $row['label'];
                    }
                    if ($rowName) {
                        mb_strlen($rowName, 'utf8') > 50 ? $rowName = mb_substr($rowName, 0, 47, 'utf8') . '...' : null;
                        $title .= ' &mdash; &laquo;' . $rowName . '&raquo;';
                    }
                }
            } else {
                Alert::error('Ошибка! Запись не найдена или недостаточно прав для редактирования.', Page::get()->getPath());
            }
        }

        if ($isGroup) {
            $title = 'Редактирование нескольких записей';
            // шаблон формы передаёт выбранные записи дальше: group_ids
            $ids = implode(',', array_map('intval', explode(',', (string)$this->request->get('ids'))));
            $rows = $this->getQuery()->where([$this->pk->name => explode(',', $ids)])->all();
            foreach ($this->fields as $field) {
                $vars = [];
                foreach ($rows as $row0) {
                    $vars[$row0[$field->name]] = true;
                }
                if (count($vars) === 1) {
                    foreach ($vars as $var => $useless) {
                        $row[$field->name] = $var;
                    }
                }
            }

            $hasSetParams = false;
            foreach ($this->fields as $field) {
                if ($field->name === 'params') {
                    $hasSetParams = true;
                    break;
                }
            }

            if ($hasSetParams) {
                $params = [];
                foreach ($this->params as $paramz) {
                    foreach ($paramz as $group) {
                        if (isset($group['fields'])) {
                            foreach ($group['fields'] as $field) {
                                if (is_object($field)) {
                                    if ($group['name']) {
                                        $vars = [];
                                        foreach ($rows as $row0) {
                                            $rowParams = unserialize($row0['params']);
                                            @$vars[$rowParams[$group['name']][$field->name]] = true;
                                        }
                                        if (count($vars) === 1) {
                                            foreach ($vars as $var => $useless) {
                                                $params[$group['name']][$field->name] = $var;
                                            }
                                        }
                                    } else {
                                        $vars = [];
                                        foreach ($rows as $row0) {
                                            $rowParams = unserialize($row0['params']);
                                            $vars[$rowParams[$field->name]] = true;
                                        }
                                        if (count($vars) === 1) {
                                            foreach ($vars as $var => $useless) {
                                                $params[$field->name] = $var;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (isset($group['field'])) {
                            $vars = [];
                            foreach ($rows as $row0) {
                                $rowParams = unserialize($row0['params']);
                                $vars[$rowParams[$field->name]] = true;
                            }
                            if (count($vars) === 1) {
                                foreach ($vars as $var => $useless) {
                                    $params[$field->name] = $var;
                                }
                            }
                        }
                    }
                }
                $row['params'] = serialize($params);
            }
        }

        if (Page::get()->isAjax()) {
            if (!empty($this->request->request('field')) && isset($this->fields[$this->request->request('field')]) && $pk) {
                $field = $this->fields[$this->request->request('field')];
                static::getModel()::bulkUpdate([$field->name => ''], $where);
                $field->delete($row[$field->name]);
                exit();
            }
        }

        $params = [];
        if (!empty($row['params'])) {
            $params = unserialize($row['params']);
        }

        $this->formBeforeOutput($row);
        return $ui . $this->render(__DIR__ . '/tpl/form.tpl', get_defined_vars());
    }

    protected function formBeforeOutput(array &$row): void
    {
    }

    /**
     * Вывод html-кода для ввода данных на форме. Пустая (NULL) колонка и поле без колонки выводятся пустой строкой
     */
    protected function formFieldInput(Field $field, array $row): string
    {
        return $field->input($field->value ?: ($row[$field->name] ?? ''));
    }

    public function showActions(): string
    {
        return $this->render(__DIR__ . '/tpl/show.actions.tpl');
    }

    public function rowActions($row, $i): string
    {
        return $this->render(__DIR__ . '/tpl/show.actions.row.tpl', ['row' => $row, 'i' => $i]);
    }

    /**
     * Ajax: поиск записей для выпадающего списка внешнего ключа (FieldInt с is_fk), JSON [{id, name}]
     */
    public function searchInt(): array
    {
        $text = trim((string)($this->request->request('text', '')));
        $name = str_replace(['filter[', ']'], '', (string)($this->request->request('name', '')));
        $field = $this->fields[$name] ?? null;
        if (!($field instanceof FieldInt) || empty($field->params['is_fk'])) {
            return [];
        }

        $label = DB::wrapName($field->params['fk_label']);
        $out = (new AQ())->asArray()->from($field->params['fk_table'])
            ->select([DB::wrapName($field->params['fk_key']) . ' AS id', "$label AS name"])
            ->where("$label LIKE :text")
            ->bind(['text' => '%' . $text . '%'])
            ->limit(50)
            ->all();

        exit(json_encode($out, JSON_UNESCAPED_UNICODE));
    }

    /**
     * Ajax: поиск записей для фильтра по полю FieldMultiKey, JSON [{id, name}]
     */
    public function searchMultiKey(): array
    {
        $name = str_replace(['filter[', ']'], '', (string)($this->request->request('name', '')));
        $field = $this->fields[$name] ?? null;
        if (!($field instanceof FieldMultiKey)) {
            return [];
        }

        $out = [];
        foreach ($field->getValues(search: (string)($this->request->request('text', '')), limit: 50) as $id => $label) {
            $out[] = ['id' => $id, 'name' => $label];
        }

        exit(json_encode($out, JSON_UNESCAPED_UNICODE));
    }

    public function copy(): never
    {
        $ids = array_map('intval', explode(',', $this->ids));
        $rows = $this->getQuery()->where([$this->pk->name => $ids])->all();
        $fieldNames = ['name', 'title', 'label'];
        foreach ($rows as $row) {
            $set = [];
            foreach ($row as $key => $value) {
                if ($key === $this->pk->name || $value === null) {
                    continue;
                }
                $set[$key] = in_array($key, $fieldNames) ? "Копия $value" : $value;
            }
            $copy = static::getModel()::insert($set);
            if ($copy) {
                Alert::success("Запись №{$row[$this->pk->name]} скопирована в №{$copy->getId()}");
            } else {
                Alert::error("Запись №{$row[$this->pk->name]} не скопирована!");
                Alert::error(DB::error());
                Alert::error(DB::error());
            }
        }
        header('location: ' . Page::get()->getPath());
        exit;
    }

    /**
     * Ajax-действие: проверяет отправленную форму, возвращает JSON {valid, errors}
     */
    public function validate(): string
    {
        $json = ['valid' => $this->isValid() ? 1 : 0];
        foreach ($this->errors as $field => $errors) {
            $json['errors'][$field] = join('<br />', $errors);
        }
        return json_encode($json);
    }

    public function isValid(): bool
    {
        foreach ($this->fields as $field) {
            if ($errors = $field->check()) {
                foreach ($errors as $error) {
                    $this->errors[$field->label][] = $error;
                }
            }
        }
        return !count($this->errors);
    }

    public function saveGroup(): string
    {
        $success = true;
        $idList = array_values(array_unique(array_filter(array_map('intval', explode(',', (string)($this->request->post('group_ids', '')))))));
        $ids = implode(',', $idList);
        if (!$idList) {
            Alert::error('Не выбраны записи для сохранения!');
            return 'ids';
        }
        $pk = $this->pk->name;

        $set = [];
        foreach ($this->fields as $field) {
            if (isset($this->request->post('set')[$field->name]) && !($field instanceof FieldVirtual)) {
                $set[$field->name] = $field->getPOST();
            }
        }

        $hasSetParams = false;
        foreach ($this->fields as $field) {
            if ($field->name === 'params' && $this->request->post('set_param') !== null) {
                $hasSetParams = true;
                break;
            }
        }

        if ($hasSetParams) {
            $rows = $this->getQuery()->select([DB::wrapName($pk), 'params'])->where([$pk => $idList])->all();
            foreach ($rows as $row) {
                $params = unserialize($row['params']);
                if (!is_array($params)) {
                    $params = [];
                }
                $params = array_replace_recursive($params, $this->getPostedParamValues((array)$this->request->post('set_param')));

                $success = static::getModel()::bulkUpdate(['params' => serialize($params)], [$pk => $row[$pk]]) && $success;
            }
        }

        if ($set) {
            $success = static::getModel()::bulkUpdate($set, [$pk => $idList]) && $success;
        }

        if ($success) {
            Alert::success('Записи ' . $ids . ' успешно сохранены!');
        } else {
            Alert::error('Записи ' . $ids . ' не сохранены!');
        }
        return 'ids';
    }

    /**
     * @return string|int|false pkValue | false
     */
    public function save(): string|int|false
    {
        if (!empty($this->request->post('group_ids'))) {
            return $this->saveGroup();
        }

        $pkValue = null;
        if ($this->isValid()) {
            foreach ($this->fields as $index => $field) {
                if ($field instanceof FieldVirtual) {
                    unset($this->fields[$index]);
                }
            }

            $isInsert = empty($this->request->post($this->pk->name));
            $isUpdate = !$isInsert;
            // через модель: срабатывают её хуки (beforeSave() и др.) и события
            if ($isInsert) {
                $model = static::getModel()::insert($this->getInsertData());
                $saved = $model !== null;
            } else {
                $model = static::getModel()::findOne([$this->pk->name => (int)$this->request->post($this->pk->name)]);
                $saved = $model && $model->update($this->getUpdateData());
            }

            if (!$saved || DB::errno()) {
                $this->errors[] = 'Введенные данные некорректны';
                $this->errors[] = DB::error() ?: 'Запись не найдена';
            } else {
                $pkValue = $model->getId();
                if ($isInsert) {
                    // поля, которые пишут данные по id записи (связи), до вставки ничего не сохранили
                    foreach ($this->fields as $field) {
                        if ($field->isSavedById) {
                            $field->pkValue = $pkValue;
                            $field->getPOST();
                        }
                    }
                }

                $field_alias = false;
                $field_path = false;
                foreach ($this->fields as $field) {
                    if ($field instanceof FieldAlias) {
                        $field_alias = $field;
                    }
                    if ($field instanceof FieldPath) {
                        $field_path = $field;
                    }
                }
                if ($field_path && $field_alias) {
                    $pk = $this->table . '.' . $this->pk->name;
                    $where = $this->getScope();
                    $where[$pk] = (int)$pkValue;
                    if ($this->pid) {
                        // путь записи по пути родителя, затем пути её потомков
                        $pid = $this->table . '.' . $this->pid->name;
                        $row = $this->getQuery()
                            ->select([$pk, $pid, $this->table . '.' . $field_alias->name, 't2.' . $field_path->name])
                            ->leftJoin($this->table, $pid, 't2.' . $this->pk->name, alias: 't2')
                            ->where($where)
                            ->fetchOne();
                        $path = rtrim((string)$row['path'], '/') . '/' . $row['alias'];
                        $path = preg_replace('@\/+@', '/', $path);
                        $row[$field_path->name] = $path;
                        static::getModel()::bulkUpdate([$field_path->name => $path], $where);

                        $steck = [$row];
                        for ($i = 0; $i < count($steck); $i++) {
                            $cur = $steck[$i];
                            $children = $this->getQuery()
                                ->select([$this->pk->name, $field_alias->name, $field_path->name])
                                ->where(array_merge($this->getScope(), [$pid => $cur[$this->pk->name]]))
                                ->all();
                            foreach ($children as $child) {
                                $path = rtrim($cur[$field_path->name], '/') . '/' . $child[$field_alias->name];
                                if ($child[$field_path->name] !== $path) {
                                    static::getModel()::bulkUpdate(
                                        [$field_path->name => $path],
                                        array_merge($this->getScope(), [$pk => $child[$this->pk->name]])
                                    );
                                    $child[$field_path->name] = $path;
                                    $steck[] = $child;
                                }
                            }
                        }
                    } else {
                        static::getModel()::bulkUpdate([$field_path->name => '/' . $this->request->post($field_alias->name) . '/'], $where);
                    }
                }
            }
            if (count($this->errors)) {
                Alert::error('Ошибка при сохранении записи' . ($pkValue ? " №$pkValue" : ''));
            } else {
                Alert::success('Запись №' . $pkValue . ' успешно сохранена!');
            }
        }

        // при ошибках content() снова показывает форму с ошибками и отправленными значениями
        return count($this->errors) ? false : $pkValue;
    }

    /**
     * Значения новой записи из формы: колонка => значение. Пустые значения колонок со значением по умолчанию
     * в БД не передаются — запись получит значение по умолчанию
     */
    protected function getInsertData(): array
    {
        $data = [];
        foreach ($this->fields as $field) {
            if ($field->isVirtual) {
                $field->getPOST();
            }
            $add = !$field->isVirtual && !$field->readonly || $field instanceof FieldPath;
            $post = $field->getPOST();
            if ($add && (empty($post) || $post === 'NULL' || $post === "''")) {
                $add = empty(DB::columnInfo($this->table, $field->name)['Default']);
            }
            if ($add) {
                $data[$field->name] = $field->name === 'params' ? serialize($this->getPostedParams()) : $post;
            }
        }

        return $data;
    }

    /**
     * Изменённые значения записи из формы: колонка => значение. Пустой пароль, пустой файл и пустая дата
     * не меняют сохранённое значение
     */
    protected function getUpdateData(): array
    {
        $data = [];
        foreach ($this->fields as $field) {
            if ($field->isVirtual) {
                $field->getPOST();
            } elseif (!$field->readonly) {
                if ($field->name === 'params') {
                    $data[$field->name] = serialize($this->getPostedParams());
                } elseif ($field instanceof FieldPassword) {
                    if ($value = $field->getPOST()) {
                        $data[$field->name] = $value;
                    }
                } elseif ($field instanceof FieldDateTime) {
                    // колонку с автозаполнением (ON UPDATE) не трогаем
                    if (empty(DB::columnInfo($this->table, $field->name)['Extra'])) {
                        $value = $field->getPOST();
                        // null — очистка поля (e2n), пустая строка — оставить как есть
                        if ($value !== '') {
                            $data[$field->name] = $value;
                        }
                    }
                } elseif ($field instanceof FieldFile) {
                    if ($value = trim($field->getPOST(), "'")) {
                        $data[$field->name] = $value;
                    }
                } else {
                    $data[$field->name] = $field->getPOST();
                }
            }
        }

        return $data;
    }

    /**
     * Отправленные значения параметров (колонка params)
     */
    protected function getPostedParams(): array
    {
        return $this->getPostedParamValues();
    }

    /**
     * Отправленные значения параметров: поля групп - из значений своей группы
     * @param array|null $only Только параметры с этими именами (ключами), null - все
     */
    protected function getPostedParamValues(?array $only = null): array
    {
        $params = [];
        $post = $this->request->post();
        foreach ($this->params as $paramz) {
            foreach ($paramz as $group) {
                $fields = array_filter($group['fields'] ?? [], 'is_object');
                if (isset($group['field'])) {
                    $fields[] = $group['field'];
                    $groupName = null;
                } else {
                    $groupName = $group['name'] ?: null;
                }
                foreach ($fields as $field) {
                    if ($only !== null && !isset($only[$field->name])) {
                        continue;
                    }
                    $field->setPosted($groupName === null ? $post : (array)($post[$groupName] ?? []));
                    $value = preg_replace("@^'(.+)'$@", '$1', (string)$field->getPOST(true));
                    $field->setPosted(null);
                    if ($groupName === null) {
                        $params[$field->name] = $value;
                    } else {
                        $params[$groupName][$field->name] = $value;
                    }
                }
            }
        }
        return $params;
    }

    /**
     * Удаляет одну запись
     * @return string "errno: error" или пустая строка при успехе
     */
    protected function deleteItem(int $id): string
    {
        $where = $this->getScope();
        $where[$this->pk->name] = $id;
        static::getModel()::bulkDelete($where);
        return DB::errno() ? DB::errno() . ': ' . DB::error() : '';
    }

    /**
     * Обработчик кнопки "удалить"
     */
    public function delete(): never
    {
        if (!$this->canDelete) {
            Alert::error('Ошибка! Недостаточно прав для удаления записей в данном разделе', Page::get()->getPath());
        }

        $ids_temp = is_array($rows = $this->request->request('rows')) ? $rows : [];
        $ids = [];
        foreach ($ids_temp as $id) {
            if ((int)$id > 0) {
                $ids[] = (int)$id;
            }
        }

        foreach ($this->fields as $field) {
            if ($field instanceof FieldFile) {
                $dir = 'files';
                if ($field instanceof FieldImage) {
                    $dir = 'images';
                }
                $rows = $ids ? $this->getQuery()->select(DB::wrapName($field->name))->where([$this->pk->name => $ids])->all() : [];
                foreach ($rows as $row) {
                    if ($row[$field->name] && is_file($file = Container::getPaths()->getPublic('uf/' . $dir . '/' . $field->path . $row[$field->name]))) {
                        unlink($file);
                        if (isset($field->sizes)) {
                            foreach ($field->sizes as $size) {
                                if (is_file($file = Container::getPaths()->getPublic('uf/' . $dir . '/' . $field->path . $size . '/' . $row[$field->name]))) {
                                    unlink($file);
                                }
                            }
                        }
                    }
                }
            }
        }

        $deleted = [];
        foreach ($ids as $id) {
            // запись удаляется вместе со связанными данными, которые удаляет deleteItem() раздела
            $n = DB::transaction(fn() => $this->deleteItem($id));
            if ($n) {
                Alert::error("#$id &mdash; Ошибка. Удаление записи не возможно");
                Alert::error("#$id &mdash; $n");
            } else {
                $deleted[] = $id;
                Alert::success("#$id &mdash; Успех. Запись удалена");
            }
        }
        header('location: ' . Page::get()->getPath());
        exit;
    }

    protected function portlets(string $position = 'right'): string
    {
        return '';
    }

    protected function showDetailExtra($row): string
    {
        return '';
    }

    /**
     * Строки «Создано» и «Изменено» карточки записи: колонки времени модели (COLUMN_TIME_CREATE, COLUMN_TIME_UPDATE)
     * выводятся только здесь; в списке и форме их нет, пока раздел не объявил их полями
     *
     * @param array<string, mixed> $row Запись карточки
     */
    /**
     * Время создания и изменения записи (колонки модели, которых нет среди полей раздела): подпись => значение
     * @return array<string, string>
     */
    public function getTimeInfo(array $row): array
    {
        if (!isset(static::$model)) {
            return [];
        }

        $model = static::getModel();
        $columns = array_filter([
            'Создано' => $model::COLUMN_TIME_CREATE,
            'Изменено' => $model::COLUMN_TIME_UPDATE,
        ], fn(?string $column) => $column !== null && !isset($this->fields[$column]));
        if (!$columns || empty($row[$this->pk->name])) {
            return [];
        }

        $times = new AQ()->asArray()->from($this->table)->select(array_values($columns))
            ->where([$this->pk->name => $row[$this->pk->name]])->fetchOne();

        return array_map(fn(string $column) => (string)($times[$column] ?? ''), $columns);
    }

    protected function showDetailTimeRows(array $row): string
    {
        $html = '';
        foreach ($this->getTimeInfo($row) as $label => $value) {
            $html .= '<tr class="modal-info__table-row"><th>' . $label . '</th><td>' . htmlspecialchars($value) . '</td></tr>';
        }

        return $html;
    }

    public function showDetail(): string
    {
        $id = (int)$this->request->get('id');
        return $this->render($this->showDetailGetTpl(), ['row' => $this->showDetailGetRow($id)]);
    }

    /**
     * Абсолютный путь к шаблону карточки записи
     */
    protected function showDetailGetTpl(): string
    {
        return __DIR__ . '/tpl/show.detail.tpl';
    }

    protected function showDetailGetRow(int $id): array|false|null
    {
        return $this->getListQuery()->andWhere([$this->table . '.' . $this->pk->name => $id])->fetchOne();
    }

    /**
     * @throws \Exception code == 999 — пропустить запись
     */
    protected function showDetailPrepareValue($row, $key): ?string
    {
        $value = $row[$key];
        /** Field $field */
        if (empty($field = &$this->fields[$key])) {
            throw new \Exception('Skip this field', 999);
        }
        if (is_string($value) && mb_strlen($value) > 1500) {
            $value = mb_substr($value, 0, 1500) . '...';
        }
        if ($key === 'params' && is_string($value) && substr($value, 0, 2) === 'a:') {
            $value = '<pre>' . print_r(unserialize($value), true) . '</pre>';
        } else {
            $value = $field->showDetail($row);
        }
        return $value;
    }
}
