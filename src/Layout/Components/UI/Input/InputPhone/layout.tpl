<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Input\InputPhone\InputPhoneCountry;

/** @var InputPhoneCountry $country */
$country = $data['country'];
$classes = [
    'phone-input',
    "phone-input_size_{$data['size']}",
    "phone-input-theme_{$data['theme']}",
    "phone-input-style_{$data['style']}",
    $data['hasError'] ? 'phone-input_error' : '',
    $data['disabled'] ? 'phone-input_disabled' : '',
    $data['className'],
];
$id = htmlspecialchars($data['id']);
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" data-sf-phone>
    <input type="hidden" name="<?= htmlspecialchars($data['name']) ?>" value="<?= htmlspecialchars($data['fullValue']) ?>"
           data-sf-phone-value<?= $data['disabled'] ? ' disabled' : '' ?>>
    <div class="phone-input__country">
        <button type="button" class="phone-input__tile" aria-haspopup="listbox" aria-expanded="false"
                aria-controls="<?= $id ?>-countries" data-sf-phone-toggle
                aria-label="Страна: <?= htmlspecialchars($country->label()) ?> +<?= $country->dial() ?>"<?= $data['disabled'] ? ' disabled' : '' ?>>
            <span class="phone-flag phone-flag_<?= $country->value ?>" data-sf-phone-flag></span>
            <?= renderIcon('chevron-m-down', 'phone-input__chevron') ?>
        </button>
        <div class="phone-input__panel" id="<?= $id ?>-countries" role="listbox" aria-label="Страна" hidden>
            <?php foreach ($data['countries'] as $item): ?>
                <button type="button" class="phone-input__option" role="option" tabindex="-1"
                        aria-selected="<?= $item === $country ? 'true' : 'false' ?>"
                        data-country="<?= $item->value ?>" data-dial="<?= $item->dial() ?>"
                        data-mask="<?= htmlspecialchars($item->mask()) ?>" data-name="<?= htmlspecialchars($item->label()) ?>">
                    <span class="phone-flag phone-flag_<?= $item->value ?>"></span>
                    <span class="phone-input__option-name"><?= htmlspecialchars($item->label()) ?></span>
                    <span class="phone-input__option-dial">+<?= $item->dial() ?></span>
                </button>
            <?php endforeach; ?>
        </div>
    </div>
    <?= $data['field'] ?>
</div>
