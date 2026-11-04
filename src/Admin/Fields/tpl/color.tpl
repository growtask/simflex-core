<?php

/**
 * Цвет: образец (input type=color) и код цвета
 * @var string $name
 * @var mixed $value
 * @var bool $readonly
 */

?>
<label class="form-color">
    <input class="form-color__swatch" type="color" name="<?= htmlspecialchars($name) ?>"
           value="<?= htmlspecialchars((string)$value) ?>"<?= $readonly ? ' disabled' : '' ?>
           aria-label="<?= htmlspecialchars(strip_tags((string)$this->label)) ?>"
           oninput="this.nextElementSibling.textContent = this.value">
    <span class="form-color__value"><?= htmlspecialchars((string)$value) ?></span>
</label>
