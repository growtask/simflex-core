<?php

/**
 * Картинка формы (Uploader, kind image): загрузка действием upload_img раздела в /uf/images/<path>, «Из библиотеки»
 * — копия файла из файлового менеджера с теми же размерами. В скрытом поле — адрес исходника, getPOST() берёт
 * из него имя файла
 * @var \Simflex\Core\Admin\Fields\FieldImage $this
 * @var string $name
 * @var string $value Имя файла
 * @var string $path Подкаталог в /uf/images
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\Common\Uploader\Layout as Uploader;
use Simflex\Core\Layout\Components\Common\Uploader\UploaderKind;
use Simflex\Core\Layout\Components\Common\Uploader\UploaderTheme;

$prefix = '/uf/images/' . $path . 'source/';
$recordId = $this->getRecordId();
$deleteUrl = $recordId && !$this->required
    ? '?action=delete_field&field_name=' . rawurlencode($name) . '&' . rawurlencode($this->tablePk) . '=' . $recordId
    : '';
?>
<?= Uploader::drawUploader(
    name: $name,
    value: $value !== '' ? $prefix . $value : '',
    kind: UploaderKind::Image,
    previewUrl: $value !== '' ? '/uf/images/' . $path . 'preview/' . $value : '',
    fileName: $value,
    accept: 'image/*',
    uploadUrl: '?action=upload_img',
    uploadField: 'img',
    uploadData: ['path' => $path],
    valuePrefix: $prefix,
    hint: 'JPG, PNG, GIF, WebP или SVG',
    library: true,
    // сохранённый файл: «Удалить» удаляет его и очищает поле в записи (Table::deleteField())
    deleteUrl: $deleteUrl,
    theme: UploaderTheme::from(Page::get()->getTheme()),
    disabled: $this->readonly,
    label: strip_tags((string)$this->label),
    className: 'form-input__uploader',
) ?>
<input type="hidden" name="<?= htmlspecialchars($name) ?>_old" value="<?= htmlspecialchars($value) ?>">
