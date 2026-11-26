<?php
/** @var array $data */

?>
<div class="<?= htmlspecialchars(trim('text-input__calendar-specimen ' . $data['className'])) ?>" style="display:inline-flex;flex-direction:<?= $data['top'] ? 'column-reverse' : 'column' ?>;gap:8px;width:max-content">
    <div style="width:280px"><?= $data['field'] ?></div>
    <?= $data['calendar'] ?>
</div>
