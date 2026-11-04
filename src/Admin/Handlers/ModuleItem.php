<?php

namespace Simflex\Core\Admin\Handlers;

use Simflex\Core\Admin\Fields\FieldBool;
use Simflex\Core\Admin\Fields\FieldModuleSelect;
use Simflex\Core\Admin\Fields\FieldString;
use Simflex\Core\Admin\Fields\FieldText;
use Simflex\Core\Admin\Fields\Helper;
use Simflex\Core\Admin\Page;
use Simflex\Core\Admin\Plugins\Editor\Editor;
use Simflex\Core\Admin\Table\FieldDefinition;
use Simflex\Core\Admin\Table\ParamDefinition;
use Simflex\Core\Admin\Table\Presets\ActiveField;
use Simflex\Core\Admin\Table\Presets\ForeignKeyField;
use Simflex\Core\Admin\Table\Presets\IdField;
use Simflex\Core\Admin\Table\Presets\NppField;
use Simflex\Core\Admin\Table\Repository;
use Simflex\Core\Admin\Table\Table;
use Simflex\Core\System\ExtensionRegistry;
use Simflex\Core\Models\ModuleItem as ModuleItemModel;

/**
 * Модули, размещённые на страницах сайта. Настройки модуля (ExtensionBase::adminParams()) загружаются в форму
 * через ajax при выборе модуля и хранятся в params
 */
class ModuleItem extends Table
{
    protected static string $model = ModuleItemModel::class;
    protected static ?string $defaultOrderBy = 'npp';

    public static function getFields(): array
    {
        return [
            new ActiveField(),
            new IdField(
                name: 'item_id',
                width: '80',
                filter: true,
                widthMob: '40',
            ),
            new NppField(),
            new FieldDefinition(
                name: 'name',
                class: FieldString::class,
                label: 'Наименование',
                width: '1',
                widthMob: '200',
            ),
            new FieldDefinition(
                name: 'posname',
                class: FieldString::class,
                label: 'Позиция',
                width: '200',
                filter: true,
            ),
            new FieldDefinition(
                name: 'module',
                class: FieldModuleSelect::class,
                label: 'Модуль',
                width: '200',
                filter: true,
            ),
            new ForeignKeyField(
                name: 'menu_id',
                label: 'Меню',
                table: 'menu',
                width: '200',
            ),
            new FieldDefinition(
                name: 'params',
                class: FieldText::class,
                label: 'Параметры',
                hidden: true,
            ),
        ];
    }

    public static function getParams(): array
    {
        return [
            new ParamDefinition(
                name: 'module_item_main',
                label: 'Параметры',
                paramId: 27,
                paramPid: '',
                pos: 'right',
            ),
            new ParamDefinition(
                name: 'is_title',
                label: 'Показывать заголовок',
                class: FieldBool::class,
                paramId: 28,
                paramPid: '',
                pos: 'right',
            ),
            new ParamDefinition(
                name: 'is_wrap',
                label: 'Выводить обертку',
                class: FieldBool::class,
                paramId: 29,
                paramPid: '',
                pos: 'right',
            ),
            new ParamDefinition(
                name: 'cssclass',
                label: 'CSS Класс',
                class: FieldString::class,
                paramId: 30,
                paramPid: '',
                pos: 'right',
            ),
        ];
    }

    public function __construct()
    {
        parent::__construct();
        Page::get()->coreJsModule('/Table/js/moduleitem.js');
        // в параметрах модуля может быть визуальный редактор: его инициализацию (FieldText) вернёт module_param
        if ($this->request->get('action') === 'form') {
            Editor::addScript();
        }
        $this->actionHandlers['module_param'] = ['method' => 'moduleParam'];
    }

    protected function moduleParam(): string
    {
        $moduleClass = (string)$this->request->get('module');
        $itemId = (int)$this->request->get('item_id');

        $module = ExtensionRegistry::module($moduleClass);
        $moduleClass = $module ? ltrim($moduleClass, '\\') : '';

        $rows = Repository::getExtensionParams($moduleClass, $this->table);
        $tableParams = $itemId
            ? (ModuleItemModel::findOne(['item_id' => $itemId])?->getParams() ?: [])
            : [];
        $positions = ['left' => '', 'right' => ''];
        if (count($rows)) {
            $hasWithoutGroup = false;
            foreach ($rows[''] as $pid => $row) {
                if (!isset($rows[$pid]) && $row['class']) {
                    $hasWithoutGroup = true;
                    break;
                }
            }

            if ($hasWithoutGroup) {
                foreach ($rows[''] as $row) {
                    if ($row['class']) {
                        $field = Helper::create($row);
                        $field->value = $tableParams[$row['name']] ?? $field->defaultValue;
                        $fields[] = $field;
                        // скрипты поля (инициализация редактора)
                        $positions['right'] .= $field->loadUI(true);
                    }
                }
                $group = ['label' => 'Параметры'];
                $group['fields'] = $fields;
                $portletClass = 'field-params-nogroup';
                $positions['right'] .= $this->render(__DIR__ . '/../Table/tpl/form.portlet.tpl', get_defined_vars());
            }

            foreach ($rows[''] as $pid => $row0) {
                $fields = [];
                if (!isset($rows[$pid])) {
                    continue;
                }
                foreach ($rows[$pid] as $row) {
                    $field = new $row['class']($row);
                    $field->value = $tableParams[$row['name']] ?? $field->defaultValue;
                    $fields[] = $field;
                    $positions[$row0['position']] .= $field->loadUI(true);
                }

                $group = ['label' => $row0['label']];
                $group['fields'] = $fields;
                $portletClass = "field-params-{$row0['name']}";
                $positions[$row0['position']] .= $this->render(__DIR__ . '/../Table/tpl/form.portlet.tpl', get_defined_vars());
            }
        }

        return json_encode($positions);
    }

    protected function getPostedParams(): array
    {
        $params = parent::getPostedParams();
        if (!empty($this->request->post('module'))) {
            $class = ExtensionRegistry::module((string)$this->request->post('module')) ? ltrim((string)$this->request->post('module'), '\\') : '';
            // поля модуля загружаются в форму через ajax: неотправленные сохраняют прежние значения
            $itemId = (int)($this->request->request('item_id', 0));
            $saved = $itemId ? (ModuleItemModel::findOne(['item_id' => $itemId])?->getParams() ?: []) : [];
            foreach (Repository::getExtensionFields($class, $this->table) as $row) {
                $field = new $row['class']($row);
                if (!array_key_exists($field->name, $this->request->post())) {
                    if (array_key_exists($field->name, $saved)) {
                        $params[$field->name] = $saved[$field->name];
                    }
                    continue;
                }
                $value = $field->getPost(true);
                $value = preg_replace("@^'(.+)'$@", '$1', $value);
                $params[$field->name] = $value;
            }
        }
        return $params;
    }
}
