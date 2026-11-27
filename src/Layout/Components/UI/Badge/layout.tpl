<?php
/** @var array $data */

// Счётчик «0» — тоже текст: пусто только при пустой строке
$hasText = $data['text'] !== '';
$badgeClasses = [
    'badge',
    "badge-{$data['style']}",
    "badge-size_{$data['size']}",
    ($data['icon'] && !$hasText && !$data['dot']) ? 'badge_icon-only' : '',
    $data['className'] ?? ''
];
?>

<div class="<?= implode(' ', array_filter($badgeClasses)) ?>" <?= buildAttrs($data['attributes'] ?? []) ?>>
    <?php if ($data['icon'] && !$data['dot']): ?>
        <?= renderIcon($data['icon'], 'badge__icon') ?>
    <?php endif; ?>

    <?php if ($data['dot']): ?>
        <svg xmlns="http://www.w3.org/2000/svg" class="badge__icon badge__dot" aria-hidden="true" viewBox="0 0 24 24">
            <circle cx="12" cy="12" r="8"/>
        </svg>
    <?php endif; ?>

    <?php if ($hasText): ?>
        <span class="badge__text"><?= $data['text'] ?></span>
    <?php endif; ?>
</div>
