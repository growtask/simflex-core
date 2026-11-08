<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\Http\Request;
use Simflex\Core\Http\View;
use Simflex\Core\System\Container;

class Field
{
    public string $form = '';
    public string $name = '';
    public string $label = '';
    public bool $pk = false;
    public string $table = '';
    public string $tablePk = '';
    public string $help = '';
    public string $placeholder = '';
    public array $params = [];

    public ForeignKey|false $fk = false;
    public float $width = 0;
    public float $widthMob = 0;
    public bool $isVisible = true;
    public string $link = '';
    public bool $isnull = false;
    public bool $e2n = false;
    public mixed $defaultValue = '';
    public bool $autoIncrement = false;
    public bool $required = false;
    public string $editor = '';
    public bool $filter = false;

    /* ВВОД */
    public array $styleCol = [];
    public string $styleCell = '';
    public bool $hidden = false;
    public bool $readonly = false;
    public string $onchange = '';
    protected array $tree = [];
    public string|int|float|bool|array|null $value = '';
    public string|int $pkValue = '';
    protected int $pid;

    protected bool $isNumeric = false;

    /** Колонки у поля нет (FieldVirtual, FieldMultiKey и др.): значение не пишется в таблицу раздела */
    public bool $isVirtual = false;

    /**
     * Поле пишет свои данные по id записи (таблицы связей FieldMultiKey, FieldRelation). У новой записи id ещё нет:
     * Table::save() вызывает getPOST() таких полей ещё раз после вставки, а до неё они ничего не пишут
     */
    public bool $isSavedById = false;

    /** @var array|null Отправленные значения формы, если не POST запроса (группа параметров, см. setPosted()) */
    protected ?array $posted = null;

    public function __construct($row)
    {
        $this->name = $row['name'];
        $this->label = $row['label'];
        $this->table = $row['table'];
        $this->help = (string)@$row['help'];
        $this->placeholder = (string)@$row['placeholder'];

        if (isset($row['params']) && is_string($row['params'])) {
            $row['params'] = unserialize($row['params']);
        }

        $params = isset($row['params']['main']) ? $row['params']['main'] : [];
        $this->params = $params;

        $this->setWidth(@$params['width']);

        if ($params['width_mob'] ?? '') {
            $this->widthMob = (float)$params['width_mob'];
        }

        if (!empty($params['pk'])) {
            $this->pk = (bool)$params['pk'];
        }
        if (!empty($params['is_fk'])) {
            $this->fk = new ForeignKey($params);
        }
        if (!empty($params['style_col'])) {
            $this->styleCol['from_param'] = $params['style_col'];
        }
        if (!empty($params['style_cell'])) {
            $this->styleCell .= $params['style_cell'];
        }
        if (!empty($params['link'])) {
            $this->link = $params['link'];
        }
        if (!empty($params['hidden'])) {
            $this->hidden = (bool)$params['hidden'];
        }
        if (!empty($params['e2n'])) {
            $this->e2n = (bool)$params['e2n'];
            $this->isnull = (bool)$params['e2n'];
        }
        if (!empty($params['isnull'])) {
            $this->isnull = (bool)$params['isnull'];
        }
        if (!empty($params['defaultValue'])) {
            $this->defaultValue = $params['defaultValue'];
        }
        if (!empty($params['autoIncrement'])) {
            $this->autoIncrement = $params['autoIncrement'];
        }
        if (!empty($params['required'])) {
            $this->required = (bool)(int)$params['required'];
        }
        if (!empty($params['readonly'])) {
            $this->readonly = (bool)(int)$params['readonly'];
        }
        if (!empty($params['editor'])) {
            $this->editor = $params['editor'];
        }

        if (!empty($params['filter'])) {
            $this->filter = $params['filter'];
        }

        if (!empty($params['onchange'])) {
            $this->onchange = $params['onchange'];
        }
    }

    /**
     *
     * @param float $width
     */
    public function setWidth($width): void
    {
        $this->width = (empty($width) || (int)$width === 0) ? 0 : (float)$width;
        $this->isVisible = $this->width > 0;
        $this->styleCol['width'] = $this->width > 1
            ? 'width: ' . $this->width . 'px'
            : (($this->width < 1 && $this->width > 0) ? 'width: ' . round($this->width * 100) . '%' : '');
    }

    public static function setFieldValue(Field &$field, $group, $params, $row): void
    {
        $p = false;
        $params = $params ?: [];
        $value = '';
        if (is_array($group) && $group['name']) {
            $value = isset($params[$group['name']]) && array_key_exists($field->name, $params[$group['name']])
                ? $params[$group['name']][$field->name]
                : $field->defaultValue;
        } else {
            $value = array_key_exists($field->name, $params) ? $params[$field->name] : $field->defaultValue;
        }
        if ($p) {
            $value = $row[$field->name];
        }
        $field->value = $value;
    }

