<?php
/** @var array $data */

$isFilled = $data['value'] !== '';
$isImage = $data['kind'] === 'image';
$classes = ['uploader', "uploader-theme_{$data['theme']}", "uploader_kind_{$data['kind']}",
    $isFilled ? 'uploader_filled' : '', $data['disabled'] ? 'uploader_disabled' : '', $data['className']];
$attributes = $data['attributes'] + [
    'id' => $data['id'],
    'data-sf-uploader' => '',
    'data-upload-url' => $data['uploadUrl'],
    'data-upload-field' => $data['uploadField'],
    'data-upload-data' => json_encode($data['uploadData'], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
    'data-value-prefix' => $data['valuePrefix'],
];
if ($data['deleteUrl'] !== '' && $isFilled) {
    $attributes['data-delete-url'] = $data['deleteUrl'];
}
if ($data['label'] !== '') {
    $attributes['aria-label'] = $data['label'];
    $attributes['role'] = 'group';
}
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" <?= buildAttrs($attributes) ?>>
    <input type="hidden" name="<?= htmlspecialchars($data['name']) ?>" value="<?= htmlspecialchars($data['value']) ?>"
           data-sf-uploader-value>
    <div class="uploader__drop" data-sf-uploader-drop>
        <?= renderIcon('upload', 'uploader__drop-icon') ?>
        <p class="uploader__drop-title">Выберите файл или перетащите сюда</p>
        <?php if ($data['hint'] !== ''): ?>
            <p class="uploader__hint"><?= htmlspecialchars($data['hint']) ?></p>
        <?php endif; ?>
        <div class="uploader__buttons"><?= $data['pick'] ?><?= $data['fromLibrary'] ?></div>
    </div>
    <div class="uploader__file" data-sf-uploader-file>
        <a class="uploader__preview" href="<?= htmlspecialchars($data['previewUrl']) ?>" target="_blank" rel="noopener"
           tabindex="-1" aria-hidden="true">
            <?php if ($isImage): ?>
                <img class="uploader__image" src="<?= htmlspecialchars($data['previewUrl']) ?>" alt="">
            <?php endif; ?>
            <?= renderIcon('file-check', 'uploader__file-icon') ?>
        </a>
        <div class="uploader__info">
            <a class="uploader__name" href="<?= htmlspecialchars($data['previewUrl']) ?>" target="_blank"
               rel="noopener"><?= htmlspecialchars($data['fileName']) ?></a>
            <span class="uploader__meta" data-sf-uploader-meta></span>
            <span class="uploader__progress" hidden><span class="uploader__progress-bar"></span></span>
        </div>
        <div class="uploader__actions"><?= $data['replace'] ?><?= $data['remove'] ?></div>
    </div>
    <p class="uploader__error" role="alert" hidden></p>
    <input class="uploader__input" type="file" tabindex="-1" aria-hidden="true"
        <?= $data['accept'] !== '' ? 'accept="' . htmlspecialchars($data['accept']) . '"' : '' ?>>
</div>
