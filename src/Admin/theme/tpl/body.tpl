<?php

/**
 * Тело макета админки, рендерится до head (index.tpl)
 * @var \Simflex\Core\Admin\Page $page
 * @var string $fmAssets Веб-путь к статике файлового менеджера
 */

use Simflex\Core\System\Container;

?>
<a class="app__skip" href="#sf-main">К содержимому</a>
<div class="app app-theme_<?= $page->getTheme() ?>">
    <?php include 'partial/sidebar.tpl'; ?>
    <div class="app__main">
        <?php include 'partial/header.tpl'; ?>
        <main class="page" id="sf-main" tabindex="-1">
            <?php
            // раздел, который сам вывел page-head (Page::drawPageHead()), отменяет заголовок по умолчанию
            $content = $page->getContent();
            echo $page->isPageHeadDrawn() ? '' : $page->drawPageHead();
            echo $content;
            ?>
        </main>
    </div>
</div>
<?php
// сообщения после действий (Alert): успех — тосты, ошибки и важное — уведомления
$messages = \Simflex\Core\Extensions\Alert\Alert::drawAdminMessages($page->getTheme());
?>
<?= \Simflex\Core\Layout\Components\UI\Core\Toast\Layout::drawStack($messages['toasts'], className: 'app__toasts') ?>
<div class="app__notices" data-sf-notices><?= $messages['notices'] ?></div>

<?php
include 'modals/delete.tpl'; ?>
<?php
include 'modals/info.tpl'; ?>
<?php
include 'modals/confirm.tpl'; ?>

<?= \Simflex\Core\Http\View::render(
    Container::getPaths()->getRoot('vendor/simflex/file-manager/src/tpl/index.tpl'),
    [
        'fileManagerApi' => \Simflex\Core\Admin\Page::url('fm'),
        'fileManagerRoot' => '/uf',
        'fileManagerAssets' => $fmAssets,
        'theme' => $page->getTheme(),
    ]
) ?>

<?php include 'partial/support.tpl'; ?>
