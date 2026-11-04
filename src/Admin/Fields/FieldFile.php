<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\Media\File;

class FieldFile extends Field
{
    public string $path = '';

    public function __construct($row)
    {
        parent::__construct($row);
        if (!empty($this->params['path'])) {
            $path = $this->params['path'];
            if ($path) {
                $path = substr($path, 0, 1) === '/' ? substr($path, 1) : $path;
                $path = substr($path, -1) === '/' ? $path : $path . '/';
            }
            $this->path = $path;
        }
    }

    public function show($row): string
    {
        if ($row[$this->name]) {
            return $this->render('link', [
                'href' => '/uf/files/' . $this->params['path'] . '/' . $row[$this->name],
                'class' => '',
                'label' => $row[$this->name],
                'blank' => false,
            ]);
            return '';
        }
        return parent::show($row);
    }

    public function getValue($value): string
    {
        return $value === '' ? '&nbsp;' : $this->render('link', [
            'href' => '/' . $this->path . $value,
            'class' => '',
            'label' => $value,
            'blank' => true,
        ]);
    }

    public function input($value): string
    {
        if ($this->readonly) {
            return '';
        }

        return $this->render('file', [
            'name' => $this->name,
            'value' => (string)$value,
        ]);
    }

    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        $path = explode('/', (string)$this->getPosted());
        return end($path);
    }

    public function delete($name): bool
    {
        if ($this->required || $this->readonly) {
            return false;
        }
        $file = new File($this->path);
        $file->delete($name);
        return true;
    }

    public function check(): array
    {
        $errors = [];
        if ($this->required && empty($this->getRequest()->request($this->name . '_old')) && !is_uploaded_file((string)($this->getRequest()->file($this->name)['tmp_name'] ?? ''))) {
            $errors[] = 'Обязательно для заполнения';
        }
        return $errors;
    }
}
