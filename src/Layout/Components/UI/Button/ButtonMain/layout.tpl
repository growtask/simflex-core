<?php
/** @var array $data */

$buttonClasses = [
    'btn',
    "btn-{$data['style']}",
    "btn-size_{$data['size']}",
    "btn-theme_{$data['theme']}",
    $data['state'] !== 'default' ? "btn-state_{$data['state']}" : '',
    $data['load'] ? 'loading' : '',
    $data['className'] ?? ''
];

$attributes = $data['attributes'] ?? [];
$type = $attributes['type'] ?? 'button';
unset($attributes['type']);

// Недоступная кнопка: у button атрибут disabled, у ссылки href не выводится и она выпадает из порядка фокуса
$isLink = (bool)$data['link'];
if ($data['disabled']) {
    $attributes['aria-disabled'] = 'true';
    if ($isLink) {
        $attributes['tabindex'] = '-1';
    }
}
if ($data['load']) {
    $attributes['aria-busy'] = 'true';
}
$class = trim(implode(' ', array_filter($buttonClasses)));
$tag = $isLink ? 'a' : 'button';
?>

<<?= $tag ?>
    <?php if ($isLink): ?>
        <?php if (!$data['disabled']): ?>href="<?= htmlspecialchars($data['link'], ENT_QUOTES, 'UTF-8') ?>"<?php endif; ?>
    <?php else: ?>
        type="<?= htmlspecialchars($type, ENT_QUOTES, 'UTF-8') ?>"<?= $data['disabled'] ? ' disabled' : '' ?>
    <?php endif; ?>
    class="<?= $class ?>" <?= buildAttrs($attributes) ?>>
    <?php if ($data['iconLeft']): ?>
        <span class="btn__icon btn__icon_left"><?= renderIcon($data['iconLeft']) ?></span>
    <?php endif; ?>

    <?php if ($data['text']): ?>
        <span class="btn__text"><?= $data['text'] ?></span>
    <?php endif; ?>

    <?php if ($data['iconCenter']): ?>
        <span class="btn__icon btn__icon_center"><?= renderIcon($data['iconCenter']) ?></span>
    <?php endif; ?>

    <?php if ($data['iconRight']): ?>
        <span class="btn__icon btn__icon_right"><?= renderIcon($data['iconRight']) ?></span>
    <?php endif; ?>

    <?php if ($data['loader']): ?>
        <span class="btn__loader" aria-hidden="true">
            <?= Simflex\Core\Layout\Components\UI\Loader\LoaderMain\Layout::draw() ?>
        </span>
    <?php endif; ?>
</<?= $tag ?>>
