<?php

/**
 * Файл формы (Uploader, kind file): загрузка действием upload_file раздела в /uf/files, «Из библиотеки» — копия
 * файла из файлового менеджера. В скрытом поле — адрес файла, getPOST() берёт из него имя
 * @var \Simflex\Core\Admin\Fields\FieldFile $this
 * @var string $name
 * @var string $value Имя файла
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\Common\Uploader\Layout as Uploader;
use Simflex\Core\Layout\Components\Common\Uploader\UploaderKind;
use Simflex\Core\Layout\Components\Common\Uploader\UploaderTheme;

$prefix = '/uf/files/';
$recordId = $this->getRecordId();
$deleteUrl = $recordId && !$this->required
    ? '?action=delete_field&field_name=' . rawurlencode($name) . '&' . rawurlencode($this->tablePk) . '=' . $recordId
    : '';
?>
<?= Uploader::drawUploader(
    name: $name,
    value: $value !== '' ? $prefix . $value : '',
    kind: UploaderKind::File,
    previewUrl: $value !== '' ? $prefix . $value : '',
    fileName: $value,
    uploadUrl: '?action=upload_file',
    uploadField: 'file',
    valuePrefix: $prefix,
    library: true,
    // сохранённый файл: «Удалить» удаляет его и очищает поле в записи (Table::deleteField())
    deleteUrl: $deleteUrl,
    theme: UploaderTheme::from(Page::get()->getTheme()),
    disabled: $this->readonly,
    label: strip_tags((string)$this->label),
    className: 'form-input__uploader',
) ?>
<input type="hidden" name="<?= htmlspecialchars($name) ?>_old" value="<?= htmlspecialchars($value) ?>">
