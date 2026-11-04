<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\Media\Image;

class FieldImage extends FieldFile
{
    public array $sizes = [];

    public function __construct($row)
    {
        parent::__construct($row);
        if (!empty($this->params['small'])) {
            $this->sizes['small'] = $this->params['small'];
        }
        if (!empty($this->params['medium'])) {
            $this->sizes['medium'] = $this->params['medium'];
        }
        if (!empty($this->params['large'])) {
            $this->sizes['large'] = $this->params['large'];
        }
    }

    public function input($value): string
    {
        return $this->render('image', [
            'path' => $this->path,
            'name' => $this->name,
            'value' => (string)$value,
        ]);
    }

    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        $path = explode('/', (string)$this->getPosted());
        return end($path);
    }

    public function show($row): string
    {
        return (string)$this->showDetail($row);
    }

    public function showDetail($row): string
    {
        $value = $row[$this->name];
        $defaultImg = asset('img/default-img.png');

        return $this->render('image-preview', [
            'src' => $value ? '/uf/images/' . $this->path . 'preview/' . $value : '',
            'defaultImg' => $defaultImg,
        ]);
    }

    public function delete($value): bool
    {
        if ($this->required || $this->readonly) {
            return false;
        }
        $img = new Image($this->path);
        $img->delete($value);
        return true;
    }
}
