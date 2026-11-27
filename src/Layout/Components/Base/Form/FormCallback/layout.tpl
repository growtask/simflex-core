<?php
/** @var array $data */

$classes = [
    'callback',
    "callback-layout_{$data['layout']}",
    "callback-state_{$data['state']}",
    "callback-theme_{$data['theme']}",
    $data['className'] ?? '',
];
$rootAttrs = ($data['attributes'] ?? []) + ['data-callback' => ''];
if ($data['errorsJson'] !== '') {
    $rootAttrs['data-errors'] = $data['errorsJson'];
}
$id = $data['id'];
?>

<div class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($rootAttrs) ?>>
    <form class="callback__form" id="<?= htmlspecialchars($id) ?>" method="post" action="<?= htmlspecialchars($data['action']) ?>" novalidate data-callback-form<?= $data['sending'] ? ' aria-busy="true"' : '' ?>>
        <?php foreach ($data['hiddenFields'] + $data['guardHtml'] as $name => $value): ?>
            <input type="hidden" name="<?= htmlspecialchars($name) ?>" value="<?= htmlspecialchars($value, ENT_QUOTES) ?>">
        <?php endforeach; ?>

        <?php if ($data['guard']): ?>
            <?php // ловушка для ботов: человек поле не видит, скринридер и клавиатура его пропускают ?>
            <div class="callback__trap" aria-hidden="true">
                <input type="text" name="website" value="" tabindex="-1" autocomplete="off">
            </div>
        <?php endif; ?>

        <div class="callback__fields">
            <?= implode("\n", $data['fields']) ?>
        </div>

        <?php if ($data['captcha'] !== ''): ?>
            <div class="callback__captcha"><?= $data['captcha'] ?></div>
        <?php endif; ?>

        <div class="callback__send">
            <?php if ($data['consentHtml'] !== ''): ?>
                <div class="callback__consent-wrap"><?= $data['consentHtml'] ?></div>
            <?php endif; ?>
            <?= $data['submit'] ?>
        </div>
    </form>

    <div class="callback__result" data-callback-result></div>

    <?php // результаты кладутся на место формы скриптом, чтобы озвучивались как живая область ?>
    <template data-callback-template="success"><?= $data['success'] ?></template>
    <template data-callback-template="error"><?= $data['failure'] ?></template>
</div>
