# Журнал изменений

Все заметные изменения ядра Simflex CMS (`simflex/core`). Формат — [Keep a Changelog](https://keepachangelog.com/ru/1.1.0/),
версии — [SemVer](https://semver.org/lang/ru/). Журнал ведётся с версии 4.0; изменения шаблона сайта — в `CHANGELOG.md`
репозитория `simflex-template`.

## [4.0.0] — не выпущена

- JSON API ядра. **Несовместимо:**
  - `Http\Api\JsonResponse` больше не добавляет конверт: тело ответа — ровно данные из `setData()` (массив, список,
    скаляр, `null`, `JsonSerializable`, объект с `toArray()`; иное — `\InvalidArgumentException`),
    `Content-Type: application/json; charset=utf-8`, `getBody()`, `send(): never`. Методы `set()`, `setError()`,
    `toArray()` убраны. Кому нужен прежний формат `{"error": {...}, ...данные}` — `Http\Api\JsonEnvelopeResponse`
    (замените класс; `set()`, `setData()`, `setError()` сохранены, но `setError()` теперь без второго параметра).
  - Новый `Http\Api\JsonEnvelopeResponse`: `{"error": {"code", "message"}, ...данные}`; ассоциативный массив —
    ключи рядом с `error`, список — `items`, скаляр и `null` — `result`; ключ `error` в данных — исключение.
    `setError(\Throwable)`: `ApiException` — статус, код, текст (и `error.errors`) из исключения; прочие исключения —
    статус 500, код `ErrorCodes::APP_INTERNAL_ERROR`, общий текст, исключение пишется в журнал. Статус, заданный
    `setStatusCode()`, не меняется. `setErrorMessage()` — ошибка без исключения.
  - Новый `Http\Api\ApiException` (сообщение для клиента, HTTP-статус, код, ошибки полей) с фабриками `badRequest()`,
    `unauthorized()`, `forbidden()`, `notFound()`, `unprocessable()`.
  - `Csrf::isTrustedMutation()` / `Csrf::checkMutation()` — проверка изменяющего запроса JSON API: метод не GET,
    HEAD, OPTIONS и тело JSON или верный токен, иначе `ApiException` 403. `Request::isJson()` учитывает `charset`.
  - Новый `Http\Api\ApiController extends ControllerBase`: действия `#[Action]` возвращают данные, контроллер
    отдаёт `JsonEnvelopeResponse`; параметры действия — из пути, тела JSON и GET/POST с приведением типов
    (ошибка — 400); исключения — JSON-ошибка; действие не найдено — 404 «Метод API не найден». Адрес — обычный
    маршрут `provider/routes.php`. Изменяющий запрос (не GET, HEAD, OPTIONS) принимается только с телом JSON или
    с CSRF-токеном, иначе 403 (`checkForgery()` → `Csrf::checkMutation()`). `JsonRequest`: `isJson()` учитывает `charset`, `createJson()` для тестов.
  - `ControllerBase`: подбор аргументов действия вынесен в `resolveArguments()` и `invokeAction()`.
  - Удалены `Http\Api\Base`, `Http\Api\Json` (вызов `action<Имя>()` по пути; нигде не подключались — перепишите
    на `ApiController`), `Location::Api`, группа сервисов `api` (уберите её из `provider/services.php` сайта),
    коды `ErrorCodes::APP_METHOD_NOT_FOUND`, `APP_UNSUPPORTED_RESPONSE`, `APP_UNSUPPORTED_RESPONSE_TYPE`.
    Текст `APP_INTERNAL_ERROR` — «Внутренняя ошибка, повторите позже».
  - `admin.js` `request()`: ответ не 2xx с JSON бросает `Error` с `message` из `error.message` конверта и свойствами
    `status`, `code`, `errors`, `response` (раньше — `Error('<статус> <текст>')`); успешный ответ без изменений.
    Код, читавший текст статуса из `message`, должен использовать `error.status`.

- Ajax-действия админки и компоненты вёрстки переведены на конверт JSON API. **Несовместимо:** `Table::searchInt()`,
  `searchMultiKey()`, `searchTags()` отвечают `{"error": …, "items": [{id, name}]}` (раньше — голый массив);
  `deleteField()`, `changeENUM()`, `changeNPP()` (раньше — перенаправление на список), `validate()` (теперь
  `valid` — булево) и `Privilege::switch` отвечают конвертом, ошибка — HTTP-статус и `error.message` вместо
  `success: false` / `ok: false` (`Alert::error()` в `beforeChangeENUM()` заменён на `ApiException`; наследникам
  с такой проверкой — бросать `ApiException`). `ModuleItem::module_param` — `{"error": …, "left": …, "right": …}`.
  Новый `Table::sendJson(\Closure)`. `searchInt()`, `searchMultiKey()`, `validate()`, `moduleParam()` — `never`.
  JS: `Dropdown`, `TagsInput` читают `items`; `table-editor.js`, `list.js`, `moduleitem.js` — под конверт;
  `Common/Form/Callback/script.js` отправляет форму телом JSON и разбирает конверт (`error.errors` — ошибки полей).

- Зависимость `maximebf/debugbar` (заброшен) заменена на `php-debugbar/php-debugbar`

- Фильтр даты в списке — период: у `FieldDate` и `FieldDateTime` в меню фильтра колонки и в окне фильтров поля
  «От» и «До» с календарём (`Fields/tpl/filter-date.tpl`), значение `ГГГГ-ММ-ДД|ГГГГ-ММ-ДД` (`Fields\DateRange`:
  разбор и подпись тега «01.11.2026 — 30.11.2026», «с …», «по …»), `Table::applyFilters()` — от и до
  включительно. Раньше фильтр даты искал один день текстом (`FieldDateTime`) или точное значение (`FieldDate`).
  Выбор дня в календаре больше не закрывает меню фильтра колонки. Перенесено из `hosting` (`FieldDateRange`).

- `Tab`: текст по дизайн-системе (design-ui-tabs.md) — размеры `xs` и `s` — ui/s (14 px, 600), `m` и `l` — ui/m
  (16 px, 600); было t3-b и t2-b. Меняет вид табов и на сайте (шапка, подвал, пагинация, мобильное меню).
- Меню админки по макету: отступы панели 20/16, блоки через 16, логотип 40 px, группы ui/s через 8 с разделителем,
  заголовок группы 4/8/4/4 с иконкой-плашкой 32 (радиус 10), текущая группа — color1/dark; пункты с отступом 4;
  внизу разделитель между кнопками и аккаунтом. Список групп без горизонтальной прокрутки в узком меню. У всех
  пунктов одинаковые отступы (раньше у текущего иконка сдвигалась на 8 px): иконка и текст вровень с группами.
  Меню по умолчанию свёрнуто; раскрытое запоминается в cookie `sf_admin_menu_collapsed` (было — `localStorage`
  `sf-admin-menu-collapsed`), сервер выводит меню сразу свёрнутым или раскрытым (`Page::isMenuCollapsed()`,
  класс `sf-menu-collapsed` на `<html>`).

- `TextInput`, `Textarea`, `Checkbox`: скрипты ищут элементы, когда разметка готова (`DOMContentLoaded`), и не
  инициализируют их повторно. В админке скрипты компонентов подключаются в `<head>` без `defer` и выполнялись до
  разметки: не работали крестик очистки и счётчик полей, частичная отметка чекбоксов.

- Фильтры списка по макету: в заголовке колонки вместо поля — кнопка фильтра с бейджем и меню (`th-filter`,
  шаблон `Table/tpl/show.filter.tpl`): поле поиска или значения переключателями radio, «Применить», «Сбросить».
  Значения для переключателей — новый `Field::getFilterOptions()` (`FieldBool`, `FieldEnum`,
  `FieldExtensionSelect`; `null` — фильтр без готового списка). У колонки с сортировкой или фильтром — «Сбросить»
  (действие `columnReset`, `?column=`), кнопка «Сброс» в колонке «Действия» убрана. Кнопка окна «Фильтры» с числом
  заданных — на всех ширинах; окно с подписями над полями, точкой у заданных, «Сбросить» в шапке. «Где искать»
  (`?qf=`, `Table::getSearchScope()`) — поиск в одной из текстовых колонок. Теги над таблицей — и для поиска,
  справа — «Сбросить всё». Классы: список фильтра `th-filter` → `filter-select`, текстовый фильтр — `filter-search`.
  Сортировка в заголовке колонки — один шеврон (`SortButton::drawSortButton()`, стиль line) вместо двух
  треугольников `drawSort()`: вверх — по возрастанию, вниз — по убыванию, клик — следующее направление.
  Подсказка `help` колонки — при наведении на её название (`th__help`), иконки «i» (`table__head-help`) нет.
  Узкая колонка расширяется под название, сортировку и фильтр (раньше шеврон ID сжимался до нуля). Значения
  в меню фильтра — text/t3, подпись не длиннее 2 строк (полностью — в `title`), больше 5 строк — прокрутка.
  Фильтр числа (`FieldInt` без внешнего ключа) — только цифры: `inputmode="numeric"`, остальное не вводится
  (`data-sf-digits`), нецифровое значение из запроса не применяется. Шаблон `Fields/tpl/filter.tpl` получает
  `$isDigits`.
- `Tooltip`: подсказка внутри предка с `overflow` (прокрутка таблицы) выводится поверх (`tooltip_fixed`) и больше
  не обрезается.
- `Modal::drawModal()`: параметр `headAction` — действие в шапке справа от заголовка. `Dropdown::drawMenu()`:
  пункт `active` — выбранный (`aria-current`).

- Лого админки настраивается сайтом: `ConfigBase::$adminLogo` (`name`, `src`, `srcDark` — пути к статике сайта),
  по умолчанию — Simflex CMS. Шаблоны админки выводят лого через `Page::drawLogo()`.

- Ссылка на запись списка `Table::show()` — `?show_id=<id>`: список открывается на странице с записью (при текущих
  сортировке и фильтрами), прокручивает к ней и подсвечивает. `?save_id=` после сохранения тоже открывает нужную
  страницу (раньше — первую, и подсветки не было). Переменная шаблона `show.tpl` `$saveId` переименована
  в `$highlightId`.

- Меню `Dropdown` внутри контейнера с `overflow` (прокрутка таблицы списка) больше не обрезается: панель, которая
  не помещается в контейнер, показывается поверх (`dropdown__panel_fixed`, координаты экрана) и закрывается при
  прокрутке. Раньше меню «Ещё» строки в коротком списке было видно лишь частично.

- `env()` читает и переменные окружения процесса (`getenv()`), если их нет в `$_ENV`: при `variables_order` без
  `E` (как в `php.ini-production`) переменная, заданная окружением контейнера, раньше молча заменялась значением
  по умолчанию.

- Необработанное исключение вне `devMode` всегда пишется в журнал PHP (`error_log`: класс, сообщение, файл:строка,
  стек), а ответом становится 500 «Внутренняя ошибка сервера» без деталей (`Kernel::handleException()`). Раньше при
  выключенном `enableLogging` исключение исчезало, и клиент получал пустой ответ 200 (белый экран).
- «Аккаунт» (`Admin\Handlers\Account`): пустой e-mail сохраняется как NULL, занятый другим пользователем e-mail
  даёт сообщение «Этот e-mail уже используется», ошибка БД при сохранении — сообщение «Данные не обновлены»
  вместо исключения. `Models\User::$email` — `?string`.

- `Alert::drawAdminMessages()` не забирает сообщения, если ответ — редирект (задан заголовок `Location`):
  раньше обработчик, который ставил `header('Location: …')` и возвращал содержимое, терял уведомление — макет
  выводил его в тело редиректа, которое браузер не показывает.

- Вне режима разработчика (`devMode`) ошибки PHP на сайте и в админке не выводятся в страницу
  (`display_errors=0`, `log_errors=1`): раньше, например, предупреждения устаревшего кода `scssphp` на PHP 8.4
  появлялись над страницей админки. Консоль по-прежнему выводит ошибки.

- Добавлен `DB::withoutSqlModes()`: временное исключение отдельных режимов MySQL для импорта старых данных,
  с восстановлением исходного режима соединения в `finally`, в том числе при исключении.

- Исправлены `isset()` и `??` у моделей: учитываются camelCase-колонки и незагруженные виртуальные связи.
  Геттер связи вызывается один раз и кэшируется; `0`, `false` и пустая строка не заменяются запасным значением.

- Страница редактирования в новом дизайне (`Table/tpl/form.tpl`, `theme/js/form.js`): page-head с «Сохранить»,
  уведомление об ошибках сохранения и ошибка под полем, секции полей (поля без группы — «Основное», `posGroup` и
  группы параметров — свои секции, раскрытие по шапке, сетка 4/3/2/1), правая панель (`pos: 'right'`, параметры
  `right`, «Создано/Изменено» — `Table::getTimeInfo()`) со скрытием, плавающая панель «Сохранить / Сохранить и выйти /
  Отмена», групповое редактирование — «Изменять это поле». Вкладки формы: параметр `tab` у `FieldDefinition`,
  `ParamDefinition`, `ParamGroup`, `ContentTemplateBlock` (вкладки видны, если их больше одной; `#tab-…` в адресе,
  вкладка с ошибкой открывается сама). Поля формы на компонентах Layout: строка и пароль — `TextInput`, текст —
  `Textarea` (с редактором — карточка TinyMCE), переключатель — `ToggleSwitch`, порядок — `Stepper`, цвет — образец и
  код, выпадающие списки (`Field::dropdown()`, внешние ключи, перечисления, выбор расширения, фильтры колонок) —
  `Dropdown` с поиском на сервере (`searchUrl`, `inputAttributes`); шаблоны `dropdown.tpl`, `form.actions.tpl` удалены.
  TinyMCE: скин и стили содержимого по теме админки, неиспользуемые скины удалены. «Профиль» и «Привилегии» — в
  новом дизайне. `Dropdown::drawSelect()`: параметры `searchUrl`, `inputAttributes`.

- Список раздела админки в новом дизайне (`Table/tpl/show.tpl`, `theme/js/list.js`): page-head с «Добавить»,
  карточка таблицы, поиск по текстовым колонкам с фильтром (`?q=`), теги выбранных фильтров, фильтры колонок —
  `TextInput` и `Dropdown` (`Field::filterDropdown()`, подпись значения — `Field::getFilterLabel()`), окно «Фильтры» на
  планшете и телефоне, сортировка `SortButton` с явным направлением (`?o=<поле>&d=0|1`, `aria-sort`), ячейки на
  компонентах Layout (переключатель, статус `Dropdown`, порядок `Stepper`, превью / `Placeholder`), действия строки
  `ButtonIcon` и меню «Ещё», плавающая панель `table-bar` по числу выбранных записей, удаление с подтверждением,
  подвал «Показано 1–20 из 50» + `Pagination`, пустая таблица, карточки на планшете и телефоне, отступ дерева
  классом (`td_level_N`) вместо inline-стиля. `width: 1` — главная колонка. Удалены скрипт ширин колонок в `vw` и
  `Table::$rowActionsCnt`. Что сделать в разделах со своими `showActions()`/`rowActions()`: кнопки на компонентах
  Layout; ссылка `?action=change_enum` вместо `?action=changeENUM`.

- Окна админки на `Common/Modal`: удаление (`alertdialog`), сведения о записи, подтверждение `sfAdmin.confirm()`
  (`theme/js/modals.js`); панель поддержки `support-bar` (форма обращения грузится при первом открытии); страница
  группы меню — карточки подпунктов, виджеты — карточки (обёртка `widgets` перенесена в шаблон); страница «нет доступа»
  в стиле входа. Удалены окна `help`, `context`, `account`, `sidebar`, `mobilebar`.

- Компоненты Layout: `UI/Core/Calendar` (виды дни, месяцы, годы, время, клавиатура, `min`/`max`, событие
  `calendar:select`), `UI/Core/TagsInput` (поле тегов с подсказками и поиском на сервере), `Common/Uploader`
  (загрузка одного файла: перетаскивание, прогресс, «Из библиотеки», удаление). `TextInputKind::Date`, `DateTime`,
  `Time` — поле с маской и календарём.
- Поля админки на новых компонентах: `FieldDate`, `FieldDateTime`, `FieldTime` — маска и календарь (значение
  в форме `ДД.ММ.ГГГГ [ЧЧ:ММ]`, `getPOST()` переводит в формат БД); `FieldTags`, `FieldMultiKey`, `FieldRelation` —
  `TagsInput`; `FieldImage`, `FieldFile` — `Uploader`. Действия `upload_img` и `upload_file` принимают `source` —
  адрес файла в `/uf` (выбор из файлового менеджера): файл копируется в каталог поля (`Media\File::loadFile()`).
  Удалены bootstrap-пикеры `Admin/Plugins/UI` и `Admin/theme/ui` (datepicker, timepicker, datetimepicker,
  fileinput), шаблоны полей `datetime.tpl`, `time.tpl`, `select.tpl` (не использовался); шаблоны `tags.tpl`,
  `file.tpl`, `image.tpl` получают другие переменные (`selected`, `options`, `searchUrl`, `allowNew`).
- Файловый менеджер (пакет `simflex/file-manager` 4.0) — новое окно на компонентах Layout: `body.tpl`
  рендерит `src/tpl/index.tpl` пакета с переменными API, корня файлов, статики и темы, скрипт — модуль
  `file-manager.js` (`Admin\Page::jsModule()` — скрипт-модуль по веб-адресу), стили — со стилями админки. Глобальные
  `fileManager.apiBase`, `rootDir`, `assetsDir` и `styles.css` пакета не подключаются. Открытие —
  `window.fileManager.open({multiple, onSelect})`. В окне строки поля-таблицы у колонок `image` и `file` —
  «Из библиотеки». Плагин TinyMCE `fm` вставляет картинку тегом `img`, другой файл — ссылкой, несколько файлов сразу;
  заглушки `plugin.js`, `plugin.ts` удалены. TinyMCE: `relative_urls: false` — адреса от корня сайта (`/uf/...`).
- `Common/Modal`: окна открываются стопкой — окно поверх открытого (подтверждение, файловый менеджер поверх окна
  строки) при закрытии возвращает предыдущее; раньше второе окно закрывало первое.
- Поля-таблицы `FieldTable` и `FieldVirtualTable` — таблица `edit-table` на разметке списка (карточки на планшете
  и телефоне) и окно строки на компонентах Layout (`Fields/tpl/table.tpl`, ES-модуль `theme/js/table-editor.js` без
  jQuery). Удалены `theme/js/table.js` (`TableEditor`), `theme/js/vtable.js` (`VTableEditor`), `Table/js/struct.table.js`,
  `Fields/tpl/vtable.tpl`, окно `theme/tpl/modals/point.tpl` (`window.openPointModal()`). Контракт действий раздела
  `vtGet`, `vtAdd`, `vtEdit`, `vtDelete`, `upload_table_file` прежний. `Plugins/Editor/Editor::getConfig()` — настройки
  TinyMCE для редактора, который запускается скриптом. У новой записи `FieldVirtualTable` выводит уведомление
  (`vtable-notice.tpl` был пустым).
- Модули сайта (`Handlers\ModuleItem`): `Table/js/moduleitem.js` — ES-модуль без jQuery; параметры модуля
  загружаются при выборе модуля (событие `change` списка), выполняются их скрипты (редактор TinyMCE), редакторы
  прежнего модуля удаляются. Поле `module` без `onchange` (раньше срабатывал и в фильтре списка). Исправлено:
  редактор в параметрах модуля не запускался (`Editor::tinymce('full')` без класса давал селектор `.` и отменял
  инициализацию поля; скрипт TinyMCE не подключался к ajax-ответу — `Editor::addScript()`).
- `Field::isWide()` — поле формы на всю строку (`form-input_wide`): `FieldText`, `FieldTable`, `FieldVirtualTable`,
  `FieldMultiKey`, `FieldRelation`, `FieldTags` и поля с редактором; используется формой и параметрами модуля
  (`form.field.tpl`).

- Вход в админку (`login.tpl`) — карточка `auth-card` на компонентах Layout (логин и пароль с иконками, показ пароля,
  «Запомнить меня»), тема как в админке. Форма отправляется POST (раньше GET — пароль попадал в адрес и журналы
  сервера). При ошибке входа — уведомление «Неверный логин или пароль» (`Admin\Auth::WRONG_LOGIN_MESSAGE`, один текст
  для неверного логина, пароля и пользователя без доступа), при пустых полях — «Введите логин и пароль».

- Сообщения в админке (`Alert`) выводит макет: успех — тост (`Toast`), ошибка, предупреждение, информация —
  уведомление `Notice` в правом верхнем углу (`Alert::drawAdminMessages()`); `Alert::getHTML()` в админке ничего
  не выводит, шаблон `Admin/theme/tpl/alert.tpl` удалён. Старая разметка действий строки — класс `row-tip` вместо
  `tooltip` (класс занят компонентом `Tooltip`); что сделать в расширениях: заменить `class="tooltip"` в своих
  шаблонах админки.

- Каркас админки нового дизайна: меню (`theme/tpl/partial/sidebar.tpl`, сворачивание, поиск, группы, шторка на
  планшете и телефоне), `topbar-mobile`, `page-head` (`Admin\Page::drawPageHead()`), переключатель темы. Иконки
  `MenuItem::$icon` — ID дизайн-системы (`lock-mini` → `lock-on`, `settings` → `setting` и т. д., таблица в плане
  `admin-4.0.md`, 0.2); что сделать на сайте и в расширениях: заменить старые имена иконок пунктов меню. Модуль
  `Breadcrumbs` выводит компонент `Breadcrumbs`. `LayoutManager` подключает `components.scss` глобальной директории
  после стилей компонентов.

- Новые компоненты `Layout`: `Buttons/ButtonIcon` (кнопка-иконка 24 px, Figma `Buttons/icon-small`), `Tooltip`
  (подсказка и иконка «i», задержка 150 мс, `Esc`, `aria-describedby`), `Notice` (уведомление info/error/alert/success),
  `Toast` (тост и стопка, `window.sfToast()`, не меньше 5 секунд, пауза таймера при наведении и фокусе). `Common/Breadcrumbs`
  (сворачивание середины на телефоне), `Common/Pagination` (номера, компактный вид, переход по номеру),
  `Other/Placeholder` (аватар, «нет картинки»). `Tab` стиль `soft`: нажатие и активное состояние по дизайн-системе
  (`main/color1/light`, `main/color1/lighter`; раньше совпадали с `secondary`).
  `Dropdown`: `drawSelect()` (поле-селект со скрытым полем, поиск, `listbox`) и `drawMenu()` (меню действий),
  клавиатура, открытие вверх при нехватке места.
  `SortButton` (кнопка направления и заголовок столбца с сортировкой), `Stepper` (число с кнопками, min/max/step).
  `TextInput`: `TextInputKind::Password` (кнопка «Показать пароль»), параметры `success` и `slot` (HTML справа в
  поле); кнопка очистки — с именем «Очистить» и вне порядка фокуса, пока поле пустое.
- Доработки компонентов `Layout` по дизайн-системе: `ToggleSwitch` — корень `<label>` (подпись — имя переключателя),
  состояние `disabled`, `focus-visible`, галочка из спрайта (`check`) вместо inline-SVG; `RadioOption` — `disabled`
  на `states/disabled`, `focus-visible`; `Modal` — параметр `alert` (`role="alertdialog"`); `LoaderIcon::drawLoader()`
  (размеры xs–xl, primary/monochrome, `role="status"`); `Button` — недоступная кнопка на `states/disabled/*`
  (было `main/gray/medium`), стили `Success` и `Error`; `Tag` — `icon`, `close` (отдельная кнопка «Удалить …»),
  `closeLabel`; `Badge` — метки `badges/product` по дизайну (`Sale`, `New`, `NoStock` — новые цвета; `Hit`, `Info`,
  `Preorder`, `Video`, `ThreeD`); миксин `scrollbar()` (classic/overlay, s/m/l, тёмная тема). Вид на сайте меняется
  у недоступных кнопок и меток `Sale`/`New`/`NoStock`.

- **Меню админки двухуровневое (несовместимо):** группа и её пункты; пункт третьего уровня (`children` у подпункта,
  `Menu::add(..., parent: <подпункт>)`) — `LogicException`. «Редактор страниц» перенесён в новую группу «Контент»:
  группа `/content`, раздел `/content/page` (было `/content`). Что сделать на сайте: ссылки на `/admin/content` как на
  редактор заменить на `/admin/content/page`; `before: '/content'` и `remove('/content')` теперь относятся к группе.

- Админка, основа нового дизайна: компоненты `Layout` выводятся в админке, их стили собираются
  `LayoutManager` в `Admin\Page::getMeta()` с корневым стилем `Admin/theme/styles/style.scss` в отдельный кеш
  `cache/css/admin*.css` (переопределения сайта `Layout/assetsGlobal` не подключаются). Десктоп админки — в px:
  свой `Admin/theme/styles/tokens/_functions.scss` (`vw()`, `vwh()` → px, `vwt()`, `vwm()` → `vw`). Тело макета
  (`theme/tpl/body.tpl`) рендерится до head, `login.tpl` и `denied.tpl` выводят `$page->getMeta()`.
  Спрайт иконок админки `Admin/theme/img/icons.svg` (ID дизайн-системы), `renderIcon()` в `Location::Admin`
  берёт его. `Admin\Page::coreJsModule()` — скрипты-модули (`<script type="module">`). Витрина компонентов
  `/admin/ui` (`Handlers\Ui`) — только в режиме разработки, привилегия `DEV`. Тема админки — cookie `sf_admin_theme`
  (`Admin\Page::getTheme()`, `data-theme` на `<html>`). Шрифт админки — только вариативный Inter (статические
  начертания и InterDisplay удалены). Общий JS-модуль `Admin/theme/js/admin.js` (`window.sfAdmin`: `request()` с
  CSRF-токеном, `register()`, `toast()`, `confirm()`), CSRF-токен страницы — `<meta name="csrf-token">`.

- **Токены цветов `Layout` переименованы по дизайн-системе (несовместимо):** `--gray-*` → `--color-main-gray-*`,
  `--color1-*`/`--color2-*` → `--color-main-color1-*`/`--color-main-color2-*`, `--gradient1-*` →
  `--color-main-gradient1-*`, `--bg-*` → `--color-main-bg-*`, `--error-*`/`--alert-*`/`--success-*` →
  `--color-states-*`, `--disable-*` и `--state-disabled-*` → `--color-states-disabled-*` (значения из дизайн-системы:
  `#616466`, `#C1C7CC`, `#DFE4EB`), `--state-clear-*` → `--color-states-clear-*` (прозрачные), `--uniq-*` →
  `--color-uniq-*`, `--socials-<xx>` → `--color-social-<сервис>-main` (`wt` → `whatsapp`, `tg` → `telegram`,
  `ya` → `yandex`, `in` → `instagram`, `go` → `google`, `yt` → `youtube`, `fg` → `figma`), `--delivery-*` →
  `--color-delivery-*`. `--color-text-icon-*` — свои значения, а не ссылки на заливки. Удалены `--transparent`
  (пишется `transparent`), тени `--shadow-near`/`--shadow-medium`/`--shadow-far` (→ `--shadow-gray-s`/`-m`/`-l`),
  SCSS-переменные `$disable*` и `$transparent`. Новые классы текста `.heading-h1`…, `.text-t1`…, `.ui-m`…,
  `.uniq-hero` (`styles/utils/_text.scss`). Что сделать на сайте: заменить старые имена в стилях темы
  (`public/assets/<тема>/css`) и в переопределённых `Layout/assetsGlobal/styles/*`.

- camelCase-доступ к колонкам ModelBase работает также до вставки записи и сохраняет значения 0, false, пустую строку и null; загрузка связей по-прежнему требует сохранённую модель.

- `User::aqModifyHasPrivileges()` квалифицирует колонку привилегии в подзапросе связи ролей: устранена неоднозначность с `user_role.privilege`.

- Schema сохраняет все безымянные индексы и ограничения: внутренние ключи больше не зависят от microtime(), исключено случайное перезаписывание элементов при быстром создании.

- `System\Session::regenerateId()` обновляет PHP session id при смене авторизации в контроллере сайта.

- Общий `Http\Csrf`: токен сессии, проверка POST-поля `csrf` или заголовка `X-CSRF-Token`,
  отклонение неверного токена. `Auth\SessionStorage::set()` обновляет токен при входе и выходе.
  Сайт подключает проверку явно через `Csrf::check($request)` до изменяющего действия.

- Вход в админку принимает логины с подчёркиванием, соответствующие сохранённым учётным записям.

- Исправлено сохранение новой модели с первичным ключом `id`: идентификатор записывается также в данные модели, последующее `save()` обновляет существующую запись.

- Telegram API поддерживает необязательный прокси: `telegram['proxy']` (в шаблоне — `TELEGRAM_PROXY`). Без значения используется прямое подключение.

- **`./sf` возвращает код завершения (несовместимо):** `Kernel::runConsole()` и `Cli::run()` возвращают `int` (`Cli::SUCCESS` — 0, `Cli::FAILURE` — 1), `Cli::execute()` — тоже. Исключение в команде (теперь любое `Throwable`), неизвестный провайдер или метод и отсутствующий обязательный аргумент дают `FAILURE`; сообщение по-прежнему пишется в лог и дополнительно в stderr. Что сделать на сайте: последняя строка `sf` — `exit(new \Simflex\Core\Kernel(__DIR__)->runConsole());`, иначе процесс по-прежнему завершается с кодом 0.

- Доступ к файловому менеджеру админки задаётся конфигом `fileManagerPrivilege` (по умолчанию `Privilege::ADMIN`): нужен вход в админку и эта привилегия, проверка — `Kernel::canUseFileManager()`.

- Виджет по запросу `?sfwidget=<id>` проверяет привилегию виджета (колонка `privilege`), как страница группы: без неё — 403 и пустое содержимое. Несуществующий, выключенный виджет или класс, не наследующий `WidgetBase`, — 404 без фатальной ошибки.

- Cron: расписания всех заданий `cron/run` сверяются с временем запуска команды, а не с моментом проверки задания — долгое задание не заставляет следующие пропустить свою минуту. `Cron::testTiming()` принимает момент проверки вторым аргументом. Исправлено расписание `*/n`: раньше совпадало только с нулевым значением поля.

- `ModelBase`: после вставки идентификатор берётся из `DB::insertId()`, только если он больше 0 — у таблицы без `AUTO_INCREMENT` остаётся ключ, переданный в данных модели.

Изменения относительно 3.6.0. Главное: структура админки, привилегии, меню, шаблоны страниц, компоненты, модули
и задачи cron объявляются в коде, а не хранятся в базе; раздел админки — один класс; работа с базой — через ORM.

### Несовместимые изменения

- **`ExtensionConfig`:** свойство `$handlers` переименовано в `$adminHandlers`, метод `getHandlers()` — в `getAdminHandlers()` (разделы админки расширения). Что сделать в расширении: переименовать свойство в `provider/extensions/<имя>.php`.
- **`ModelBase`:** `insert()`, `save()`, `update()`, `bulkUpdate()` и `upsert()` заполняют `COLUMN_TIME_CREATE` и `COLUMN_TIME_UPDATE`; модель таблицы без этих колонок обязана переопределить константы в `null` (журналы, связи, кэши).
- **Пути без конечного «/»:** `content.path` и ключи меню — `/catalog`, `/blog/post` (раньше `/catalog/`); путь страницы в админке строится без слэша, `Resolver` разбирает меню по таким путям, запрос со слэшем на конце (`/catalog/`) отправляет на `/404`. `policyUrl` по умолчанию — `/policy`. Подсветка пункта меню сравнивает путь по границе сегмента (`/blog` не совпадает с `/blog2`). Что сделать на сайте: убрать слэш в `content.path`, `menu.link` и ссылках в шаблонах.
- **`ModelBase`:** публичный `insert()` экземпляра убран — новая модель записывается через `save()`; статический `insertStatic()` переименован в `insert()` (`Model::insert([...])` возвращает модель или `null`).
- **Пакет ядра переименован:** `growtask/simflex` → `simflex/core` (репозиторий `simflex-core`; промежуточное имя
  4.0 — `growtask/simflex-core`). Пакет `growtask/simflex` остаётся для сайтов на 3.x; сайт 4.0 требует
  `"simflex/core": "dev-master"` (тегов 4.0 пока нет). Файловый менеджер — `simflex/file-manager`
  (было `growtask/simflex-file-manager`), ядро ищет его в `vendor/simflex/file-manager`. Что сделать на сайте:
  имена пакетов в `composer.json`, пути `vendor/simflex/core` в `phpstan.neon` и `Extensions/Install/PackageInstaller.php`.
- **PHP 8.4** (`"php": "^8.4"`), обязательно расширение `mbstring`.
- **Структура админки в коде.** Таблицы `struct_table`, `struct_table_right`, `struct_field`, `struct_field_param`,
  `struct_param`, `struct_data`, их модели и разделы «Структура» удалены. Раздел админки описывается классом
  (см. «Разделы админки» ниже).
- **Компоненты, модули, параметры модулей** объявляются в коде: списки классов в `provider/components.php`
  и `provider/modules.php` приложения (`\Simflex\Core\System\ExtensionRegistry`), настройки — статическими методами класса
  (`extensionTitle()`, `modulePostexec()`, `adminParams()`). Таблицы `component`, `component_param`, `module`,
  `module_param` и их модели удалены; `menu.component` и `module_item.module` хранят имя класса.
- **Привилегии в коде:** `\Simflex\Core\System\Privilege` с константами `DEV`, `ADMIN`; приложение расширяет реестр наследником
  (конфиг `privilegeClass`). Роли, пользователи, меню и виджеты ссылаются на привилегию по имени (колонка `privilege`),
  а не по id. Привилегии `admin` и `simplex_admin` объединены в `Privilege::ADMIN`; `dev` имеет все привилегии
  и не выключается. Таблица `user_privilege` необязательна — хранит только переключённую в админке активность.
  Нейминг `priv` заменён на `privilege` (модели `UserRolePrivilege`, `UserPrivilegePersonal`).
- **Меню админки в коде:** `\Simflex\Core\Admin\Menu` (пункты `MenuItem`), приложение расширяет наследником
  (конфиг `adminMenuClass`). Таблица `admin_menu`, модель `AdminMenu` и раздел «Меню» в «Управлении» удалены.
- **Модули админки** (боковое меню, хлебные крошки) — `\Simflex\Core\Admin\AdminModules` (конфиг `adminModulesClass`),
  в `module_item` хранятся только модули сайта; `ModuleType` и `moduleType()` удалены.
- **Шаблоны страниц в коде:** `provider/templates.php` приложения (`ContentTemplate`, `ContentTemplateBlock`,
  `ContentTemplates`); страница хранит ключ шаблона (`content.template`). Таблицы `content_template`,
  `content_template_param` и их модели удалены.
- **Задачи cron в коде:** `provider/cron.php` (`\Simflex\Core\Cron\CronRegistry`, `CronJob`); таблица `cron` хранит
  только активность и расписание.
- **Сидеров больше нет:** начальные данные пишет миграция, создающая таблицу (`$s->seed(callable)`). Удалены
  `Seeder`, `Cli\Seeder` (`./sf seed/run`), модель и таблица `seeder`, атрибут `Manual`.
- **Вывод возвращается строкой:** `content()` компонентов, модулей, полей и разделов админки возвращает HTML,
  а не печатает его (`render()` вместо `include`).
- **Разделы админки переименованы и переразложены:** `Admin\Base` → `Admin\Table\Table` (абстрактный),
  классы-драйверы `Admin\Base\*` и `Extensions\Content\Admin\AdminContent` влиты в разделы `Admin\Handlers\*`,
  модуль `Admin\Modules\Account` → раздел `Admin\Handlers\Account`, `Admin\Plugins\Pagecontrol` → `Pagination`.
- **Геттеры называются с `get`/`is`:** у `Table`, `Repository`, `Menu`, `AdminModules`, `Privilege`
  (`getFields()`, `getParams()`, `Menu::getItems()`, `Privilege::getAll()` и т.д.).
- **Удалён устаревший код:** `Core\User`, `Core\UserInstance` (и колонки `user.hash`, `user.hash_admin`),
  `Core\Auth`, `Core\Service` (→ `Helpers\Tree`, `Str::translite()`), `Core\Alert\Console\Alert`, `DB::bind()`,
  `@SITE_PATH`, `Core::ajax()/uri()/uri_r()/path()/getComponentAPI()/component*()`, `Profiler::start()/output()`,
  `Time::sub_time()`, `BaseMiddleware::setUserModelClass()` (→ `Factory::override()`), `AQ::selectColumn()`,
  `AQ::asScalar()` (→ `AQ::fetchColumn()`), `Admin\InstallBase`.
- **Удалены методы, на которые могли опираться сайты и расширения:** `Alert::output()` админки и сайта
  (→ `echo Alert::getHTML()`), конструктор `ExtensionBase` и свойство `$rootDir`
  (→ `getRootDir()`, не зависит от конструктора; наследникам компонентов и модулей не вызывать
  `parent::__construct()` — это фатальная ошибка), `Admin\Plugins\UI\UI::treeView()`, `FieldImage::loadUI()`,
  `UserRole::addPriv()`, `Chain::getUserModelClass()`, `ModelContent::aqModifyWithTemplate()` (шаблон страницы —
  ключ в `content.template`, см. `ContentTemplates`).
- **Корень веб-сервера — каталог `public/` сайта;** статика ядра публикуется в `public/cache/assets/<hash>/`
  (`\Simflex\Core\Http\Assets`), исходники ядра и сайта снаружи недоступны.
- **Статика сайта — `public/assets/<тема>/`** (название темы, как в `theme/`): `asset()` и `renderIcon()` берут
  тему из `config->theme` (было `public/assets/`).
- **Настройки расширений** лежат в `provider/extensions/` сайта (было `provider/extension/`); в пакете —
  `src/provider/extensions/`.
- **Адрес админки** задаётся конфигом `adminPath` (по умолчанию `/admin`), ссылки меню — относительно него.
- Лог по умолчанию пишется в `log/` (`ConfigBase::$logPath`), в файл — при `logToFile`.
- **Связи записи** (`FieldMultiKey`, `FieldRelation`) у новой записи до вставки ничего не пишут: `Table::save()`
  сохраняет их после вставки, по id записи (`Field::$isSavedById`). Обход `getPOST()` после `parent::save()`
  в разделах не нужен.
- **`FieldMultiKey` без особых случаев каталога:** колонка таблицы связей с id записи — параметр `relation_key`
  (было: `link_id`, если ключ раздела и выбираемых записей — `product_id`), подпись «Имя (Родитель)» — параметр
  `parent_key` (было: только у категорий на таблице `catalog_product`).
- **Загрузка файлов в поля-таблицы** (`FieldTable`, `FieldVirtualTable`) — действие раздела `upload_table_file`
  (`Table::uploadTableFile()`): белый список расширений, случайное имя, каталог `/uf/images|files/<$uploadDir>/`,
  в поле строки — адрес файла. Раньше изображения колонок уходили в `upload_img` (`/uf/images/content/source/`),
  файлы — в `upload_file` (в поле — только имя), а файлы `FieldVirtualTable` — на адрес формы, где их принимал
  `Handlers\Content::ajaxUpload()` (удалён вместе с переопределением `content()`).

- **Namespace ядра — `Simflex\Core\`** (было `Simflex\`), каталог `src/Core` — `src/System`, HTTP-слой и
  самостоятельные подсистемы вынесены из него. Имена 3.6 → 4.0 (все — от `Simflex\`):

    | Было | Стало |
    |---|---|
    | `Core\Container`, `EventManager`, `ConfigBase`, `Privilege`, `CodeRegistry`, `ExtensionRegistry`, `ModelBase`, `ModuleBase`, `Buffer`, `Cache`, `Session`, `Core\DI\*`, `Core\Events\*`, `Core\Errors\*`, `Core\Middleware\*` | `Core\System\…` |
    | `Core\Core` (ядро сайта), `Core\Page` | `Core\Http\Page`; загрузка сайта — `Core\Kernel` |
    | `Admin\Core`, `Admin\Page` | `Core\Admin\Page` |
    | `Core\View`, `Core\Assets`, `Core\SitemapBase` | `Core\Http\View`, `Core\Http\Assets`, `Core\Http\SitemapBase` |
    | `Core\Api\*`, `Core\Cookie\*`, `Core\Html\*`, `Core\Request`, `Core\Response` | `Core\Http\Api\*`, `Core\Http\Cookie\*`, `Core\Http\Html\*`, `Core\Http\Request`, `Core\Http\Response` |
    | `Core\ComponentBase`, `Core\ControllerBase`, `Core\Controller\*`, `Core\Routing\*` | `Core\Http\ComponentBase`, `Core\Http\ControllerBase`, `Core\Http\Controller\*`, `Core\Http\Routing\*` |
    | `Core\Alert\Site\Alert` | `Core\Extensions\Alert\Alert` |
    | `Core\Console\*`, `Core\ConsoleBase` | `Core\Console\*`, `Core\Console\ConsoleBase` |
    | `Core\Cron\*`, `Core\Mail\*`, `Core\Models\*`, `Core\Telegram\*` | `Core\Cron\*`, `Core\Mail\*`, `Core\Models\*`, `Core\Telegram\*` |
    | `Core\DB\*`, `Core\DB` | `Core\DB\*`, `Core\DB\DB` |
    | `Core\Helpers\*`, `Core\Time`, `Core\TimeDiff` | `Core\Helpers\*`, `Core\Helpers\Time`, `Core\Helpers\TimeDiff` |
    | `Core\Logger\*`, `Core\Log` | `Core\Logger\*`, `Core\Logger\Log` |
    | `Core\Sms\*`, `Core\Sms` | `Core\Sms\*`, `Core\Sms\Sms` |
    | `Core\Wrapper\*` (DebugBar, Whoops), `Core\Profiler` | `Core\Debug\*`, `Core\Debug\Profiler` |
    | `Core\HasAdminParams` | `Core\Admin\HasAdminParams` |
    | `Core\Factory` | `Core\System\DI\Factory` |
    | `Core\File`, `Core\Image` | `Core\Media\File`, `Core\Media\Image` |
    | `Models\ModelSettings`, `Extensions\Content\Models\ModelContent` | `Core\Models\Settings`, `Core\Extensions\Content\Models\Content` |
    | `Admin\*`, `Auth\*`, `Extensions\*`, `Layout\*` | `Core\Admin\*`, `Core\Auth\*`, `Core\Extensions\*`, `Core\Layout\*` |

    Autoload пакета: `"Simflex\\Core\\": "src"`. Замена в коде сайта и расширений — по таблице.
- **Загрузка сайта — `Simflex\Core\Kernel`** (в 3.6 — `console.php`, `cron.php` и загрузчик в `index.php` сайта):
  точки входа создают ядро с корнем сайта — `new Kernel(dirname(__DIR__))->runHttp()`,
  `new Kernel(__DIR__)->runConsole()`. События `PreCoreInit`/`PostCoreInit` → `PrePageInit`/`PostPageInit`.
- **Глобальных констант `SF_*` нет:** `SF_ROOT_PATH`, `SF_PUBLIC_PATH`, `SF_CORE_ROOT_PATH` →
  `Container::getPaths()->getRoot()`, `getPublic()`, `getCore()` (`System\Paths`, принимают путь от корня);
  `SF_LOCATION`, `SF_LOCATION_*` → `Container::getLocation()`, перечисление `System\Location` (`Site`, `Admin`, `Api`,
  `Cli`). `src/constants.php` и `ide-stubs.php` удалены; `constants.php` сайту не нужен. В конфиге `$logPath`
  по умолчанию пустой (лог — `log/` сайта, `getLogPath()`), `$files` — только переопределённые файлы `provider/`.
- **Страница — объект в контейнере** (`Container::getPage()`), ядра в контейнере нет (`getCore()` удалён):

    | Было | Стало |
    |---|---|
    | `Core::init()`, `Core::getComponent()`, `Core::execute()`, `Page::init()` | `$page->init()`, `initRequest()`, `getComponent()`, `execute()` (`Http\Page`) |
    | `Page::content()`, `position()`, `meta()`, `metaJS()`, `moduleById()` | `$page->getContent()`, `getPosition()`, `getMeta()`, `getMetaJs()`, `getModuleById()`; в теме — переменная `$page` |
    | `Core::siteParam($key, ...)`, `Core::siteParam()`, `Admin\Core::siteParam($key)` | `System\Settings::get($key, ...)`, `Settings::getAll()` |
    | `Core::menu()`, `Core::menu('by_id')`, `Core::menu('by_link')`, `Core::menuCurItem()` | `Http\Menu::getTree()`, `getById()`, `getByLink()` (ключ — ссылка), `getCurrent()` |
    | `Page::css()`, `js()`, `jsInline()`, `addAsset()`, `metaCSS()` | `Http\PageAssets::css()`, `js()`, `jsInline()`, `add()`, `getCssHtml()` |
    | `Page::seo()`, `addMetaRaw()`, `title()`, `Page::$override`, `Page::$seoTitle` | `Http\PageSeo::seo(..., exactTitle:)`, `addMetaRaw()`, `getFullTitle()`, `getTitle()`, `getDescription()`, `getKeywords()` |
    | `Admin\Core::url()`, `root()`, `isAdminPath()`, `webVendorPath()` | `Admin\Page::url()`, `root()`, `isAdminPath()`, `webVendorPath()` (статические) |
    | `Admin\Core::path()`, `uri()`, `menu()`, `menuCurItem()`, `crumbs()`, `ajax()`, `$isAjax` | `Admin\Page::get()->getPath()`, `getUri()`, `getMenu()`, `getCurrentMenuItem()`, `getCrumbs()`, `isAjax()` |
    | `Admin\Page::css()`, `js()`, `coreCss()`, `coreJs()`, `meta()`, `content()`, `position()` | `Admin\Page::get()->css()`, `js()`, `coreCss()`, `coreJs()`, `getMeta()`, `getContent()`, `getPosition()` |

    Удалены `Core::error404()`, `isHttps()`, `httpProtocol()`, `getExtensions()`, `Page::module()`,
    `Page::$showAside`, `ExtensionBase::root()`, `link()`. `getMeta()` выводит и description, keywords;
    `Resolver::setMenuByLink()` → `setMenu()` (ключ — ссылка пункта).
- **Запрос только через `Request`:** ядро не читает `$_GET`, `$_POST`, `$_REQUEST`, `$_FILES`, `$_SERVER`, сессия —
  `System\Session`. `Request::get()`, `post()`, `request()`, `cookie()`, `file()` с ключом `0` возвращают параметр,
  а не все параметры. Раздел админки получает запрос в `$this->request` (`Admin\Handler`), поле админки читает
  отправленное значение через `getPosted()`, id записи — `getRecordId()`; подмена `$_POST` для групп параметров
  заменена на `Field::setPosted()`. `CliRequest` больше не заполняет `$_GET`/`$_POST`/`$_REQUEST`. Нормализовать
  данные перед сохранением — в `getInsertData()` / `getUpdateData()` раздела, а не правкой `$_POST`.
- **`FieldVirtualTable::$query`** — только `AQ` (`$queryCount`, `$binds` и SQL-строки удалены); `getPOST()` полей
  `FieldDate`, `FieldDateTime`, `FieldAlias` возвращают значение без экранирования (оно передаётся параметром запроса).
- **Сообщения — один класс `Extensions\Alert\Alert`** для сайта и админки (`Admin\Plugins\Alert\Alert` удалён,
  `Core\Alert\Site\Alert` перенесён): вёрстка и ключ сессии выбираются по окружению (`Container::getLocation()`),
  вывод сообщений админки — `Admin/theme/tpl/alert.tpl`. Раздел ошибок в админке — `error` (был `danger`), `has()`
  возвращает `bool`, `getHTML()` удаляет только выведенные сообщения.
- **Удалено поле `FieldCategorySelect`** (таблица `shared_category` не создавалась ни одной миграцией).
- **`Helpers\Time`:** методы в camelCase — `what_format()` → `detectFormat()`, `userfull()` → `userFull()`,
  `sub_times()` → `subTimes()`, `form_dates()` → `formDates()`; удалены `startTimer()`, `getExecTime()`, `getMonths()`,
  `$daysInMonth`. `unix()` возвращает `int`, форматирующие методы — `string`.
- **Транзакции:** `DB::transaction(callable)` вместо `transactionStart()`, `transactionCommit()`,
  `transactionRollback()`, `transactionEnd()`; адаптер реализует `Adapter::inTransaction()`. Сохранение записи
  раздела админки (с переопределениями `save()` наследников), удаление записи раздела (`deleteItem()`)
  и `CronRegistry::sync()` выполняются в транзакции.
- **Одна почта:** старый `Simflex\Core\Mail` (`Mail::create()->send()`, windows-1251, журнал `mail_log` без миграции)
  удалён, письма отправляет `Simflex\Core\Mail\Mailer` (`Mailer::get()->sendText()`, `sendPlain()`, `sendTemplate()`).
- Удалены `Simflex\Core\Path` (вместо `Path::dirToHref()` — `Assets::publish()`), заглушки
  `Core\Component\Stub\*`, умолчания `src/routes.php`, `src/events.php`, `src/services.php`: `ConfigBase::$files`
  по умолчанию указывает на `provider/*.php` сайта, отсутствующий файл — пустой список.

### Добавлено

- **Админка:** карточка записи (модальное окно с информацией) выводит строки «Создано» и «Изменено» из `COLUMN_TIME_CREATE` и `COLUMN_TIME_UPDATE` модели, если раздел не объявил эти колонки полями; в список и форму они не попадают.
- **Колонки `time_create` и `time_update`:** `Schema::createTable()` сам добавляет их в каждую новую таблицу; `Table::noTimestamps()`, `timestampsOnlyTimeCreate()` и `timestampsOnlyTimeUpdate()` — таблица без колонок или с одной. `ModelBase` заполняет их при `insert()`, `save()`, `update()`, `bulkUpdate()` и `upsert()`; имена колонок — константы `COLUMN_TIME_CREATE` и `COLUMN_TIME_UPDATE`, модель таблицы без колонки переопределяет константу в `null`. Явно заданное значение сохраняется.
- Компонент `Logo` рисует настоящие знаки бренда из `public/assets/<тема>/images/brand` (логотип, «Создано» с флагом, «На базе», тёмные варианты); у `logo-anim` по наведению знак сменяется подписью «Главная» (CSS, `prefers-reduced-motion` отключает смену); новые параметры `caption` и `homeText`. Знак-заглушка из трёх столбиков удалён. Адрес движка в подвале по умолчанию — `https://simflexcms.ru`.
- **Подвал сайта** — компонент `Layout\Components\Common\Footer` (`Footer::drawFooter()`): логотип, кнопка «Связаться
  с нами» (`data-modal="callback"`), телефон, почта, соцсети, колонки меню (`Tab` flat, размер s), вертикальная линия,
  нижняя строка («© компания год», `made-in`, `made-by`); адаптив hd / tablet / mobile по Figma `footer_market`
  (без каталога, ecom и иконок оплаты; на tablet и mobile колонки меню и линия скрыты, как в макете). Не переданные
  значения берутся из настроек (`phone`, `email`, `company`, `site_name`, `vk`, `tg`, `whats_app`). Нижний отступ —
  css-переменная `--footer-indent-bottom` (задаёт css сайта). Колонки меню — `Footer::getMenuColumns()`.
- **Меню: место вывода.** Колонка `menu.place` (`main` — основное меню, `footer` — подвал; константы
  `Models\Menu::PLACE_MAIN`, `PLACE_FOOTER`): корневые пункты подвала — заголовки колонок, вложенные — их ссылки.
  Модуль «Меню» получил параметр `place` (по умолчанию `main`: колонки подвала в шапке не выводятся), `Http\Menu`
  — методы `getRoots($place)` и `getChildren($pid)`, в разделе админки «Меню» — поле «Где выводится».
- Компонент `Common/HeaderBanner` (`drawHeaderBanner()`): строка над шапкой по `Promo/Header/static` - текст, кнопка
  и закрытие; закрытие запоминается в `localStorage` (с `try/catch`, ключ меняется вместе с содержимым строки).
- Компонент `Common/Header` (`drawHeader()`, `drawNav()`, `getMenuItems()`): шапка по `header_market` без каталога,
  поиска, меню пользователя и города - `top` (логотип), `bottom` (слот `geo`, пункты `Tab`/`DropdownTab`, соцсети,
  контакты, кнопка с `data-modal`), `line`; закреплённая копия `header--fixed` появляется при прокрутке без сдвига
  вёрстки (`prefers-reduced-motion`); на tablet и mobile - бургер вместо `bottom`.
- Компонент `Common/MobileMenu` (`drawMobileMenu()`): мобильное меню `role="dialog"` с ловушкой фокуса, `Esc`,
  блокировкой прокрутки, возвратом фокуса и подменю; слот `geo`.
- Компонент `Common/Banner` (`drawBanner()`): баннер-слайдер первого экрана по `Promo/Page/main` - слайды (картинка,
  заголовок, описание, кнопка), стрелки, `StepIndicator`; `script.js` без библиотек: свайп, клавиши, автопрокрутка с паузой
  (наведение, фокус, `prefers-reduced-motion`), `aria-disabled` на крайних стрелках, один слайд - без стрелок и шагов.
- Компонент `Common/Benefit` (`drawBenefit()`, `drawBenefitList()`): преимущество по `Base/benefit` - размеры `s|m|l`,
  `type` (иконка или число), `layout`, `align`, `card`, ссылка, бейдж; разметка `ul/li`.
- Глобальные стили (`Layout/assetsGlobal/styles`) по токенам Figma: переменные `--state-disabled-*`, `--state-clear-*`,
  `--color-text-icon-*`, `--backdrop-fade-*`, оттенки и новые сервисы `--socials-*`, `--delivery-*`, тени
  `--shadow-gray-*` и `--shadow-primary-*`, скругления `--radius-ui-*` и `--radius-blocks` (режим на `:root` через
  `data-radius`), `--font-main`, `--font-mono`; sass-алиасы и миксины `ui-*`, `code`.
- Сверка UI `Components/UI/Core` с Figma (старые css-классы сохранены): `Button` — `iconLeft`/`iconRight`, `load`
  (спиннер вместо содержимого, ширина сохраняется, `aria-busy`), `disabled` (у ссылки `aria-disabled` без `href`),
  `type` не дублируется; `Tab` и `DropdownTab` — стили `filled`/`soft` (названия Figma для `primary`/`secondary`),
  `active` (`aria-current`, `aria-selected`), `disabled`, вкладка только с иконкой, `DropdownTab` — шаблон disclosure
  (`aria-expanded`, `aria-controls`), открытие с клавиатуры, закрытие `Esc`; `Marker` — стили `main|gray|load|success|alert|error`,
  тема, `label` (`role="status"`); `Badge` — счётчик `99+`, бейдж только с иконкой; `Separator` — `decorative`;
  `Checkbox` — размер `l`, `partial` (`data-indeterminate`), `error`, `disabled`, `policyUrl`; у всех кольцо фокуса
  `:focus-visible` и `aria-disabled` как `:disabled`.
- `TextInput`: `kind` (`TextInputKind::Phone` — `type="tel"`, маска `+7 (999) 123-45-67`, счётчик цифр `0/11`, в форму
  уходят цифры; `Email` — проверка при потере фокуса), `error` (`aria-invalid`, `aria-describedby`), `value`
  (состояние `filled`), `counter` и `maxLength`, `disabled`, автоматический `id`.
- `AQ::groupBy()`, `having()`, `unionAll()`, `union()` — группировка и объединение запросов построителем;
  `AQ::insertInto($table, $columns)` — `INSERT INTO ... SELECT` выборкой построителя.
- `FieldVirtualTable::$query` — запрос `AQ`: количество строк считается по нему же.
- `System\Paths` и `System\Location` — пути на диске и окружение (`Container::getPaths()`, `getLocation()`).
- `Request::create()` — запрос из данных (тесты, внутренние запросы); `Request::server()`, `getUri()`, `getIp()`,
  `getUserAgent()`.
- `ModelBase::upsert($data, $update)` — `INSERT ... ON DUPLICATE KEY UPDATE` одним запросом (переключатель привилегий).
- `DB::insert($table, $rows)` — вставка строк в таблицу без модели одним запросом (пара к `DB::delete()`),
  `DB::hasTable()`; `ModelBase::bulkUpdate()` принимает выражения `Expr` (`NOW()` и т.п.).
- Модели `Models\SmsLog`, `SmsDriver`, `AdminWidget`, `UserPrivilege`: `Sms`, виджеты админки и переключатель
  привилегий работают через ORM.
- **Разделы админки в коде.** `\Simflex\Core\Admin\Handler` — раздел (`content()`), `\Simflex\Core\Admin\Table\Table` —
  табличный раздел. Таблица объявляется в самом классе: `protected static string $model` (обязательно),
  `getFields()`, `getParams()`, `$defaultOrderBy`, `$defaultOrderDesc`, `$privilegeAdd/Edit/Delete`, `$perPage`;
  поведение — методы того же класса. Реестр разделов — `Admin/handlers.php` ядра и приложения.
- `FieldDefinition` с параметрами поля именованными аргументами, `ParamDefinition`, `ParamGroup`;
  пресеты полей `IdField`, `ActiveField`, `NppField`, `ParentField`, `ForeignKeyField`.
- Разделы без таблицы: «Привилегии» (список и переключатель), «Аккаунт», страница группы меню с виджетами
  (`Handlers\Group`).
- Разделы «Привилегии ролей» и «Персональные привилегии» (только для разработчика).
- **Расширения объявляют свои сущности:** `ExtensionConfig` — компоненты (`$components`), модули (`$modules`),
  разделы админки (`$adminHandlers`), задачи cron (`getCronJobs()`), привилегии (`getPrivileges()`), пункты меню админки
  (`getAdminMenu()`); `ExtensionConfig::getAll()` — загруженные расширения в порядке `loadOrder`. Ядро объединяет их
  с объявлениями сайта, сайт главнее: его наследник заменяет класс расширения, задача с тем же ключом — задачу.
- Маршруты, сервисы, события и консольные команды расширений (`$routes`, `$services`, `$events`, `$commands`
  `ExtensionConfig`) подключаются: `ConfigBase::getRoutes()`, `getServices()`, `getEvents()`, `getCommands()`
  объединяют их с `provider/*.php` сайта; маршрут, команда и сервис сайта с тем же именем главнее, слушатели
  одного события складываются. Конфиг сайта больше не собирает их сам (в шаблоне убраны `loadExtensions()`,
  `loadFiles()` и кэш `cache/*.php`, установщик пакетов кэш не чистит).
- Установщик пакетов копирует миграции пакета в сайт следующими свободными номерами сайта и не дублирует уже
  скопированные (`PackageInstaller::copyMigrations()`).
- `Menu::add(..., parent:, before:)`, `remove()`, `setHandler()` — свой обработчик пункта меню ядра;
  `AdminModules` с привязкой модулей к разделам (`sections`).
- `\Simflex\Core\System\CodeRegistry` — общий базовый класс реестров в коде (`Privilege`, `Menu`, `AdminModules`).
- Поля выбора из реестров (привилегия, компонент, модуль, задача cron, шаблон страницы) — выпадающий список с поиском,
  как у внешнего ключа.
- `\Simflex\Core\Http\View` — вывод шаблона в строку; HTML полей админки вынесен в `Admin/Fields/tpl/*.tpl`.
- `\Simflex\Core\Http\Assets` — публикация статики ядра; `asset()` добавляет к адресу версию файла (`?v=mtime`).
- `env()`, `asset()`, `getSimflexVersion()` — в `src/functions.php` ядра (composer `autoload.files`).
- ORM: `AQ::fetchColumn()`, `AQ::getBinds()`, псевдоним таблицы в `join()`/`leftJoin()` (`alias:`),
  `ModelSettings::values()`, модели `Log`, `Seo`, `UserPrivilegePersonal`.
- Миграции: `$s->seed()` для начальных данных; `./sf migrate/create` нумерует миграции по порядку.
- `./sf layout/generate` печатает код полей компонентов страницы для `provider/templates.php`.
- Транслитерация алиасов по-русски (`я` → `ya`, `ж` → `zh`).
- `AGENTS.md` — правила работы с кодом ядра для агентов (комментарии на русском, геттеры с `get`, и др.).
- `ide-stubs.php` — подсказки IDE.
- `FieldDefinition` — аргумент `params`: параметры типа поля (`struct` у `FieldTable`, таблицы `FieldMultiKey`
  и `FieldRelation`, формат `FieldDouble`, `subquery` у `FieldVirtual`), попадают в `params['main']` поля.
- Пресеты полей `MultiKeyField` (связи «многие ко многим», `relationKey`, `parentKey`) и `PriceField` (цена
  с разделителем разрядов).
- `Table::$uploadDir`, `$uploadImageExtensions`, `$uploadFileExtensions` — каталог и белый список загрузки файлов
  полей-таблиц; `FieldVirtualTable::$binds` — параметры запросов строк; `FieldMultiKey::getValues()` (с поиском
  и лимитом), `getRelationKey()`.
- `DB::delete()` — удаление строк таблицы без модели (таблицы связей, кэши) по условию `Where`, пустое условие —
  исключение.
- **Форма «Связаться с нами» и окно (UI 4.0, `Layout/Components/Common`).**
  - `Common/Modal` (`Layout::drawModal()`, `ModalSize`, `ModalTheme`): окно `role="dialog"` с `aria-modal`, ловушкой
    фокуса, `Esc`, закрытием по подложке и кнопке, блокировкой прокрутки, `inert` для фона и возвратом фокуса.
    Открывается кнопкой с `data-modal="<id>"` или `window.SimflexModal.open(id)`; на tablet и mobile — шторка снизу.
  - `Common/Form/Callback` (`Layout::drawCallback()`, `CallbackLayout` `grid|stack`, `CallbackState`
    `default|error|sending`, `CallbackTheme`): поля имени, телефона, почты, комментария (счётчик 0/300), согласие
    и кнопка; клиентская проверка, фокус на первое поле с ошибкой, `aria-invalid`; отправка `fetch` на `action`
    (по умолчанию `/form/callback`), ответ `{success, errors, message}`, результат встаёт на место формы.
  - `Common/Form/Result` (`Layout::drawResult()`, `ResultStyle` `success|error`, `ResultType`
    `horizontal|vertical`): маркер, заголовок, текст, кнопка; `role="status"` / `role="alert"`.
  - `Extensions\Form\FormGuard`: защита формы от ботов без внешних сервисов (поле-ловушка и подписанный токен
    с временем показа формы).

### Изменено

- Сверка главной с Figma (`pf/ph/pt/pm-index`): база mobile-размеров `vwm()` — 414 (ширина макета `pm-*`), было 375;
  шапка `bottom` 52 (пункты 40, отступ снизу 8), контакты шапки — `Contact` `filled` размера `xs` (`xs` теперь bold);
  `HeaderBanner`: текст слева, белая кнопка справа, на tablet и mobile кнопки нет; `Banner`: шаги высотой 16, текст
  `700/700/480/302`, описание на tablet и mobile 16, стрелки 48 × 48 и без них на tablet и mobile; `Callback`:
  комментарий на 2 строки (поле 96); `Modal`: кнопка закрытия 48 × 48, шапка шторки на tablet и mobile (кнопка
  в шапке 66 с линией); `MobileMenu`: шапка и линия с отступом 8, кнопка закрытия 48, контакты по центру;
  `Footer`: зазор `contact-us` на tablet и mobile 32.

- `Badge`: цвета `primary`, `secondary`, `accent`, `gray`, `gradient-light` и капсульный радиус `xs`, `s` приведены к Figma; `Tab`,
  `DropdownTab` размер `xs` — высота 32, иконки 24; `Marker` размер `l` — радиус 12; состояние `loading` у `Button`
  сохраняет ширину (`visibility` вместо `display: none`); `Marker` по умолчанию рисует иконку `check` (было `true`).
- `--bg-gradient` и `--uniq-red` приведены к Figma; миксин `hero`: 200px (на tablet и mobile 120px) вместо 340px и 200px.
- `Str::sizeToStr()` — размер с пробелом («12 кб»), для отсутствующего файла — «0 б»; поля `FieldFile`,
  `FieldImage` показывают размер через него.
- Запросы к базе в ядре — через модели и `AQ` (страница сайта, меню, SEO, модули, виджеты и вход в админку,
  поля-связи, привилегии пользователя, `Sms`, списки страниц `Content`); прямой SQL остался только в слое ORM
  (`DB`, `AQ`, `Where`, `ModelBase`, `Schema`).
- `ConsoleBase::toBackground()` запускает команду через `sf` сайта.
- Список раздела, количество и карточка записи собираются через `AQ`: значения фильтров передаются параметрами
  запроса, внешние ключи присоединяются `JOIN` с псевдонимом, ограничения по привилегиям — `Table::getScope()`.
- Запись раздела сохраняется через модель (`insert()`, `update()`, `bulkUpdate()`): срабатывают хуки
  и события модели; простые действия списка (переключатель, порядок, копирование, удаление) — тоже через модель.
- Сортировка и страницы списка: `changeSorting()`, `getSortColumn()`, `isSortDesc()` поверх сессии, `Pagination`.
- Настройки сайта читаются через модель (`ModelSettings::values()`).
- Правая колонка формы группирует поля без группы по `group_name`, как левая; подсказка поля (`help`)
  показывается и в шапке списка.
- Значения по умолчанию «Показывать заголовок» и «Выводить обёртку» модуля в форме — как у модуля (выключено).
- Тема админки очищена от неиспользуемых библиотек (старая тема conquer, дубль TinyMCE, jstree, остатки TinyMCE 3,
  шрифты FontAwesome/Simple-Line-Icons), `theme/new` выпрямлена в `theme/{css,js,img}`.
- Комментарии в коде — на русском.
- `FieldMultiKey`, `FieldRelation`, поиск для фильтров (`Table::searchMultiKey()`, `searchInt()`) и фильтр списка
  по `FieldMultiKey` — запросы через `AQ`, значения параметрами, имена — `DB::wrapName()`.
- Форма выводит пустую (NULL) колонку и поле без колонки пустой строкой (`Table::formFieldInput()`, шаблоны полей).
- `FieldDouble` без параметров формата выводит значение с точкой и пробелами между разрядами в списке.
- Стили компонентов `Layout/Components`: размеры и отступы через `spacing`/`vw*()`, границы через `border-w`, радиусы
  через токены `--radius-*` или `border-r`, переходы через `transition` (правила — `styles-rules.md` в `simflex-agents`).

### Удалено

- Раздел «Меню» админки, разделы «Структура», «Компоненты», «Модули» (справочник), «Шаблоны страниц»
  и их параметры — всё это теперь в коде.
- `FieldTypeSelect`, `FieldTableSelect`, `typeLabel()`/`typeParams()` полей, `TableDefinition`, `FieldParams`.
- Старая вёрстка админки: `Admin/theme/css/styles.css`, `theme/js/app.js`, `theme/js/extra.js`, отдельные иконки
  `theme/img/icons/*` и `svg-defs.svg`, `theme/img/logo.svg`, `user.jpg`; jQuery (CDN `cdn.sn9.ru`), simplebar,
  `window.sfAdminUrl`. Классы старой вёрстки (`Btn*`, `form-control*`, `table__body-item-*`, `modal-point`,
  `row-tip`, `list1`) больше не стилизуются: шаблоны и скрипты расширений переводятся на компоненты Layout
  (`Button`, `TextInput`, `Dropdown`, `Common/Modal`, `Tooltip`) и `window.sfAdmin` (`request`, `confirm`, `toast`).

### Исправлено

- Список админки с JOIN: после сохранения (`?save_id=`) запрос падал с «Column … in order clause is ambiguous» —
  `Table::getListOrder()` теперь указывает колонку сортировки с именем таблицы (вычисляемые поля — по псевдониму).
- В режиме разработчика исключение консольной команды (`./sf`) не выводилось: Whoops в консоли печатает его текстом
  (`PlainTextHandler`), а не страницей.
- Выпадающий список полей админки (`Field::dropdown()`: `FieldEnum` и др.) показывал «—» вместо выбранного значения,
  пока не отработает скрипт админки: подпись выбранного пункта выводится сразу в разметке.
- `Response::redirectNow()` не отправлял заголовки (ответ 200 без `Location`), а `redirect()` не ставил код 302 —
  редирект не срабатывал.
- `Content::getChildren()` возвращал каждую страницу дважды; поиск по параметрам (`?search[]=`) и порядковый номер
  новой записи (`FieldNPP` с фильтрами раздела) подставляли значения в SQL — теперь параметрами запроса.
- Поля `FieldDate`, `FieldDateTime`, `FieldAlias` экранировали значение, которое затем ещё раз передавалось
  параметром: кавычка сохранялась с обратной косой чертой.
- Description и keywords страницы не выводились: тема читала `Page::$override` (всегда пустой), а заголовок из
  блока «Мета» страницы (`meta_title`) не применялся.
- Ajax-запрос модуля (`sf_module_id`) не возвращал HTML модуля.
- Маршрут по меню сайта: базовым путём компонента считался весь путь запроса, а не ссылка пункта меню; путь
  без пункта с компонентом падал с `TypeError` вместо маршрута по умолчанию.
- `Mail::setBodyFromTemplate()`: текстовая версия письма не очищалась от тегов (регулярные выражения без
  разделителей).
- Транспорт `PhpMailer`: порт из конфига `mail.port` не применялся; без `mail.username` отправка шла с авторизацией
  и пустым отправителем.
- `ActionMatcher`: действия контроллера с HTTP-методом (`#[Action('/x', 'post')]`) не срабатывали (метод запроса
  в верхнем регистре); у контроллера на маршруте `/` путь действия терял первый символ; переменные пути
  неудачного сопоставления оставались в следующем.
- Загрузка файлов админки: `upload_file` принимала любые файлы (в том числе `.php`), `upload_img` брала путь
  из запроса без проверки, обе — без проверки прав. Теперь нужно право добавлять или менять записи раздела,
  путь — без `..`, расширения `upload_file` — белый список раздела; `File::loadPost()` не сохраняет исполняемые
  файлы (`File::FORBIDDEN_EXTENSIONS`).
- Пустой экран при ошибке сохранения формы.
- Окно «Информация» строки показывало главную страницу; кнопки строки показывались без прав.
- Выпадающий список с поиском не сбрасывал введённый текст без выбора — форма не сохранялась без ошибки.
- Сохранение формы модуля без изменений добавляло заголовок и обёртку и ломало хлебные крошки админки.
- Сохранение модуля до загрузки его полей по ajax падало на отсутствующем поле.
- Раздел «Роли» у не-разработчика падал на подзапросе к `user_role`.
- Мобильная кнопка «Удалить» строки открывала форму вместо удаления.
- Копирование записи вставляло значения в SQL без экранирования; кавычка в фильтре списка ломала запрос.
- `AQ`: параметры дополнительных условий `ON` у `JOIN` не передавались в запрос.
- `FieldMultiKey` падал в форме новой записи; подписи связей в списке брались из общего на все поля буфера —
  второе поле раздела показывало связи первого.
- `FieldRelation`: пары связей новой записи записывались дважды, форма падала без id записи в запросе, при
  сохранении удалялись пары только в одном направлении.
- `FieldVirtualTable`: сортировка изображений `img_json` булевым компаратором, неверное значение по умолчанию.
- Шаблоны полей `input`, `textarea`, `input-hidden`, `color` и `FieldTable` падали на NULL.
- Загрузка файлов в разделе «Страницы» принимала любой файл (в том числе `.php`) с исходным именем и без проверки
  прав.

### Переход с 3.6

1. PHP 8.4, расширение `mbstring`; корень веб-сервера — `public/`.
2. Описания таблиц из `struct_*` — в классы разделов `App\Admin\Handlers\*` (`extends \Simflex\Core\Admin\Table\Table`,
   `$model`, `getFields()`), классы — в `Admin/handlers.php` сайта.
3. Пункты `admin_menu` — в `App\Admin\Menu` (`static::add(new MenuItem(...))`), конфиг `adminMenuClass`.
4. Компоненты и модули — в `provider/components.php` и `provider/modules.php`; параметры модулей — `adminParams()`.
5. Привилегии проекта — в наследнике `\Simflex\Core\System\Privilege` (конфиг `privilegeClass`); в ролях и меню —
   имя привилегии вместо id.
6. Шаблоны страниц — в `provider/templates.php`, задачи cron — в `provider/cron.php`.
7. Начальные данные сидеров — в `$s->seed()` миграций.
8. Вывод компонентов, модулей и полей — `return $this->render(...)` вместо `echo`/`include`.
9. Имена классов ядра — `Simflex\Core\…` по таблице «Namespace ядра»; точки входа — `new Kernel(<корень>)->runHttp()`
   и `->runConsole()`, без `constants.php`; `SF_*` — `Container::getPaths()`, `Container::getLocation()`.
10. Тема: `Page::meta()`, `content()`, `metaJS()` → `$page->getMeta()`, `getContent()`, `getMetaJs()`.
11. `$_GET`, `$_POST`, `$_REQUEST`, `$_SERVER`, `$_FILES` → `Request` (`Container::getRequest()`, в разделах админки —
    `$this->request`), `$_SESSION` → `System\Session`; прямой SQL — модели и `AQ`.

Подробнее — документация (`simflex-docs`): «Как устроен сайт», «Создание таблиц», «Навигация», «Привилегии»,
«Модели и запросы (ORM)», «Новый раздел в админке», «Подмена обработчика раздела ядра».
