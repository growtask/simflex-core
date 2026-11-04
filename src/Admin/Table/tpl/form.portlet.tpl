<?php

/**
 * Группа полей отдельным блоком формы (form-section): параметры модуля, подгружаемые в форму (Handlers\ModuleItem)
 * @var array $group label, fields
 * @var string|null $portletClass
 */

?>
<section class="form-section form-section_open <?= htmlspecialchars($portletClass ?? '') ?>" data-sf-form-section>
    <h2 class="form-section__title">
        <button type="button" class="form-section__head" aria-expanded="true">
            <span class="form-section__name"><?= $group['label'] ?></span>
            <?= renderIcon('chevron-m-down', 'form-section__chevron') ?>
        </button>
    </h2>
    <div class="form-section__body">
        <div class="form-section__grid">
            <?php foreach ($group['fields'] as $field): ?>
                <?php include 'form.field.tpl' ?>
            <?php endforeach ?>
        </div>
    </div>
</section>
