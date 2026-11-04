<?php

/**
 * Карточка виджета главной админки: название, действия виджета, содержимое
 * @var \Simflex\Core\Admin\WidgetBase $this
 * @var string $content
 */

?>
<section class="widget-card" data-widget-id="<?= (int)$this->id ?>">
    <div class="widget-card__head">
        <h2 class="widget-card__title"><?= htmlspecialchars((string)$this->data['name']) ?></h2>
        <div class="widget-card__actions"><?= $this->actions() ?></div>
    </div>
    <div class="widget-card__body"><?= $content ?></div>
    <input type="hidden" class="widget-id" value="<?= (int)$this->id ?>">
</section>
