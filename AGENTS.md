# Ядро Simflex CMS — правила для агентов

Это ядро CMS — composer-пакет `simflex/core`. Общие правила разработки CMS и устройство остальных
репозиториев — в `AGENTS.md` репозитория `simflex-agents`, локальные пути — в `.agents/local.md` (не в git).

## Устройство

- `src/` — код, namespace `Simflex\Core\` (PSR-4); `src/Kernel.php` — загрузка и запуск сайта (`Simflex\Core\Kernel`,
  его вызывают точки входа сайта); `src/functions.php` — функции ядра (`env()`, `asset()`, `getSimflexVersion()`),
  подключаются composer (`autoload.files`).
- `src/Admin` — админка: `Handler` (раздел) и разделы ядра `Handlers/`, реестр разделов `handlers.php`,
  табличные разделы `Table/` (`Table`, `FieldDefinition`, пресеты полей, `Repository`, шаблоны), поля `Fields/`,
  меню `Menu`/`MenuItem`, модули админки `AdminModules`, тема `theme/`.
- `src/System` — основа: контейнер (`Container`), события, конфиг (`ConfigBase`), настройки сайта (`Settings`),
  реестры в коде (`CodeRegistry`, `Privilege`, `ExtensionRegistry`), базовые классы модели и модуля (`ModelBase`,
  `ModuleBase`), кэш, сессия.
- `src/Http` — запрос и ответ, маршруты, страница сайта (`Page`), её SEO и статика (`PageSeo`, `PageAssets`,
  `Assets`), меню сайта (`Menu`), шаблоны (`View`), компоненты и контроллеры.
- `src/DB` — ORM (`DB`, `AQ`, `Where`), миграции (`Schema`, `Cli\Migrator`); `src/Models` — модели таблиц ядра;
  `src/Console`, `src/Cron`, `src/Mail`, `src/Sms`, `src/Logger`, `src/Layout` — подсистемы.
- `src/Extensions` — расширения ядра (страницы `Content`, формы, хлебные крошки, модули «Код» и «Текстовый блок»),
  `Extensions/Install/PackageInstaller` — установщик пакетов-расширений.
- `README.md` — краткое описание пакета (версии, устройство), `CHANGELOG.md` — журнал изменений ядра.

## Правила

- Ядро не знает о конкретном сайте: то, что нужно только шаблону или сайту, задаётся в шаблоне, расширяемые
  реестры (привилегии, меню, модули админки) сайт дополняет наследником, указанным в конфиге.
- Автотестов в этом репозитории нет: тесты ядра лежат в шаблоне (`tests/Unit/Core`, `tests/Unit/Admin`,
  `tests/Acceptance`) и запускаются в его Docker. Ядро в контейнере смонтировано в `/var/www/simflex-core`.
- Несовместимые изменения обязательно описывай в `CHANGELOG.md` («Несовместимые изменения» и «Переход с …»):
  по нему обновляются шаблон, расширения и сайты.
- Публичный API, на который опираются сайты и расширения (классы `Admin\Table\Table`, `Admin\Handler`, `Menu`,
  `ModelBase`, `AQ` и т.п.), меняй вместе с документацией и журналом.
