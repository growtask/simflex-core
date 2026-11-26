<?php

/**
 * Демо Scrollbar: стиль × размер, со стрелками и без, вертикальная и горизонтальная (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\Layout as Scrollbar;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarMainDirection;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarMainSize;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarMainStyle;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarMainTheme;

$scrollbarTheme = ScrollbarMainTheme::from($theme);
$lines = '';
for ($i = 1; $i <= 24; $i++) {
    $lines .= '<p class="t3">Строка списка ' . $i . '</p>';
}
$wide = '<div style="display:flex;gap:16px;width:max-content">';
for ($i = 1; $i <= 14; $i++) {
    $wide .= '<span class="t3" style="white-space:nowrap">Элемент ' . $i . '</span>';
}
$wide .= '</div>';

?>
<?php foreach (ScrollbarMainStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?>: вертикальная</h3>
    <div class="ui-showcase__row">
        <?php foreach (ScrollbarMainSize::cases() as $size): ?>
            <?php foreach ([false, true] as $arrows): ?>
                <div class="ui-showcase__field">
                    <?= Scrollbar::drawScrollbarMain(
                        $lines,
                        $style,
                        ScrollbarMainDirection::Vertical,
                        $size,
                        $arrows,
                        $scrollbarTheme,
                        height: '160px',
                        label: $style->name . ' ' . $size->name,
                    ) ?>
                </div>
            <?php endforeach; ?>
        <?php endforeach; ?>
    </div>

    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?>: горизонтальная</h3>
    <?php foreach (ScrollbarMainSize::cases() as $size): ?>
        <div class="ui-showcase__row">
            <?php foreach ([false, true] as $arrows): ?>
                <div class="ui-showcase__field">
                    <?= Scrollbar::drawScrollbarMain(
                        $wide,
                        $style,
                        ScrollbarMainDirection::Horizontal,
                        $size,
                        $arrows,
                        $scrollbarTheme,
                        label: $style->name . ' ' . $size->name,
                    ) ?>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>
