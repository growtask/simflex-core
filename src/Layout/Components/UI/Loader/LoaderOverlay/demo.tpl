<?php

/**
 * Демо LoaderOverlay: блок под вуалью и без неё (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

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
