<?php

namespace Simflex\Core\Extensions\Content;

use Simflex\Core\Admin\Table\FieldDefinition;

/**
 * Блок полей шаблона страницы в форме страницы. Блок только группирует их на экране:
 * значения хранятся в content.params по имени поля, а не по блоку
 */
readonly class ContentTemplateBlock
{
    /**
     * @param string $label Заголовок блока
     * @param FieldDefinition[] $fields
     * @param string $pos Колонка формы: left|right
     * @param string $tab Вкладка формы (как FieldDefinition::$tab)
     */
    public function __construct(
        public string $label,
        public array $fields,
        public string $pos = 'left',
        public string $tab = '',
    ) {
    }
}
