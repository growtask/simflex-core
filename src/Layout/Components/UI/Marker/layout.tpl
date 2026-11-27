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
    <?php if (!empty($data['drawn'])): ?>
        <svg class="marker__icon marker__check" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 12l5 5L20 6" pathLength="1"/></svg>
    <?php elseif ($data['icon'] !== ''): ?>
        <?= renderIcon($data['icon'], 'marker__icon') ?>
    <?php else: ?>
        <?= Simflex\Core\Layout\Components\UI\Loader\LoaderMain\Layout::draw(['className' => 'marker__icon']) ?>
    <?php endif; ?>
</div>