    /**
     * Поле формы занимает всю строку сетки (form-input_wide): длинный текст, редактор, таблица, список значений
     */
    public function isWide(): bool
    {
        return !empty($this->params['editor_full']) || !empty($this->params['editor_mini']);
    }

    public function input($value): string
    {
        return $this->render('input', ['value' => $value] + $this->inputVars());
    }

    /**
     * Рендерит шаблон из каталога tpl рядом с этим файлом
     *
     * @param string $tpl Имя шаблона без расширения
     * @param array<string, mixed> $vars Переменные, доступные в шаблоне как $name, вместе с $this
     */
    protected function render(string $tpl, array $vars = []): string
    {
        return View::render(__DIR__ . '/tpl/' . $tpl . '.tpl', $vars, $this);
    }

    protected function inputVars(): array
    {
        return [
            'name' => $this->inputName(),
            'placeholder' => $this->placeholder,
            'readonly' => $this->readonly,
        ];
    }

    protected function cell(string $value, string $kind = 'text'): string
    {
        return $this->render('cell', [
            'name' => $this->name,
            'isId' => (bool)$this->fk,
            'kind' => $kind,
            'value' => $value,
        ]);
    }

    /**
     * Выпадающий список поля (Dropdown из Layout): варианты, поиск по ним; с action — поиск вариантов на сервере
     * (?action=<action>&name=<поле>&text=..., ответ JSON [{id, name}]). Выбор — событие change на скрытом поле
     * (атрибут onchange поля и data-* передаются ему)
     *
     * @param array $vars name, value, onchange, data, readonly, disabled, action, search, current, items
     *        [[value, label]], placeholder, className, ariaLabel
     */
    protected function dropdown(array $vars): string
    {
        $options = [];
        foreach ($vars['items'] ?? [] as [$itemValue, $itemLabel]) {
            $options[(string)$itemValue] = html_entity_decode(strip_tags((string)$itemLabel));
        }
        $value = (string)($vars['value'] ?? '');
        if ($value !== '' && !isset($options[$value]) && ($vars['current'] ?? '') !== '') {
            $options = [$value => html_entity_decode(strip_tags((string)$vars['current']))] + $options;
        }
        $inputAttributes = (array)($vars['data'] ?? []);
        if (($vars['onchange'] ?? '') !== '' && $vars['onchange'] !== null) {
            $inputAttributes['onchange'] = (string)$vars['onchange'];
        }
        $action = (string)($vars['action'] ?? '');
        $name = (string)($vars['name'] ?? '');

        return \Simflex\Core\Layout\Components\UI\Core\Dropdown\Layout::drawSelect(
            $name,
            $options,
            $value === '' && !isset($options['']) ? null : $value,
            placeholder: (string)($vars['placeholder'] ?? '—'),
            size: \Simflex\Core\Layout\Components\UI\Core\Dropdown\DropdownSize::Small,
            theme: \Simflex\Core\Layout\Components\UI\Core\Dropdown\DropdownTheme::from(
                \Simflex\Core\Admin\Page::get()->getTheme()
            ),
            search: !empty($vars['search']) || count($options) > 10,
            disabled: !empty($vars['disabled']) || !empty($vars['readonly']),
            className: (string)($vars['className'] ?? 'form-dropdown'),
            attributes: ['aria-label' => (string)($vars['ariaLabel'] ?? strip_tags((string)$this->label))],
            searchUrl: $action !== '' ? '?' . http_build_query(['action' => $action, 'name' => $name]) : '',
            inputAttributes: $inputAttributes,
        );
    }

    public function inputName(): string
    {
        return $this->form ? $this->form . '[' . $this->name . ']' : $this->name;
    }

    public function inputHidden($value): string
    {
        $value = $this->value ?: $value;
        return $this->render('input-hidden', ['name' => $this->inputName(), 'value' => $value]);
    }

    /**
     * Значения формы, из которых поле берёт своё значение (getPosted()): по умолчанию - POST запроса,
     * для полей группы параметров раздел передаёт значения группы. null - снова POST запроса
     */
    public function setPosted(?array $posted): void
    {
        $this->posted = $posted;
    }

    /**
     * Отправленное значение формы
     * @param string|null $name Имя значения, по умолчанию - имя поля
     * @param string|int|null $group Группа: значение $posted[$group][$name]
     */
    protected function getPosted(?string $name = null, string|int|null $group = null): mixed
    {
        $posted = $this->posted ?? $this->getRequest()->post();
        if ($group !== null) {
            $posted = $posted[$group] ?? [];
        }

        return $posted[$name ?? $this->name] ?? null;
    }

