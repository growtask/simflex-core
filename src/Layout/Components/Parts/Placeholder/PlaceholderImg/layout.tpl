<?php

/** @var array $data */

$rootClasses = trim(implode(' ', array_filter([
    'placeholder-img',
    $data['missing'] ? 'placeholder-img_missing' : '',
    $data['className'],
])));
$imgClasses = trim('placeholder-img__image ' . $data['imgClass']);

// Ленивая загрузка по умолчанию; значения вызывающего кода сильнее умолчаний
$imgAttrs = $data['attributes'] + ['loading' => 'lazy', 'decoding' => 'async'];
if ($data['width'] > 0) {
    $imgAttrs += ['width' => $data['width']];
}
if ($data['height'] > 0) {
    $imgAttrs += ['height' => $data['height']];
}

// deferred: источники лежат в data-srcset, пока картинка не показана; браузер ничего не качает
$deferred = $data['deferred'];
$srcsetAttr = $deferred ? 'data-srcset' : 'srcset';
// source для телефона и для широких экранов нужны, только когда картинки разные
$twoSources = $data['mobile'] !== $data['desktop'];
$esc = static fn (string $value): string => htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
?>
<picture class="<?= $esc($rootClasses) ?>">
    <?php if ($twoSources): ?>
        <?php
        $mobileAttrs = $data['srcMobileAttrs'] + ['media' => "(max-width: {$data['size']}px)", $srcsetAttr => $data['mobile']];
        $desktopAttrs = $data['srcAttrs'] + ['media' => '(min-width: ' . ($data['size'] + 1) . 'px)', $srcsetAttr => $data['desktop']];
        ?>
        <source <?= buildAttrs($mobileAttrs + ['data-type-source' => 'M']) ?>>
        <source <?= buildAttrs($desktopAttrs + ['data-type-source' => 'D']) ?>>
    <?php endif; ?>
    <img class="<?= $esc($imgClasses) ?>" src="<?= $esc($deferred ? $data['blank'] : $data['desktop']) ?>"
        <?= $deferred ? 'data-src="' . $esc($data['desktop']) . '"' : '' ?>
        alt="<?= $esc($data['alt']) ?>" <?= buildAttrs($imgAttrs) ?>>
</picture>
