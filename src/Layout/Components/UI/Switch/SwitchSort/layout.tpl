<?php
/** @var array $data */

?>
<span class="sort sort-theme_<?= $data['theme'] ?> <?= htmlspecialchars($data['className']) ?>">
    <span class="sort__text"><?= htmlspecialchars($data['text']) ?></span>
    <span class="sort__buttons" data-sf-sort><span class="sort__glide" data-direction="<?= htmlspecialchars($data['direction']) ?>" aria-hidden="true"><?= $data['glide'] ?></span><?= $data['buttons'] ?></span>
</span>
