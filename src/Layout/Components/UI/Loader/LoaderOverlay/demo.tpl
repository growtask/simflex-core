<?php

/**
 * Демо LoaderOverlay: блок под вуалью и без неё (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainTheme;
use Simflex\Core\Layout\Components\UI\Loader\LoaderOverlay\Layout as LoaderOverlay;

$loaderTheme = LoaderMainTheme::from($theme);
$card = '<div style="padding:16px;width:280px;box-sizing:border-box;border-radius:var(--radius-ui-large);background:'
    . ($theme === 'dark' ? '#262626;color:#fff' : '#fff;color:#262626') . '">'
    . '<strong>Заголовок</strong><p style="margin:12px 0 0">Текст блока, который обновляется</p></div>';

?>
<div class="ui-showcase__row">
    <?= LoaderOverlay::drawLoaderOverlay($card, theme: $loaderTheme) ?>
    <?= LoaderOverlay::drawLoaderOverlay($card, active: false, theme: $loaderTheme) ?>
</div>
<h3 class="ui-showcase__subtitle ui-m">Включение и выключение (SfUi.loaderOverlay): вуаль проявляется, уходит быстрее</h3>
<div class="ui-showcase__row">
    <div id="ui-overlay-<?= $theme ?>"><?= LoaderOverlay::drawLoaderOverlay($card, active: false, theme: $loaderTheme) ?></div>
    <?= Button::drawButtonMain(text: 'Переключить', style: ButtonMainStyle::Gray, size: ButtonMainSize::ExtraSmall, theme: ButtonMainTheme::from($theme), attributes: ['onclick' => 'var o=document.querySelector(\'#ui-overlay-' . $theme . ' .loader-overlay\'); SfUi.loaderOverlay(o, !o.classList.contains(\'loader-overlay_active\'))']) ?>
</div>
