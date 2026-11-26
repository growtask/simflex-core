<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\Layout as Loader;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainTheme;

$classes = ['preloader', "preloader-theme_{$data['theme']}", $data['inline'] ? 'preloader_inline' : '', $data['className']];
$attributes = $data['attributes'] + ['aria-busy' => 'true'] + ($data['inline'] ? [] : ['data-sf-preloader' => (string)$data['minDuration']]);
?>
<div class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <?= $data['logoHtml'] ?>
    <?= Loader::drawLoaderMain(
        size: LoaderMainSize::ExtraLarge,
        style: LoaderMainStyle::Primary,
        theme: LoaderMainTheme::from($data['theme']),
        label: $data['label'],
        className: 'preloader__loader',
    ) ?>
</div>
