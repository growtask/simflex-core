<?php
/** @var array $data */

$esc = static fn($value) => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$classes = ['geo-list', "geo-list-theme_{$data['theme']}", $data['style'] === 'mobile' ? 'geo-list-screen_mobile' : '',
    $data['className']];
?>
<ul class="<?= $esc(implode(' ', array_filter($classes))) ?>" id="<?= $esc($data['id']) ?>" aria-label="Города"
    <?= $data['hidden'] ? 'hidden' : '' ?> data-sf-geo-list>
    <li <?= $data['empty'] ? '' : 'hidden' ?> data-sf-geo-empty><p class="geo-list__empty" role="status">Ничего не найдено...</p></li>
    <?php foreach ($data['cities'] as $city): ?>
        <li data-city="<?= $esc($city) ?>" <?= $data['empty'] ? 'hidden' : '' ?>>
            <button type="button" class="tab tab-filled tab-size_s tab-theme_<?= $esc($data['theme']) ?> geo-list__item"
                    data-sf-geo-item><span class="tab__text"><?= $esc($city) ?></span></button>
        </li>
    <?php endforeach; ?>
</ul>
