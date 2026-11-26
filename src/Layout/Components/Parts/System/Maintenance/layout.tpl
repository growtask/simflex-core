<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$classes = ['maintenance', "maintenance-theme_{$data['theme']}", $data['inline'] ? 'maintenance_inline' : '', $data['className']];
// на странице работ это основное содержимое (main), в рамке витрины - обычный блок
$tag = $data['inline'] ? 'div' : 'main';
?>
<<?= $tag ?> class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($data['attributes']) ?>>
    <?= $data['logoHtml'] ?>
    <div class="maintenance__body">
        <h1 class="maintenance__title"><?= htmlspecialchars($data['title']) ?></h1>
        <p class="maintenance__text"><?= htmlspecialchars($data['text']) ?></p>
    </div>
    <?php if ($data['buttonText'] !== '' && $data['buttonLink'] !== ''): ?>
        <?= Button::drawButton(
            className: 'maintenance__action',
            text: htmlspecialchars($data['buttonText']),
            link: $data['buttonLink'],
            style: ButtonStyle::Secondary,
            size: ButtonSize::Medium,
            theme: ButtonTheme::from($data['theme']),
        ) ?>
    <?php endif; ?>
</<?= $tag ?>>
