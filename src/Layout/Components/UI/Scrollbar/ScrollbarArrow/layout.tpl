<?php
/** @var array $data */

$icon = ($data['size'] === 'l' ? 'chevron-m-' : 'chevron-s-') . $data['style'];
$classes = ['scrollbar', 'scrollbar-style_classic', "scrollbar-size_{$data['size']}", "scrollbar-theme_{$data['theme']}", $data['className']];
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" style="display:inline-block;height:auto">
    <button type="button" class="scrollbar__arrow" tabindex="-1" aria-label="<?= $data['style'] ?>"><?= renderIcon($icon, 'scrollbar__arrow-icon') ?></button>
</div>
