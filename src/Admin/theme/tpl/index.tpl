<?php

use Simflex\Core\System\Container;

\Simflex\Core\Extensions\Alert\Alert::init();

$page->coreJsModule('/theme/js/admin.js', 0);
$page->coreJsModule('/theme/js/menu.js');
$page->coreJsModule('/theme/js/theme.js');
$page->coreJsModule('/theme/js/modals.js');
$page->coreJsModule('/theme/js/support.js');
$page->coreJsModule('/theme/js/list.js');
$page->coreJsModule('/theme/js/form.js');
$page->coreJsModule('/theme/js/table-editor.js');

// CSRF-токен — до любого вывода: при первом обращении он пишется в сессию (session_start() после заголовков нельзя)
$csrfToken = \Simflex\Core\Http\Csrf::token();
// файловый менеджер (пакет simflex/file-manager): окно в body, скрипт-модуль, стили — со стилями админки
$fmAssets = \Simflex\Core\Http\Assets::publish(Container::getPaths()->getRoot('vendor/simflex/file-manager/src/assets'));
$page->jsModule($fmAssets . '/js/file-manager.js');
// body рисуется раньше head: стили компонентов Layout, выведенных в body, собираются в $page->getMeta()
$body = \Simflex\Core\Http\View::render(__DIR__ . '/body.tpl', ['page' => $page, 'fmAssets' => $fmAssets]);

?>

<!DOCTYPE html>
<html lang="ru" data-theme="<?= $page->getTheme() ?>"
      <?= $page->isMenuCollapsed() ? 'class="sf-menu-collapsed"' : '' ?>>
<head>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="csrf-token" content="<?= htmlspecialchars($csrfToken) ?>"/>

    <link rel="stylesheet" href="<?= asset('fonts/inter.css') ?>"/>
    <link rel="shortcut icon" href="<?= asset('img/favicon-admin.ico') ?>" type="image/x-icon">

    <title>
        <?php
        echo \Simflex\Core\Admin\Page::get()->getCurrentMenuItem('name') ? \Simflex\Core\Admin\Page::get()->getCurrentMenuItem('name') . ' |' : '' ?>
        Simflex Admin </title>

    <?= $page->getMeta() ?>
</head>

<body>
<?= $body ?>
<?= Container::getConfig()->devMode ? Container::get('debugbar')->render() : '' ?>
</body>
</html>