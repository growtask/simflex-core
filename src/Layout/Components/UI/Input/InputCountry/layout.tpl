<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Input\InputPhone\InputPhoneCountry;

/** @var InputPhoneCountry $country */
$country = $data['country'];
?>
<div class="phone-input phone-input-theme_<?= htmlspecialchars($data['theme']) ?> phone-input_size_m <?= htmlspecialchars($data['className']) ?>"
     style="display:inline-block;<?= $data['open'] ? 'min-height:260px;' : '' ?>">
    <div class="phone-input__country">
        <button type="button" class="phone-input__tile" aria-haspopup="listbox" aria-expanded="<?= $data['open'] ? 'true' : 'false' ?>"
                aria-label="Страна: <?= htmlspecialchars($country->label()) ?> +<?= $country->dial() ?>"<?= $data['disabled'] ? ' disabled' : '' ?>>
            <span class="phone-flag phone-flag_<?= $country->value ?>"></span>
            <?= renderIcon('chevron-m-down', 'phone-input__chevron') ?>
        </button>
        <?php if ($data['open']): ?>
            <div class="phone-input__panel" role="listbox" aria-label="Страна">
                <?php foreach (InputPhoneCountry::cases() as $item): ?>
                    <button type="button" class="phone-input__option" role="option" tabindex="-1"
                            aria-selected="<?= $item === $country ? 'true' : 'false' ?>">
                        <span class="phone-flag phone-flag_<?= $item->value ?>"></span>
                        <span class="phone-input__option-name"><?= htmlspecialchars($item->label()) ?></span>
                        <span class="phone-input__option-dial">+<?= $item->dial() ?></span>
                    </button>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </div>
</div>
