<?php
/** @var array $data */

$separatorClasses = [
    'separator',
    "separator-orientation_{$data['orientation']}",
    "separator-theme_{$data['theme']}",
    $data['className'] ?? ''
];

$attributes = $data['attributes'] ?? [];
if ($data['decorative']) {
    $attributes['aria-hidden'] = 'true';
} else {
    $attributes['role'] = 'separator';
    $attributes['aria-orientation'] = $data['orientation'];
}
?>

<div class="<?= implode(' ', $separatorClasses) ?>" <?= buildAttrs($attributes) ?>></div>