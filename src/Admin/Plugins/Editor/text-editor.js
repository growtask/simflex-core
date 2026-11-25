/**
 * Визуальный редактор полей админки — texted (window.Ted, пакет simflex/texted; стили и скрипт подключает
 * Plugins\Editor\Editor::addScript()).
 *
 * Компонент data-sf="text-editor": textarea поля превращается в редактор с настройками из data-sf-text-editor
 * (набор блоков, право на правку, адрес папки файлов — Editor::getInitOptions()). Редактор сам пишет HTML обратно
 * в textarea, форма отправляется как обычно; «Сохранить» и Ctrl+S редактора — как «Применить» формы.
 * Изображения, видео, аудио и файлы загружаются с компьютера (Editor::respondToUpload()) или выбираются
 * в файловом менеджере админки (window.fileManager) — ссылка «Из библиотеки» в зоне загрузки.
 * Поле-таблица (theme/js/table-editor.js) и параметры модуля (Table/js/moduleitem.js) запускают и удаляют
 * редакторы через initTextEditor(), syncTextEditors() и destroyTextEditors().
 */
import {getCsrfToken, register} from '../../theme/js/admin.js';

const FILE_MANAGER_ID = 'sf-file-manager';

/**
 * Выбор файлов в файловом менеджере для блоков медиа: [{url, alt, name}] по «Готово», null — окно закрыли
 * без выбора. Менеджер показывает к выбору только файлы вида блока (extensions редактора → accept);
 * файлы не того вида редактор и так отбрасывает сам
 * @param {{multiple?: boolean, extensions?: string[]|null}} options
 * @returns {Promise<Array<{url: string, alt: string, name: string}>|null>}
 */
export function pickFile({multiple = false, extensions = null} = {}) {
    return new Promise((resolve) => {
        if (!window.fileManager) {
            resolve(null);
            return;
        }
        let isDone = false;
        const finish = (files) => {
            if (!isDone) {
                isDone = true;
                resolve(files);
            }
        };
        // ответ — ровно один: onSelect по «Готово» или onCancel при закрытии без выбора
        const opened = window.fileManager.open({
            multiple,
            select: true,
            accept: extensions?.length ? extensions : undefined,
            onSelect: (files) => finish(files.map((file) => ({url: file.url, alt: '', name: file.name}))),
            onCancel: () => finish(null),
        });
        if (!(opened instanceof Promise)) {
            // прежний менеджер (без onCancel и Promise) закрывает окно до вызова onSelect:
            // отмену засчитываем, если выбор не пришёл следом
            document.getElementById(FILE_MANAGER_ID)?.addEventListener(
                'modal:close',
                () => setTimeout(() => finish(null)),
                {once: true},
            );
        }
    });
}

/**
 * Откуда берутся файлы блоков медиа. С адресом загрузки (Editor::getInitOptions() → uploadUrl) — загрузка
 * с компьютера на сервер с CSRF-токеном страницы, а при файловом менеджере на странице ещё и ссылка «Из библиотеки»
 * в зоне загрузки. Без адреса (только просмотр) — только файловый менеджер
 * @param {string|undefined} uploadUrl
 * @returns {object} mediaSource, upload, pickFile для Ted.init
 */
function getMediaOptions(uploadUrl) {
    // менеджер на странице — по его окну: модуль file-manager.js может выполниться позже этого модуля
    const library = window.fileManager || document.getElementById(FILE_MANAGER_ID) ? {pickFile} : {};
    if (!uploadUrl) {
        return {mediaSource: 'manager', pickFile};
    }

    return {
        mediaSource: 'direct',
        upload: window.Ted.createUpload(uploadUrl, {headers: {'X-CSRF-Token': getCsrfToken()}}),
        ...library,
    };
}

/**
 * Запускает редактор на textarea
 * @param {HTMLTextAreaElement} textarea
 * @param {object} options Настройки Ted.init (Editor::getInitOptions() и свои)
 * @returns {object|null} Редактор или null, если скрипт texted не подключён
 */
export function initTextEditor(textarea, options = {}) {
    if (!window.Ted) {
        return null;
    }
    const {uploadUrl, ...rest} = options;
    const media = getMediaOptions(uploadUrl);
    const [editor] = window.Ted.init({
        theme: 'auto',
        // в админке нет режима просмотра: в панели редактора «Сохранить»
        previewMode: false,
        ...media,
        ...rest,
        target: textarea,
    });

    return editor ?? null;
}

/**
 * Записывает в textarea текущий HTML редакторов внутри root: редактор обновляет поле с задержкой после ввода,
 * форма с submit делает это сама, а значения окна (строка поля-таблицы) читаются скриптом
 * @param {ParentNode} root
 */
export function syncTextEditors(root) {
    root.querySelectorAll('textarea').forEach((textarea) => window.Ted?.get(textarea)?.flush());
}

/**
 * Удаляет редакторы внутри root (перед заменой его содержимого или закрытием окна)
 * @param {ParentNode} root
 */
export function destroyTextEditors(root) {
    root.querySelectorAll('textarea').forEach((textarea) => {
        if (window.Ted?.get(textarea)) {
            window.Ted.destroy(textarea);
        }
    });
}

register('text-editor', (textarea) => {
    const options = textarea.dataset.sfTextEditor ? JSON.parse(textarea.dataset.sfTextEditor) : {};
    initTextEditor(textarea, options);

    // «Сохранить» редактора отправляет форму без кнопки (requestSubmit()) — сохраняем как «Применить»
    const form = textarea.form;
    if (form && !form.dataset.sfTextEditorSubmit) {
        form.dataset.sfTextEditorSubmit = '1';
        form.addEventListener('submit', (event) => {
            if (!event.submitter && !form.querySelector('input[name="submit_apply"][type="hidden"]')) {
                const apply = document.createElement('input');
                apply.type = 'hidden';
                apply.name = 'submit_apply';
                form.append(apply);
            }
        });
    }
});
