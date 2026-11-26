<?php
/** @var array $data */

$vertical = $data['direction'] === 'vertical';
$classes = [
    'scrollbar',
    "scrollbar-style_{$data['style']}",
    "scrollbar-size_{$data['size']}",
    "scrollbar-theme_{$data['theme']}",
    "scrollbar_{$data['direction']}",
    $data['arrows'] ? 'scrollbar_arrows' : '',
    $data['className'],
];
$prev = $vertical ? 'up' : 'left';
$next = $vertical ? 'down' : 'right';
$arrowIcon = $data['size'] === 'l' ? 'chevron-m-' : 'chevron-s-';
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>"<?= $data['height'] !== '' ? ' style="height:' . htmlspecialchars($data['height']) . '"' : '' ?>>
    <div class="scrollbar__viewport" tabindex="0"<?= $data['label'] !== '' ? ' role="region" aria-label="' . htmlspecialchars($data['label']) . '"' : '' ?>><?= $data['content'] ?></div>
    <div class="scrollbar__bar" aria-hidden="true">
        <div class="scrollbar__rail">
            <?php if ($data['arrows']): ?>
                <button type="button" class="scrollbar__arrow" data-scrollbar-step="-1" tabindex="-1"><?= renderIcon($arrowIcon . $prev, 'scrollbar__arrow-icon') ?></button>
            <?php endif; ?>
            <span class="scrollbar__track"><span class="scrollbar__thumb"></span></span>
            <?php if ($data['arrows']): ?>
                <button type="button" class="scrollbar__arrow" data-scrollbar-step="1" tabindex="-1"><?= renderIcon($arrowIcon . $next, 'scrollbar__arrow-icon') ?></button>
            <?php endif; ?>
        </div>
    </div>
</div>
