<?php
/** @var array $data */

$classes = [
    'loader-dots',
    "loader-dots_size_{$data['size']}",
    "loader-dots_style_{$data['style']}",
    "loader-dots-theme_{$data['theme']}",
    $data['animation'] ? '' : 'loader-dots_static',
    $data['className'],
];
?>
<span class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" role="status" aria-label="<?= htmlspecialchars($data['label']) ?>">
    <span class="loader-dots__dot"></span><span class="loader-dots__dot"></span><span class="loader-dots__dot"></span>
</span>
