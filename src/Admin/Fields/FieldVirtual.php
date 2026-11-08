<?php

namespace Simflex\Core\Admin\Fields;

class FieldVirtual extends Field
{
    public function __construct($row)
    {
        parent::__construct($row);
        $this->isVirtual = true;
    }

    /**
     * Шаблоны params text и href задаёт разработчик (разметка сохраняется); подставляемые значения строки
     * экранируются: в text — как HTML, в href — rawurlencode
     */
    public function show($row): string
    {
        $value = htmlspecialchars((string)$row[$this->name]);
        if ($this->params['text']) {
            $value = $this->params['text'];
            $matches = [];
            preg_match_all("@\{([\w]+)\}@Ui", $value, $matches);
            if (isset($matches[1])) {
                foreach ($matches[1] as $match) {
                    if (isset($row[$match])) {
                        $value = str_replace('{' . $match . '}', htmlspecialchars((string)$row[$match]), $value);
                    }
                }
            }
        }
        if ($this->params['href']) {
            $href = $this->params['href'];
            $matches = [];
            preg_match_all("@\{([\w]+)\}@Ui", $href, $matches);
            if (isset($matches[1])) {
                foreach ($matches[1] as $match) {
                    if (isset($row[$match])) {
                        $href = str_replace('{' . $match . '}', rawurlencode((string)$row[$match]), $href);
                    }
                }
            }
            if (@$this->params['in_modal']) {
                $href = "javascript:openModal('$href')";
            }
            $href = htmlspecialchars($href);
            $value = $this->render('link', ['href' => $href, 'class' => '', 'label' => $value, 'blank' => false]);
        }
        return (string)$value;
    }

    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        return '';
    }

    public function selectQueryField(): string
    {
        $subquery = $this->params['subquery'];
        $subquery = $subquery ? "($subquery)" : "''";
        return "$subquery $this->name";
    }
}
