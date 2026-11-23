/**
 * Визуальный редактор полей админки — texted (window.Ted, пакет simflex/texted; стили и скрипт подключает
 * Plugins\Editor\Editor::addScript()).
 *
 * Компонент data-sf="text-editor": textarea поля превращается в редактор с настройками из data-sf-text-editor
 * (набор блоков, право на правку, адрес папки файлов — Editor::getInitOptions()). Редактор сам пишет HTML обратно
 * в textarea, форма отправляется как обычно; «Сохранить» и Ctrl+S редактора — как «Применить» формы.
 * Изображения, видео, аудио и файлы выбираются в файловом менеджере админки (window.fileManager).
 * Поле-таблица (theme/js/table-editor.js) и параметры модуля (Table/js/moduleitem.js) запускают и удаляют
 * редакторы через initTextEditor(), syncTextEditors() и destroyTextEditors().
 */
import {register} from '../../theme/js/admin.js';

const FILE_MANAGER_ID = 'sf-file-manager';

/**
 * Выбор файлов в файловом менеджере для блоков медиа: [{url, alt, name}] по «Готово», null — окно закрыли
 * без выбора. Файлы не того вида (pdf в «Изображение») редактор отбрасывает сам
 * @param {{multiple?: boolean}} options
 * @returns {Promise<Array<{url: string, alt: string, name: string}>|null>}
 */
export function pickFile({multiple = false} = {}) {
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
        // менеджер закрывает окно до вызова onSelect: отмену засчитываем, если выбор не пришёл следом
        document.getElementById(FILE_MANAGER_ID)?.addEventListener(
            'modal:close',
            () => setTimeout(() => finish(null)),
            {once: true},
        );
        window.fileManager.open({
            multiple,
            onSelect: (files) => finish(files.map((file) => ({url: file.url, alt: '', name: file.name}))),
        });
    });
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
    const [editor] = window.Ted.init({
        theme: 'auto',
        // в админке нет режима просмотра: в панели редактора «Сохранить»
        previewMode: false,
        mediaSource: 'manager',
        pickFile,
        ...options,
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
