<?php
/** @var array $data */

$classes = [
    'loader-overlay',
    "loader-overlay-theme_{$data['theme']}",
    $data['active'] ? 'loader-overlay_active' : '',
    $data['className'],
];
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>"<?= $data['active'] ? ' aria-busy="true"' : '' ?>>
    <div class="loader-overlay__content"><?= $data['content'] ?></div>
    <div class="loader-overlay__scrim"><?= $data['loader'] ?></div>
</div>
