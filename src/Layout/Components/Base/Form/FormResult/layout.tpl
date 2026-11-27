<?php
/** @var array $data */

$classes = [
    'result',
    "result-style_{$data['style']}",
    "result-type_{$data['type']}",
    "result-theme_{$data['theme']}",
    $data['className'] ?? '',
];
$attrs = ($data['attributes'] ?? []) + ['role' => $data['style'] === 'error' ? 'alert' : 'status'];
?>

<div class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attrs) ?>>
    <div class="result__content">
        <?= $data['markerHtml'] ?>
        <div class="result__body">
            <?php if ($data['title'] !== ''): ?>
                <p class="result__title"><?= htmlspecialchars($data['title']) ?></p>
            <?php endif; ?>
            <?php if ($data['text'] !== ''): ?>
                <p class="result__text"><?= htmlspecialchars($data['text']) ?></p>
            <?php endif; ?>
        </div>
    </div>
    <?= $data['buttonHtml'] ?>
</div>
