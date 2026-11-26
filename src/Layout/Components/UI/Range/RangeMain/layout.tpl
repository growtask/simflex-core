<?php
/** @var array $data */

$isRange = $data['type'] === 'range';
$classes = [
    'range',
    "range-type_{$data['type']}",
    "range-width_{$data['width']}",
    "range-theme_{$data['theme']}",
    $data['disabled'] ? 'range_disabled' : '',
    $data['className'],
];
$format = static fn(float $v): string => rtrim(rtrim(number_format($v, 4, '.', ''), '0'), '.');
$dots = $isRange
    ? [['key' => 'from', 'value' => $data['from'], 'percent' => $data['fromPercent'], 'label' => 'От'], ['key' => 'to', 'value' => $data['to'], 'percent' => $data['toPercent'], 'label' => 'До']]
    : [['key' => 'to', 'value' => $data['to'], 'percent' => $data['toPercent'], 'label' => $data['label'] !== '' ? $data['label'] : 'Значение']];
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" role="group"
     <?= $data['label'] !== '' ? 'aria-label="' . htmlspecialchars($data['label']) . '"' : '' ?>
     data-min="<?= $format($data['min']) ?>" data-max="<?= $format($data['max']) ?>" data-step="<?= $format($data['step']) ?>">
    <?php if ($data['inputs']): ?>
        <div class="range__inputs">
            <?= $data['fields']['from'] ?? '' ?>
            <?php if ($isRange): ?><span class="range__dash" aria-hidden="true">—</span><?php endif; ?>
            <?= $data['fields']['to'] ?>
        </div>
    <?php else: ?>
        <?= ($data['fields']['from'] ?? '') . $data['fields']['to'] ?>
    <?php endif; ?>
    <div class="range__track">
        <span class="range__rail">
            <span class="range__fill" style="left:<?= $isRange ? $data['fromPercent'] : 0 ?>%;right:<?= 100 - $data['toPercent'] ?>%"></span>
            <?php foreach ($dots as $dot): ?>
                <span class="range__dot" role="slider" data-range-dot="<?= $dot['key'] ?>" style="left:<?= $dot['percent'] ?>%"
                      tabindex="<?= $data['disabled'] ? '-1' : '0' ?>" aria-label="<?= htmlspecialchars($dot['label']) ?>"
                      aria-valuemin="<?= $format($data['min']) ?>" aria-valuemax="<?= $format($data['max']) ?>"
                      aria-valuenow="<?= $format($dot['value']) ?>"<?= $data['disabled'] ? ' aria-disabled="true"' : '' ?>>
                    <span class="range__tooltip" aria-hidden="true"><?= $format($dot['value']) ?></span>
                </span>
            <?php endforeach; ?>
        </span>
    </div>
    <?php if ($data['marks']): ?>
        <div class="range__marks" aria-hidden="true">
            <?php for ($i = 0; $i < 5; $i++): ?><span class="range__mark"></span><?php endfor; ?>
        </div>
    <?php endif; ?>
    <?php if ($data['labels']): ?>
        <div class="range__labels" aria-hidden="true">
            <span><?= $data['minText'] ?></span>
            <span><?= $data['maxText'] ?></span>
        </div>
    <?php endif; ?>
</div>
