<?php

/**
 * Демо PlaceholderImg: картинка, разные картинки для телефона, заглушка и скрытие при отсутствии файла
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\ImgMissing;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\Layout as PlaceholderImg;

$logo = asset('images/brand/logo' . ($theme === 'dark' ? '-dark' : '') . '.svg');

?>
<h3 class="ui-showcase__subtitle ui-m">Картинка есть</h3>
<div class="ui-showcase__row">
    <?= PlaceholderImg::drawPlaceholderImg(src: $logo, alt: 'Логотип', height: 40) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Своя картинка для телефона (до 811 px)</h3>
<div class="ui-showcase__row">
    <?= PlaceholderImg::drawPlaceholderImg(
        src: $logo,
        srcMobile: asset('images/placeholders/fallback-img.webp'),
        alt: 'Логотип',
        height: 40
    ) ?>
</div>

<?php foreach (ImgMissing::cases() as $missing): ?>
    <h3 class="ui-showcase__subtitle ui-m">Файла нет: <?= $missing->name ?></h3>
    <div class="ui-showcase__row">
        <?= PlaceholderImg::drawPlaceholderImg(src: '/uf/no-such-file.jpg', alt: 'Нет файла', missing: $missing, width: 160, height: 120) ?>
        <?php if ($missing === ImgMissing::Hide): ?>
            <span class="ui-m">(ничего не выведено)</span>
        <?php endif; ?>
    </div>
<?php endforeach; ?>
