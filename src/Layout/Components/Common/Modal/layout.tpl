<?php
/** @var array $data */

$classes = [
    'modal',
    "modal-size_{$data['size']}",
    "modal-theme_{$data['theme']}",
    $data['className'] ?? '',
];
$id = $data['id'];
$titleId = $id . '-title';
$textId = $id . '-text';
$hasTitle = $data['title'] !== '';
$hasText = $data['text'] !== '';

$dialogAttrs = [
    'role' => $data['alert'] ? 'alertdialog' : 'dialog',
    'aria-modal' => 'true',
    'tabindex' => '-1',
];
if ($hasTitle) {
    $dialogAttrs['aria-labelledby'] = $titleId;
}
if ($hasText) {
    $dialogAttrs['aria-describedby'] = $textId;
}

$rootAttrs = ($data['attributes'] ?? []) + ['data-modal-id' => $id];
if ($data['closeOnOverlay']) {
    $rootAttrs['data-modal-overlay-close'] = '';
}
?>

<div id="<?= htmlspecialchars($id) ?>" class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" hidden <?= buildAttrs($rootAttrs) ?>>
    <div class="modal__overlay" data-modal-overlay></div>
    <div class="modal__dialog" <?= buildAttrs($dialogAttrs) ?>>
        <?= $data['closeButton'] ?>

        <div class="modal__content">
        <?php if ($hasTitle || $hasText): ?>
            <div class="modal__head">
                <?php if ($hasTitle && $data['headAction'] !== ''): ?>
                    <div class="modal__head-row">
                        <h2 class="modal__title" id="<?= htmlspecialchars($titleId) ?>">
                            <?= htmlspecialchars($data['title']) ?>
                        </h2>
                        <div class="modal__head-action"><?= $data['headAction'] ?></div>
                    </div>
                <?php elseif ($hasTitle): ?>
                    <h2 class="modal__title" id="<?= htmlspecialchars($titleId) ?>"><?= htmlspecialchars($data['title']) ?></h2>
                <?php endif; ?>
                <?php if ($hasText): ?>
                    <p class="modal__text" id="<?= htmlspecialchars($textId) ?>"><?= htmlspecialchars($data['text']) ?></p>
                <?php endif; ?>
            </div>
        <?php endif; ?>

        <?php if ($data['content'] !== ''): ?>
            <div class="modal__body"><?= $data['content'] ?></div>
        <?php endif; ?>

        <?php if ($data['footer'] !== ''): ?>
            <div class="modal__footer"><?= $data['footer'] ?></div>
        <?php endif; ?>
        </div>
    </div>
</div>
