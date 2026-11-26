<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Input\InputPhone\InputPhoneCountry;

/** @var InputPhoneCountry $country */
$country = $data['country'];
?>
<div class="phone-input phone-input-theme_<?= htmlspecialchars($data['theme']) ?>">
    <div class="phone-input__country">
        <div class="phone-input__panel" role="listbox" style="position:static;display:block;opacity:1;visibility:visible">
            <button type="button" class="<?= htmlspecialchars(trim('phone-input__option ' . $data['className'])) ?>" role="option"
                    aria-selected="<?= $data['active'] ? 'true' : 'false' ?>">
                <span class="phone-flag phone-flag_<?= $country->value ?>"></span>
                <span class="phone-input__option-name"><?= htmlspecialchars($country->label()) ?></span>
                <span class="phone-input__option-dial">+<?= $country->dial() ?></span>
            </button>
        </div>
    </div>
</div>
