<?php
/** @var array $data */

$classes = ['toast', "toast_style_{$data['style']}", "toast_width_{$data['width']}", $data['className']];
?>
<div class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>"
     role="<?= $data['style'] === 'error' ? 'alert' : 'status' ?>" data-sf-toast
     style="--toast-timeout: <?= (int)$data['timeout'] ?>ms">
    <?= renderIcon($data['iconId'], 'toast__icon' . ($data['icon'] ? '' : ' toast__icon_hidden')) ?>
    <span class="toast__text"><?= htmlspecialchars($data['text']) ?></span>
    <?php if ($data['actionText'] !== ''): ?>
        <?php if ($data['actionLink'] !== ''): ?>
            <a class="toast__action" href="<?= htmlspecialchars($data['actionLink']) ?>"><?= htmlspecialchars($data['actionText']) ?></a>
        <?php else: ?>
            <button type="button" class="toast__action"><?= htmlspecialchars($data['actionText']) ?></button>
        <?php endif; ?>
    <?php endif; ?>
    <span class="toast__timer<?= $data['timer'] ? '' : ' toast__timer_hidden' ?>" aria-hidden="true"></span>
</div>
