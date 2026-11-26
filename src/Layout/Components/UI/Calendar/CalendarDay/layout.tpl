<?php
/** @var array $data */

$state = $data['state'];
$selected = in_array($state, ['selected', 'range-start', 'range-end'], true);
$classes = [
    'calendar__day',
    in_array($state, ['weekend', 'muted', 'range-start', 'range-end', 'in-range'], true) ? 'calendar__day_' . $state : '',
    $data['className'],
];
?>
<div class="calendar calendar-theme_<?= $data['theme'] ?>">
    <div class="calendar__days">
        <div class="calendar__row">
            <button type="button" class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" role="gridcell"
                    aria-selected="<?= $selected ? 'true' : 'false' ?>"<?= $state === 'today' ? ' aria-current="date"' : '' ?><?= $state === 'disabled' ? ' disabled' : '' ?>><?= $data['day'] ?></button>
        </div>
    </div>
</div>
