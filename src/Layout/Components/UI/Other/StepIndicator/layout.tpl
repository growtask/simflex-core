<?php
/** @var array $data */

$stepClasses = [
    'step-indicator',
    "step-indicator-size_{$data['size']}",
    "step-indicator-theme_{$data['theme']}",
    $data['className'] ?? ''
];

// Полосы декоративные: текущая страница передаётся скринридеру значением и подписью
$attrs = ($data['attributes'] ?? []) + ['role' => 'group'];
if ($data['label'] !== '') {
    $attrs += ['aria-label' => $data['label']];
}
?>

<div class="<?= htmlspecialchars(implode(' ', $stepClasses)) ?>" data-count="<?= (int)$data['count'] ?>" data-active="<?= (int)$data['active'] ?>" <?= buildAttrs($attrs) ?>>
    <?php for ($i = 0; $i < $data['count']; $i++): ?>
        <span class="step-indicator__item<?= $i === $data['active'] ? ' step-indicator__item_active' : '' ?>" aria-hidden="true"></span>
    <?php endfor; ?>
    <span class="visually-hidden"><?= (int)$data['active'] + 1 ?> / <?= (int)$data['count'] ?></span>
</div>
