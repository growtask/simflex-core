<?php
/** @var array $data */

$classes = [
    'calendar',
    "calendar-theme_{$data['theme']}",
    $data['card'] ? 'calendar_card' : '',
    $data['className'],
];
$attributes = $data['attributes'] + [
    'id' => $data['id'],
    'role' => 'group',
    'aria-label' => $data['label'],
    'data-sf-calendar' => $data['mode'],
    'data-value' => $data['value'],
    'data-step' => (string)$data['minuteStep'],
];
if ($data['min'] !== '') {
    $attributes['data-min'] = $data['min'];
}
if ($data['max'] !== '') {
    $attributes['data-max'] = $data['max'];
}
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" <?= buildAttrs($attributes) ?>>
    <div class="calendar__head">
        <?= $data['prev'] ?>
        <div class="calendar__title" aria-live="polite">
            <button type="button" class="calendar__title-button calendar__month" data-sf-calendar-view="months"></button>
            <button type="button" class="calendar__title-button calendar__year" data-sf-calendar-view="years"></button>
            <span class="calendar__line" hidden></span>
            <button type="button" class="calendar__title-button calendar__time" data-sf-calendar-view="time" hidden></button>
        </div>
        <?= $data['next'] ?>
    </div>
    <div class="calendar__body" data-sf-calendar-body></div>
    <?php if ($data['mode'] === 'datetime'): ?>
        <div class="calendar__time-row">
            <span class="calendar__time-label">Время</span>
            <button type="button" class="calendar__time-field" data-sf-calendar-view="time"></button>
        </div>
    <?php endif; ?>
</div>
