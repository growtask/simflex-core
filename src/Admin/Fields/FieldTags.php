<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\DB\AQ;
use Simflex\Core\DB\DB;

class FieldTags extends Field
{
    public function isWide(): bool
    {
        return true;
    }

    public array $values = [];

    public function input($value): string
    {
        if (!$this->values) {
            // загрузка данных
            $query = new AQ()->select('DISTINCT ' . DB::wrapName($this->name))->from($this->table);
            foreach ($query->fetchColumn() as $tags) {
                if ($tags) {
                    array_push($this->values, ...explode(',', (string)$tags));
                }
            }
            $this->values = array_values(array_unique($this->values));
        }

        $selected = array_values(array_filter(array_map('trim', explode(',', (string)$value)), 'strlen'));
        return $this->render('tags', [
            'name' => $this->name,
            'selected' => array_combine($selected, $selected),
            'options' => array_combine($this->values, $this->values),
            'searchUrl' => '',
            'allowNew' => true,
        ]);
    }
}