    /**
     * Id записи раздела: pkValue (после вставки новой записи его задаёт раздел) или параметр запроса
     */
    protected function getRecordId(): int
    {
        return (int)($this->pkValue ?: $this->getRequest()->request($this->tablePk, 0));
    }

    protected function getRequest(): Request
    {
        return Container::getRequest() ?? new Request();
    }

    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        if ($simple) {
            return $this->getPosted(group: $group);
        }
        $value = $this->getPosted();
        return $this->e2n && $value === '' ? null : $value;
    }

    public function check(): array
    {
        $errors = [];
        if ($this->required && in_array($this->getPosted(), [null, ''], true)) {
            $errors[] = 'Обязательно для заполнения';
        }
        return $errors;
    }

    public function show($row): string
    {
        $value = $this->value ?: $row[$this->name . ($this->fk ? '_label' : '')];
        // значение поля — текст записи: экранируется целиком. Разметка в ячейке — только из showCell() раздела
        $value = htmlspecialchars((string)$value);

        if ($this->name === 'name') {
            return $this->render('link', [
                'href' => '?action=form&' . $this->tablePk . '=' . $this->pkValue,
                'class' => 'table__row-' . $this->name,
                'label' => $value,
                'blank' => false,
            ]);
        } else {
            $isNumericReal = $this->isNumeric || ((string)intval($value) == $value);
            return $this->cell($value, $isNumericReal ? 'num' : 'text');
        }
    }

    /**
     * Показывать в карточке записи в режиме просмотра
     */
    public function showDetail($row): ?string
    {
        return htmlspecialchars((string)$row[$this->name . ($this->fk ? '_label' : '')]);
    }

    public function delete($value): bool
    {
        return true;
    }

    public function defval(): mixed
    {
        return $this->defaultValue;
    }

    public function filter($value): string
    {
        if ($this->filter) {
            $inExtra = $this->width === 0.0;
            return $this->render('filter', [
                'name' => $this->name,
                'placeholder' => $inExtra ? $this->label : '',
                'value' => $value,
                'isDigits' => false,
            ]);
        }
        return '';
    }

    /**
     * Значения фильтра колонки, из которых выбирается одно (значение => подпись): меню фильтра в шапке списка
     * показывает их переключателями radio. null — фильтр без готового списка (поиск по тексту, поиск записи на
     * сервере), в меню выводится сам фильтр filter()
     * @return array<string, string>|null
     */
    public function getFilterOptions(): ?array
    {
        return null;
    }

    /**
     * Значения getFilterOptions() пунктами Dropdown: [значение, подпись]
     * @return list<array{0: string, 1: string}>
     */
    protected function getFilterItems(): array
    {
        $items = [];
        foreach ($this->getFilterOptions() ?? [] as $value => $label) {
            $items[] = [(string)$value, $label];
        }
        return $items;
    }

    /**
     * Подпись выбранного значения фильтра для тега над списком
     */
    public function getFilterLabel(string $value): string
    {
        return $value === 'null' ? '—' : $value;
    }

    /**
     * Фильтр «период» (FieldDate, FieldDateTime): «От» и «До» с календарём, значение — DateRange
     */
    protected function filterDateRange(mixed $value): string
    {
        if (!$this->filter) {
            return '';
        }
        [$from, $to] = DateRange::parse((string)$value);

        return $this->render('filter-date', [
            'name' => $this->name,
            'label' => strip_tags($this->label),
            'value' => $from !== null || $to !== null ? $from . DateRange::SEPARATOR . $to : '',
            'from' => DateRange::toLocal($from),
            'to' => DateRange::toLocal($to),
        ]);
    }

    /**
     * Фильтр-список (Dropdown из Layout) в меню фильтра колонки и окне фильтров списка (theme/js/list.js)
     * @param array{name: string, value: mixed, items: list<array{0: mixed, 1: string}>, action?: string,
     *        search?: bool} $vars
     */
    protected function filterDropdown(array $vars): string
    {
        $items = array_values(array_filter($vars['items'], fn(array $item) => (string)$item[0] !== ''));
        $value = (string)($vars['value'] ?? '');

        return $this->dropdown([
            'name' => $vars['name'],
            'value' => $value,
            'items' => [['', 'Все'], ...$items],
            'action' => $vars['action'] ?? '',
            'search' => $vars['search'] ?? false,
            'current' => $value !== '' ? $this->getFilterLabel($value) : '',
            'placeholder' => 'Все',
            'className' => 'filter-select',
            'ariaLabel' => 'Фильтр: ' . strip_tags($this->label),
        ]);
    }

    /**
     * Регистрирует ресурсы поля, возвращает HTML, нужный интерфейсу поля (скрипты инициализации)
     */
    public function loadUI(bool $onForm = false): string
    {
        return '';
    }

    public function selectQueryField(): string
    {
        return '' . $this->table . '.' . $this->name;
    }
}
