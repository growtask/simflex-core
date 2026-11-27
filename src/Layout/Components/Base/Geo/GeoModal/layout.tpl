<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Base\Geo\GeoMain\GeoMainState;
use Simflex\Core\Layout\Components\Base\Geo\GeoMain\GeoMainStyle;
use Simflex\Core\Layout\Components\Base\Geo\GeoMain\GeoMainTheme;
use Simflex\Core\Layout\Components\Base\Geo\GeoMain\Layout as GeoMain;
use Simflex\Core\Layout\Components\Base\Modal\ModalMain\Layout as Modal;
use Simflex\Core\Layout\Components\Base\Modal\ModalMain\ModalMainTheme;

$esc = static fn($value) => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$shown = $data['city'] !== '' ? $data['city'] : $data['guess'];
$mobileOpen = $data['open'] && $data['style'] === 'mobile';
$panelOpen = $data['open'] && !$mobileOpen;
// содержимое окна (GEO/main): на desktop скрипт переносит его в .geo__panel, на телефоне оно в окне ModalMain
$main = GeoMain::drawGeoMain(
    city: $data['city'],
    guess: $data['guess'],
    cities: $data['cities'],
    state: $data['city'] !== '' ? GeoMainState::Active : GeoMainState::Static,
    style: $mobileOpen ? GeoMainStyle::Mobile : GeoMainStyle::Desktop,
    theme: GeoMainTheme::from($data['theme']),
    id: $data['id'],
);
$attrs = $data['attributes'] + ($data['open'] ? ['data-sf-geo-specimen' => ''] : []);
?>
<div class="<?= $esc(implode(' ', array_filter(['geo', "geo-theme_{$data['theme']}", $panelOpen ? 'geo_inline' : '', $data['className']]))) ?>"
     data-sf-geo data-storage-key="<?= $esc($data['storageKey']) ?>" data-guess="<?= $esc($data['guess']) ?>"
     data-ask="<?= $data['ask'] ? '1' : '' ?>" <?= buildAttrs($attrs) ?>>
    <button type="button" class="geo__trigger" aria-haspopup="dialog" aria-expanded="<?= $data['open'] ? 'true' : 'false' ?>"
            aria-controls="<?= $esc($data['id']) ?>" data-sf-geo-trigger>
        <?= renderIcon('marker-pinned', 'geo__trigger-icon') ?>
        <span><span class="visually-hidden">Ваш город: </span><span data-sf-geo-label><?= $esc($shown !== '' ? $shown : $data['placeholder']) ?></span></span>
    </button>
    <div class="geo__panel" id="<?= $esc($data['id']) ?>" role="dialog" aria-label="Ваш город" <?= $panelOpen ? '' : 'hidden' ?> data-sf-geo-panel>
        <span class="geo__corner" aria-hidden="true"></span>
        <div class="geo__body" data-sf-geo-body><?= $panelOpen ? $main : '' ?></div>
    </div>
    <?= Modal::drawModalMain(
        id: $data['id'] . '-modal',
        title: 'Ваш город',
        content: $panelOpen ? '' : $main,
        theme: ModalMainTheme::from($data['theme']),
        className: 'geo-modal modal_view_mobile',
        attributes: ['data-sf-geo-modal' => ''],
        inline: $mobileOpen,
    ) ?>
</div>
