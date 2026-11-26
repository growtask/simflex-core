<?php
/** @var array $data */

$classes = [
    'loader-inline',
    "loader-inline_size_{$data['size']}",
    "loader-inline-theme_{$data['theme']}",
    $data['className'],
];
?>
<span class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>">
    <?= $data['loader'] ?>
    <span class="loader-inline__text"><?= htmlspecialchars($data['text']) ?></span>
</span>
