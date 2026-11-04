<?php

/**
 * Превью картинки в ячейке и в сведениях о записи; без картинки — заглушка
 * @var string $src Адрес превью, пусто — картинки нет
 * @var string $defaultImg Картинка на случай ошибки загрузки
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\Layout as Placeholder;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\PlaceholderTheme;

?>
<span class="td-image table__row-photo">
    <?php if ($src !== ''): ?>
        <img src="<?= htmlspecialchars($src) ?>" alt="" loading="lazy"
             onerror="this.onerror=null;this.src='<?= htmlspecialchars($defaultImg) ?>'">
    <?php else: ?>
        <?= Placeholder::drawNoImage(theme: PlaceholderTheme::from(Page::get()->getTheme())) ?>
    <?php endif ?>
</span>
