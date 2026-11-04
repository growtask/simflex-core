<?php

namespace Simflex\Core\Admin\Table;

/**
 * Группа настроек модуля или компонента, выводится отдельным блоком в форме админки.
 * См. \Simflex\Core\System\ExtensionBase::adminParams()
 */
readonly class ParamGroup
{
    /**
     * @param FieldDefinition[] $fields
     * @param string $pos Колонка формы: left|right
     * @param string $tab Вкладка формы (как FieldDefinition::$tab)
     */
    public function __construct(
        public string $name,
        public string $label,
        public array $fields = [],
        public string $pos = 'left',
        public string $tab = '',
    ) {
    }
}
