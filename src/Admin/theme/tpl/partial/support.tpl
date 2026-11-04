<?php

/**
 * Панель поддержки (компонент макета support-bar): открывается кнопкой «Поддержка» в меню, без затемнения,
 * заходит под меню. Внутри — форма обращения growtask.ru (загружается при первом открытии); её сообщения
 * close-iframe и success закрывают панель, success — тост (theme/js/support.js)
 * @var \Simflex\Core\Admin\Page $page
 */

use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\Layout as ButtonIcon;
use Simflex\Core\System\Container;

$formUrl = 'https://growtask.ru/remoteform.php?tpl=help&ws=https://'
    . rawurlencode(Container::getRequest()->getHost());
?>
<section class="support-bar support-bar-theme_<?= $page->getTheme() ?>" id="sf-support" role="dialog"
         aria-modal="false" aria-labelledby="sf-support-title" data-sf="support" hidden>
    <div class="support-bar__head">
        <h2 class="support-bar__title" id="sf-support-title">Поддержка</h2>
        <?= ButtonIcon::drawButtonIcon(
            icon: 'close',
            label: 'Закрыть',
            style: ButtonIconStyle::Secondary,
            theme: ButtonIconTheme::from($page->getTheme()),
            attributes: ['data-sf-support-close' => ''],
        ) ?>
    </div>
    <iframe class="support-bar__frame" title="Форма обращения в поддержку"
            data-src="<?= htmlspecialchars($formUrl) ?>"></iframe>
</section>
