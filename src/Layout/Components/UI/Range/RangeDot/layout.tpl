<?php
/** @var array $data */

$classes = ['range', 'range-type_single', 'range-width_hug', "range-theme_{$data['theme']}", $data['disabled'] ? 'range_disabled' : '', $data['className']];
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" role="group" data-min="0" data-max="100" data-step="1">
    <div class="range__track">
        <span class="range__rail">
            <span class="range__dot" role="slider" style="left:<?= $data['value'] ?>%" tabindex="<?= $data['disabled'] ? '-1' : '0' ?>"
                  aria-label="Значение" aria-valuemin="0" aria-valuemax="100" aria-valuenow="<?= $data['value'] ?>"<?= $data['disabled'] ? ' aria-disabled="true"' : '' ?>>
                <?php if ($data['tooltip']): ?>
                    <span class="range__tooltip" aria-hidden="true"><?= $data['value'] ?></span>
                <?php endif; ?>
            </span>
        </span>
    </div>
</div>
