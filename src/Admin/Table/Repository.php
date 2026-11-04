<?php

namespace Simflex\Core\Admin\Table;

use Simflex\Core\System\Container;
use Simflex\Core\Admin\Handler;
use Simflex\Core\System\ExtensionConfig;
use Simflex\Core\Admin\HasAdminParams;
use Simflex\Core\Extensions\Content\ContentTemplates;

/**
 * Структура админки, объявленная в коде: реестр разделов (Admin/handlers.php ядра
 * и приложения), настройки модулей и шаблоны страниц. Превращает объявления в записи,
 * из которых создаются поля админки
 */
class Repository
{
    /**
     * Настройки модуля/компонента, объявленные в коде (ExtensionBase::adminParams()).
     *
     * @param string $class Класс модуля/компонента
     * @param string $table Таблица админки, к которой относится форма
     * @return array<string, array<string, array>> param_pid => param_id => запись.
     *         У групп пустой 'class', они лежат под pid ''; их поля — под id группы.
     */
    public static function getExtensionParams(string $class, string $table = ''): array
    {
        $class = static::extensionClass($class);
        if (!$class) {
            return [];
        }

        $out = [];
        foreach ($class::adminParams() as $item) {
            if ($item instanceof ParamGroup) {
                $groupId = static::stableId($class . '.group.' . $item->name);
                $out[''][$groupId] = [
                    'param_id' => $groupId,
                    'param_pid' => '',
                    'name' => $item->name,
                    'label' => $item->label,
                    'position' => $item->pos,
                    'tab' => $item->tab,
                    'help' => '',
                    'field_type' => '',
                    'class' => '',
                    'params' => [],
                    'table' => $table,
                ];
                foreach ($item->fields as $field) {
                    $row = static::extensionFieldRow($field, $class, $groupId, $table);
                    $row['position'] = $item->pos;
                    $row['tab'] = $item->tab;
                    $out[$groupId][$row['param_id']] = $row;
                }
            } else {
                $row = static::extensionFieldRow($item, $class, '', $table);
                $out[''][$row['param_id']] = $row;
            }
        }

        return $out;
    }

    /**
     * Поля шаблона страницы, объявленные в коде (\Simflex\Core\Extensions\Content\ContentTemplate).
     * Они не вложены в свои блоки: значения хранятся в content.params по имени поля,
     * блок — это 'group_name', под которым их показывает форма.
     *
     * @return array<string, array<string, array>> как Table::getParamRows(): '' => param_id => запись
     */
    public static function getTemplateParams(string $template, string $table = 'content'): array
    {
        $out = [];
        foreach (ContentTemplates::get($template)?->params ?? [] as $block) {
            foreach ($block->fields as $field) {
                $row = static::toFieldRow($field, $table);
                $row['param_id'] = static::stableId('template.' . $template . '.' . $row['name']);
                $row['param_pid'] = '';
                $row['pos'] = $row['position'] = $block->pos;
                $row['group_name'] = $block->label;
                $row['tab'] = $block->tab;
                $row['field_type'] = $row['class'];
                $row['default_value'] = $field->defaultValue;
                $out[''][$row['param_id']] = $row;
            }
        }

        return $out;
    }

    /**
     * Плоский список полей (без групп) из {@see getExtensionParams()}
     */
    public static function getExtensionFields(string $class, string $table = ''): array
    {
        $out = [];
        foreach (static::getExtensionParams($class, $table) as $rows) {
            foreach ($rows as $row) {
                if ($row['class']) {
                    $out[] = $row;
                }
            }
        }

        return $out;
    }

    /**
     * Табличный раздел таблицы по имени таблицы его модели: внешние ключи ссылаются на таблицы по имени
     *
     * @return class-string<Table>|null
     */
    public static function getTableClass(string $table): ?string
    {
        return static::getTableClasses()[$table] ?? null;
    }

    /**
     * @return array<string, class-string<Table>> имя таблицы (модели) => класс табличного раздела
     */
    public static function getTableClasses(): array
    {
        $out = [];
        foreach (static::getHandlerClasses() as $class) {
            if (is_subclass_of($class, Table::class)) {
                $out[$class::getTableName()] = $class;
            }
        }

        return $out;
    }

    /**
     * @return list<class-string<Handler>> обработчики ядра, расширений и сайта
     */
    public static function getHandlerClasses(): array
    {
        $normalize = fn(array $classes) => array_map(fn(string $class) => ltrim($class, '\\'), $classes);
        $core = $normalize(require Container::getPaths()->getCore('Admin/handlers.php'));

        $extension = [];
        foreach (ExtensionConfig::getAll() as $config) {
            $extension = array_merge($extension, $normalize($config->getAdminHandlers()));
        }

        $appFile = Container::getPaths()->getRoot('Admin/handlers.php');
        $app = is_file($appFile) ? $normalize(require $appFile) : [];

        // раздел сайта-наследник заменяет раздел расширения
        return array_values(array_unique(array_merge($core, ExtensionConfig::mergeClasses($extension, $app))));
    }

    /**
     * Поле, объявленное в коде, в виде записи, из которой создаются поля админки (Helper::create())
     */
    public static function toFieldRow(FieldDefinition $field, string $table): array
    {
        $field = $field->toArray();
        $field['label'] = $field['label'] ?? ucfirst($field['name']);
        $field['table'] = $table;
        $field['class'] = static::normalizeFieldType($field['class']);

        return $field;
    }

    /**
     * @return class-string<HasAdminParams>|''
     */
    protected static function extensionClass(string $class): string
    {
        $class = ltrim($class, '\\');
        return $class !== '' && is_a($class, HasAdminParams::class, true) ? $class : '';
    }

    protected static function extensionFieldRow(FieldDefinition $field, string $class, int|string $pid, string $table): array
    {
        $row = static::toFieldRow($field, $table);
        $row['param_id'] = static::stableId($class . '.field.' . $pid . '.' . $row['name']);
        $row['param_pid'] = $pid;
        $row['position'] = 'left';
        $row['field_type'] = $row['class'];

        return $row;
    }

    /**
     * Параметр боковых панелей формы, объявленный в коде, в виде записи, из которой создаются
     * поля админки
     */
    public static function toParamRow(ParamDefinition $param, string $table): array
    {
        $param = $param->toArray();
        $param['param_id'] = $param['param_id'] ?? static::stableId($table . '.param.' . $param['name']);
        $param['label'] = $param['label'] ?? ucfirst($param['name']);
        $param['table'] = $table;
        $param['class'] = static::normalizeFieldType((string)($param['class'] ?? ''));

        return $param;
    }

    protected static function normalizeFieldType(string $type): string
    {
        if ($type === '') {
            return '';
        }
        if (str_contains($type, '\\')) {
            return ltrim($type, '\\');
        }

        return 'Simflex\\Core\\Admin\\Fields\\' . $type;
    }

    protected static function stableId(string $value): int
    {
        return (int)sprintf('%u', crc32($value));
    }
}
