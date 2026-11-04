<?php

namespace Simflex\Core\Admin\Table;

/**
 * Поле таблицы админки, настроек модуля или шаблона страницы, объявленное в коде.
 * Указываются только аргументы, отличные от значений по умолчанию:
 * new FieldDefinition(name: 'title', class: FieldString::class, label: 'Заголовок', width: '1', required: true)
 */
readonly class FieldDefinition
{
    /**
     * @param string $class Тип поля: подкласс \Simflex\Core\Admin\Fields\Field
     * @param int|string $width Ширина колонки в списке: пиксели, доля 0..1 или '1' — остаток ширины
     *        (одна такая колонка в таблице). 0 — не в списке, только в форме
     * @param bool $e2n Пустое значение сохраняется как NULL
     * @param bool $filter Фильтр по полю над списком
     * @param bool $isFk, $fkTable, $fkKey, $fkLabel, $fkIsPid Внешний ключ: таблица, её ключ, колонка, показываемая
     *        вместо ключа, родитель в той же таблице. Проще через пресеты ForeignKeyField, ParentField
     * @param string $tab Вкладка формы: поля без вкладки — на первой («Основное»); вкладки видны, если их больше одной
     * @param array<string, mixed> $params Параметры типа поля, которых нет среди аргументов: структура FieldTable
     *        ('struct'), таблицы FieldMultiKey ('table_values', 'table_relations', 'key'...), формат FieldDouble
     *        ('decimals'...), подзапрос FieldVirtual ('subquery') и т.п. Попадают в params['main'] поля, где их читает
     *        класс поля; при совпадении имени заменяют значение аргумента
     */
    public function __construct(
        public string $name,
        public string $class,
        public ?string $label = null,
        public string $help = '',
        public string $placeholder = '',
        public bool $pk = false,
        public bool $e2n = false,
        public bool $hidden = false,
        public int|string $width = 0,
        public string $defaultValue = '',
        public bool $required = false,
        public bool $filter = false,
        public string $onchange = '',
        public bool $readonly = false,
        public string $styleCell = '',
        public int|string $screenWidth = 0,
        public int|string $widthMob = 0,
        public bool $isFk = false,
        public string $fkTable = '',
        public string $fkKey = '',
        public string $fkLabel = '',
        public bool $fkIsPid = false,
        public string $pos = '',
        public string $posGroup = '',
        public string $tab = '',
        public string $source = '',
        public string $path = '',
        public string $small = '',
        public string $medium = '',
        public string $large = '',
        public bool $editorMini = false,
        public bool $editorFull = false,
        public array $params = [],
    ) {
    }

    public function toArray(): array
    {
        return [
            'name' => $this->name,
            'label' => $this->label,
            'class' => $this->class,
            'help' => $this->help,
            'placeholder' => $this->placeholder,
            'params' => ['main' => $this->params + [
                'pk' => $this->pk,
                'e2n' => $this->e2n,
                'hidden' => $this->hidden,
                'width' => $this->width,
                'defaultValue' => $this->defaultValue,
                'required' => $this->required,
                'filter' => $this->filter,
                'onchange' => $this->onchange,
                'readonly' => $this->readonly,
                'style_cell' => $this->styleCell,
                'screen_width' => $this->screenWidth,
                'width_mob' => $this->widthMob,
                'is_fk' => $this->isFk,
                'fk_table' => $this->fkTable,
                'fk_key' => $this->fkKey,
                'fk_label' => $this->fkLabel,
                'fk_is_pid' => $this->fkIsPid,
                'pos' => $this->pos,
                'pos_group' => $this->posGroup,
                'tab' => $this->tab,
                'source' => $this->source,
                'path' => $this->path,
                'small' => $this->small,
                'medium' => $this->medium,
                'large' => $this->large,
                'editor_mini' => $this->editorMini,
                'editor_full' => $this->editorFull,
            ]],
        ];
    }
}
