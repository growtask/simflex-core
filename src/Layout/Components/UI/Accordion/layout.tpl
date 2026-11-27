<?php
/** @var array $data */

$id = ($data['id'] ?? '') !== '' ? $data['id'] : 'sf-accordion-' . bin2hex(random_bytes(4));
$isOpen = !empty($data['open']);
$accordionClasses = [
    'accordion',
    "accordion-{$data['style']}",
    "accordion-size_{$data['size']}",
    "accordion-theme_{$data['theme']}",
    $data['className'] ?? '',
    $isOpen ? 'active' : '',
];
$attributes = ($data['attributes'] ?? []) + ['data-sf-accordion' => ''];
if (!empty($data['multipleOpen'])) {
    $attributes['data-multiple-open'] = '';
}
?>

<li class="<?= htmlspecialchars(trim(implode(' ', array_filter($accordionClasses)))) ?>" <?= buildAttrs($attributes) ?>>
    <div class="accordion__header">
        <div class="accordion__header-wrapper">
            <?php if ($data['icon']): ?>
                <?= renderIcon($data['icon'], 'accordion__icon') ?>
            <?php endif; ?>

            <div class="accordion__text-wrapper">
                <h3 class="accordion__title" id="<?= htmlspecialchars($id) ?>-title"><?= $data['title'] ?></h3>
                <?php if ($data['subtitle']): ?>
                    <span class="accordion__subtitle"><?= $data['subtitle'] ?></span>
                <?php endif; ?>
            </div>
        </div>

        <div class="accordion__controls-wrapper">
            <?php if ($data['comment']): ?>
                <span class="accordion__comment"><?= $data['comment'] ?></span>
            <?php endif; ?>

            <?php if ($data['badge']): ?>
                <span class="accordion__badge"><?= $data['badge'] ?></span>
            <?php endif; ?>

            <button type="button" class="accordion__button<?= $isOpen ? ' active' : '' ?>"
                    aria-expanded="<?= $isOpen ? 'true' : 'false' ?>" aria-controls="<?= htmlspecialchars($id) ?>-content"
                    aria-labelledby="<?= htmlspecialchars($id) ?>-title">
                <?= renderIcon('chevron-down', 'accordion__chevron') ?>
            </button>
        </div>
    </div>
    <div class="accordion__content" role="region" id="<?= htmlspecialchars($id) ?>-content"
         aria-labelledby="<?= htmlspecialchars($id) ?>-title"<?= $isOpen ? '' : ' inert' ?>>
        <div class="accordion__description content">
            <?= $data['description'] ?>
        </div>
    </div>
</li>
