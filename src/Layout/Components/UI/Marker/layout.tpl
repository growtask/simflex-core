<?php
/** @var array $data */

$markerClasses = [
    'marker',
    "marker-{$data['style']}",
    "marker-size_{$data['size']}",
    "marker-theme_{$data['theme']}",
    $data['className'] ?? ''
];

$attributes = $data['attributes'] ?? [];
if ($data['label'] !== '') {
    $attributes['role'] = 'status';
    $attributes['aria-label'] = $data['label'];
}
?>

<div class="<?= implode(' ', array_filter($markerClasses)) ?>" <?= buildAttrs($attributes) ?>>
    <?php if ($data['icon'] !== ''): ?>
        <?= renderIcon($data['icon'], 'marker__icon') ?>
    <?php else: ?>
        <?= Simflex\Core\Layout\Components\UI\Loader\LoaderMain\Layout::draw(['className' => 'marker__icon']) ?>
    <?php endif; ?>
</div>
