<?php
/** @var array $data */

$classes = ['calendar__item', $data['current'] ? 'calendar__item_current' : '', $data['className']];
?>
<div class="calendar calendar-theme_<?= $data['theme'] ?>">
    <div class="calendar__items">
        <button type="button" class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" role="option"
                aria-selected="<?= $data['selected'] ? 'true' : 'false' ?>"><?= htmlspecialchars($data['text']) ?></button>
    </div>
</div>
