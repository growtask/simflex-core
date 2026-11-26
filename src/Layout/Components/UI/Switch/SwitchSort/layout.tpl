<?php
/** @var array $data */

?>
<span class="sort sort-theme_<?= $data['theme'] ?> <?= htmlspecialchars($data['className']) ?>">
    <span class="sort__text"><?= htmlspecialchars($data['text']) ?></span>
    <span class="sort__buttons"><?= $data['buttons'] ?></span>
</span>
