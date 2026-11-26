<?php

/**
 * Демо Scrollbar: стиль × размер, со стрелками и без, вертикальная и горизонтальная (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\Layout as Scrollbar;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarDirection;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarSize;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarStyle;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarTheme;

$scrollbarTheme = ScrollbarTheme::from($theme);
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
<?php foreach (ScrollbarStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?>: вертикальная</h3>
    <div class="ui-showcase__row">
        <?php foreach (ScrollbarSize::cases() as $size): ?>
            <?php foreach ([false, true] as $arrows): ?>
                <div class="ui-showcase__field">
                    <?= Scrollbar::drawScrollbar(
                        $lines,
                        $style,
                        ScrollbarDirection::Vertical,
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
    <?php foreach (ScrollbarSize::cases() as $size): ?>
        <div class="ui-showcase__row">
            <?php foreach ([false, true] as $arrows): ?>
                <div class="ui-showcase__field">
                    <?= Scrollbar::drawScrollbar(
                        $wide,
                        $style,
                        ScrollbarDirection::Horizontal,
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
