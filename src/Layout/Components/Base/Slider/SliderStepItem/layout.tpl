<?php
/** @var array $data */

$classes = ['step-indicator__item', $data['active'] ? 'step-indicator__item_active' : '', $data['className']];
?>
<span class="step-indicator step-indicator-size_<?= $data['size'] ?> step-indicator-theme_<?= $data['theme'] ?>" aria-hidden="true"><span class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>"></span></span>
