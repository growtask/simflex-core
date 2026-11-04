<?php
/** @var array $data */

$theme = $data['theme'];
?>
<?php if ($data['view'] === 'avatar'): ?>
    <?php $classes = "avatar avatar_size_{$data['size']} avatar_style_{$data['style']} placeholder-theme_$theme {$data['className']}"; ?>
    <?php if ($data['image'] !== ''): ?>
        <img class="<?= htmlspecialchars(trim($classes)) ?>" src="<?= htmlspecialchars($data['image']) ?>"
             alt="<?= htmlspecialchars($data['name']) ?>">
    <?php else: ?>
        <span class="<?= htmlspecialchars(trim($classes)) ?>" role="img" aria-label="<?= htmlspecialchars($data['name']) ?>">
            <?php if ($data['style'] === 'initials'): ?>
                <span class="avatar__initials" aria-hidden="true"><?= htmlspecialchars($data['initials']) ?></span>
            <?php else: ?>
                <?= renderIcon('user', 'avatar__icon') ?>
            <?php endif; ?>
        </span>
    <?php endif; ?>
<?php else: ?>
    <span class="no-image placeholder-theme_<?= $theme ?> <?= htmlspecialchars($data['className']) ?>" role="img"
          aria-label="<?= htmlspecialchars($data['label']) ?>"><?= renderIcon('image', 'no-image__icon') ?></span>
<?php endif; ?>
