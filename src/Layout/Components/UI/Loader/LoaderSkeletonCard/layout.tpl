<?php
/** @var array $data */

$classes = ['skeleton-card', "skeleton-card-theme_{$data['theme']}", $data['className']];
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" aria-hidden="true">
    <div class="skeleton-card__head">
        <?= $data['avatar'] ?>
        <div class="skeleton-card__lines"><?= $data['title'] ?><?= $data['line'] ?></div>
    </div>
    <?= $data['image'] ?>
</div>
