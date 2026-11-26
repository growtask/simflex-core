<?php
/** @var array $data */

$contactClasses = [
    'contact',
    "contact-{$data['style']}",
    "contact-type_{$data['type']}",
    "contact-size_{$data['size']}",
    "contact-theme_{$data['theme']}",
    $data['className'] ?? ''
];
?>

<a href="<?= htmlspecialchars($data['href']) ?>" class="<?= htmlspecialchars(implode(' ', $contactClasses)) ?>" <?= buildAttrs($data['attributes'] ?? []) ?>>
    <span class="contact__text"><?= htmlspecialchars($data['text']) ?></span>
</a>
