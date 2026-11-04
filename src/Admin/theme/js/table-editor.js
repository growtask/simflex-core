/**
 * Таблица строк в форме (edit-table, Fields/tpl/table.tpl): поля FieldTable и FieldVirtualTable.
 *
 * Значение — JSON {s: колонки, v: строки}. Строки рисуются из него, «Добавить строку» и «Редактировать» открывают окно
 * строки (Modal) с полем на каждую колонку: [data-sf-column] — значение колонки. FieldTable хранит строки в скрытом
 * поле формы; FieldVirtualTable (data-sf-table-mode="virtual") сразу сохраняет их действиями раздела vtAdd, vtEdit,
 * vtDelete и загружает страницу строк vtGet. Файлы колонок image и file загружает upload_table_file или выбирает
 * файловый менеджер («Из библиотеки»).
 * Окно при открытии переносится в body, поэтому его элементы ищутся через окно, а не через корень таблицы.
 */
import {confirm, register, request, toast} from './admin.js';

const NO_EDIT = '__NO_EDIT__';

/** Сегодня в формате дд.мм.гггг (значение по умолчанию $DATE$) */
const today = () => {
    const date = new Date();
    const pad = (number) => String(number).padStart(2, '0');
    return `${pad(date.getDate())}.${pad(date.getMonth() + 1)}.${date.getFullYear()}`;
};

/** Текст без разметки: значение редактора в ячейке */
const toText = (html) => new DOMParser().parseFromString(String(html ?? ''), 'text/html').body.textContent.trim();

/** Варианты combo из «k=v,,k=v» */
const getOptions = (column) => Object.fromEntries(String(column.e ?? '').split(',,').map((option) => {
    const [key, ...text] = option.split('=');
    return [key, text.join('=')];
}));

const isType = (column, type) => String(column.t ?? '').startsWith(type);

/** Выбирает значение в Dropdown без открытия списка; label — подпись, если варианта нет в списке */
const setDropdown = (dropdown, value, label = null) => {
    const valueElement = dropdown.querySelector('.dropdown__value');
    valueElement.dataset.sfPlaceholder ??= valueElement.classList.contains('dropdown__value_placeholder')
        ? valueElement.textContent : '';
    let text = label;
    dropdown.querySelectorAll('.dropdown__option').forEach((option) => {
        const isSelected = value !== '' && option.dataset.value === String(value);
        option.classList.toggle('active', isSelected);
        option.setAttribute('aria-selected', String(isSelected));
        if (isSelected && !text) {
            text = option.textContent.trim();
        }
    });
    dropdown.querySelector('input[type="hidden"]').value = value;
    valueElement.textContent = text || valueElement.dataset.sfPlaceholder;
    valueElement.classList.toggle('dropdown__value_placeholder', !text);
};

/** Поле файла окна: значение, превью картинки, ссылка на файл */
const setFile = (widget, value) => {
    widget.querySelector('[data-sf-column]').value = value;
    const preview = widget.querySelector('.edit-table-file__preview');
    const link = widget.querySelector('.edit-table-file__name');
    if (preview) {
        preview.hidden = value === '';
        preview.src = value;
    }
    link.hidden = value === '' || Boolean(preview);
    link.href = value;
    link.textContent = value.split('/').pop();
};

register('table-editor', (root) => {
    const input = root.querySelector('[data-sf-table-value]');
    const rowsElement = root.querySelector('[data-sf-table-rows]');
    const actionsTemplate = root.querySelector('template[data-sf-table-actions]');
    const modal = document.getElementById(root.dataset.sfTableModal);
    const isVirtual = root.dataset.sfTableMode === 'virtual';
    const editorConfig = root.dataset.sfTableEditorConfig ? JSON.parse(root.dataset.sfTableEditorConfig) : null;

    let data = JSON.parse(input.value || '{}');
    data.s ??= [];
    data.v ??= [];
    let page = 0;
    let total = Number(root.dataset.sfTableTotal ?? data.v.length);
    // строк на странице FieldVirtualTable — по первой странице
    const perPage = Math.max(data.v.length, 1);
    // редактируемая строка: индекс (FieldTable) или __id (FieldVirtualTable); null — новая
    let editing = null;

    const shownColumns = data.s.filter((column) => column.l);
    const editableColumns = shownColumns.filter((column) => column.v !== NO_EDIT);

    /** Адрес действия раздела: у FieldVirtualTable — с записью формы */
    const actionUrl = (action, params = {}) => {
        const query = new URLSearchParams({action, ...params}).toString();
        return isVirtual ? `${root.dataset.sfTableUrl}?${query}&${root.dataset.sfTablePk}` : `?${query}`;
    };

    const getRow = (key) => (isVirtual
        ? data.v.find((row) => String(row.__id) === String(key))
        : data.v[Number(key)]) ?? null;

    const drawCell = (column, row) => {
        const cell = document.createElement('td');
        cell.className = 'td';
        cell.dataset.label = toText(column.l);
        const value = String(row[column.n] ?? '');
        if (isType(column, 'image')) {
            if (value !== '') {
                const image = document.createElement('img');
                image.className = 'edit-table__image';
                image.src = value;
                image.alt = '';
                cell.append(image);
            }
        } else if (isType(column, 'file')) {
            if (value !== '') {
                const link = document.createElement('a');
                link.href = value;
                link.target = '_blank';
                link.rel = 'noopener';
                link.textContent = value.split('/').pop();
                cell.append(link);
            }
        } else if (isType(column, 'combo') && !String(column.e ?? '').startsWith('AJAX:')) {
            cell.textContent = getOptions(column)[value] ?? value;
        } else {
            cell.textContent = toText(value);
        }
        return cell;
    };

    const renderPages = () => {
        const footer = root.querySelector('[data-sf-table-pages]');
        const pages = Math.ceil(total / perPage);
        footer.hidden = pages <= 1;
        const from = page * perPage + 1;
        root.querySelector('[data-sf-table-info]').textContent =
            `Показано ${from}–${from + data.v.length - 1} из ${total}`;
        footer.querySelector('[data-sf-table-page="-1"]').disabled = page === 0;
        footer.querySelector('[data-sf-table-page="1"]').disabled = page >= pages - 1;
    };

    const render = () => {
        rowsElement.replaceChildren(...data.v.map((row, index) => {
            const tr = document.createElement('tr');
            tr.className = 'tr';
            // убранная строка (например, товар заказа) приглушена
            tr.classList.toggle('tr_muted', String(row.__deleted ?? '0') === '1');
            tr.dataset.sfTableRow = isVirtual ? String(row.__id) : String(index);
            shownColumns.forEach((column, columnIndex) => {
                const cell = drawCell(column, row);
                // первая колонка — заголовок карточки на планшете и телефоне
                cell.classList.toggle('td_main', columnIndex === 0);
                tr.append(cell);
            });
            const controls = document.createElement('td');
            controls.className = 'td td_controls';
            controls.append(actionsTemplate.content.cloneNode(true));
            tr.append(controls);
            return tr;
        }));
        root.querySelector('[data-sf-table-empty]').hidden = data.v.length > 0;
        root.querySelector('.edit-table__wrap').hidden = data.v.length === 0;
        if (isVirtual) {
            renderPages();
        } else {
            input.value = JSON.stringify(data);
        }
    };

    const load = async (nextPage) => {
        const response = await request(actionUrl('vtGet', {page: nextPage}));
        page = nextPage;
        total = Number(response.total ?? 0);
        data = typeof response.v === 'string' ? JSON.parse(response.v) : response.v;
        // последняя строка страницы удалена — предыдущая страница
        if (!data.v.length && page > 0) {
            await load(page - 1);
            return;
        }
        render();
    };

    const getControl = (column) => modal.querySelector(`[data-sf-column="${CSS.escape(column.n)}"]`);

    const fillControl = async (column, value, row) => {
        const control = getControl(column);
        const dropdown = control.closest('[data-sf-dropdown]');
        const file = control.closest('[data-sf-table-file]');
        if (dropdown && control.dataset.sfTableSearch) {
            // вариант ищется на сервере: выбранный — по id связанной записи (__rm_id), подпись — значение ячейки
            const relatedId = row?.__rm_id ?? '';
            const items = relatedId !== '' ? await request(`${control.dataset.sfTableSearch}&id=${relatedId}`) : [];
            setDropdown(dropdown, items[0]?.id ?? '', items[0]?.name ?? (row ? value : null));
        } else if (dropdown) {
            setDropdown(dropdown, value);
        } else if (file) {
            setFile(file, value);
        } else {
            control.value = value;
        }
    };

    const openRow = async (key) => {
        editing = key;
        const row = key === null ? null : getRow(key);
        for (const column of editableColumns) {
            let value = String(row ? (row[column.n] ?? '') : (column.v ?? ''));
            if (value === '$DATE$') {
                value = today();
            }
            await fillControl(column, value, row);
        }
        window.SimflexModal.open(modal.id);
    };

    const getValues = () => {
        window.tinymce?.triggerSave();
        return Object.fromEntries(editableColumns.map((column) => [column.n, getControl(column).value]));
    };

    const saveRow = async () => {
        const values = getValues();
        if (isVirtual) {
            const formData = new FormData();
            Object.entries(values).forEach(([name, value]) => formData.append(name, value));
            const params = {};
            if (editing !== null) {
                formData.append('id', editing);
                params.id = editing;
            }
            const response = await request(actionUrl(editing === null ? 'vtAdd' : 'vtEdit', params),
                {method: 'POST', data: formData});
            if (response?.success === false) {
                toast('Не удалось сохранить строку', {type: 'error'});
                return;
            }
            window.SimflexModal.close(modal.id);
            await load(editing === null ? Math.max(0, Math.ceil((total + 1) / perPage) - 1) : page);
            return;
        }
        if (editing === null) {
            // колонки без поля в окне — значения по умолчанию
            const row = Object.fromEntries(data.s.map((column) => [column.n, column.v === NO_EDIT ? '' : column.v]));
            data.v.push({...row, ...values});
        } else {
            data.v[Number(editing)] = {...data.v[Number(editing)], ...values};
        }
        render();
        window.SimflexModal.close(modal.id);
    };

    const deleteRow = async (key) => {
        const isConfirmed = await confirm('Строка будет удалена.', {
            title: 'Удалить строку?',
            confirmText: 'Удалить',
            danger: true,
        });
        if (!isConfirmed) {
            return;
        }
        if (isVirtual) {
            const response = await request(actionUrl('vtDelete', {id: key}));
            if (response?.success === false) {
                toast('Не удалось удалить строку', {type: 'error'});
            }
            await load(page);
            return;
        }
        data.v.splice(Number(key), 1);
        render();
    };

    const upload = async (widget, file) => {
        const formData = new FormData();
        formData.append('file', file);
        try {
            const url = String(await request(actionUrl('upload_table_file'), {method: 'POST', data: formData})).trim();
            if (url === '') {
                throw new Error('empty');
            }
            setFile(widget, url);
        } catch {
            toast('Файл не принят', {type: 'error'});
        }
    };

    root.addEventListener('click', (event) => {
        const rowKey = event.target.closest('[data-sf-table-row]')?.dataset.sfTableRow;
        const pageButton = event.target.closest('[data-sf-table-page]');
        if (event.target.closest('[data-sf-table-add]')) {
            openRow(null);
        } else if (event.target.closest('[data-sf-table-edit]')) {
            openRow(rowKey);
        } else if (event.target.closest('[data-sf-table-delete]')) {
            deleteRow(rowKey);
        } else if (pageButton) {
            load(page + Number(pageButton.dataset.sfTablePage));
        }
    });

    modal.addEventListener('click', (event) => {
        const widget = event.target.closest('[data-sf-table-file]');
        if (event.target.closest('[data-sf-table-save]')) {
            saveRow();
        } else if (widget && event.target.closest('[data-sf-table-upload]')) {
            widget.querySelector('input[type="file"]').click();
        } else if (widget && event.target.closest('[data-sf-table-library]')) {
            // окно менеджера — поверх окна строки (стопка окон Common/Modal)
            window.fileManager?.open({onSelect: (files) => setFile(widget, files[0].url)});
        } else if (widget && event.target.closest('[data-sf-table-clear]')) {
            setFile(widget, '');
        }
    });
    modal.addEventListener('change', (event) => {
        const widget = event.target.matches('input[type="file"]') && event.target.closest('[data-sf-table-file]');
        if (widget && event.target.files[0]) {
            upload(widget, event.target.files[0]);
            event.target.value = '';
        }
    });

    // редактор запускается в открытом окне (окно переносится в body, перенос iframe сбрасывает редактор)
    modal.addEventListener('modal:open', () => {
        modal.querySelectorAll('[data-sf-table-editor]').forEach((textarea, index) => {
            textarea.id ||= `${modal.id}-editor-${index}`;
            window.tinymce?.init({...editorConfig, target: textarea, height: 320});
        });
    });
    modal.addEventListener('modal:close', () => {
        modal.querySelectorAll('[data-sf-table-editor]').forEach((textarea) => window.tinymce?.get(textarea.id)?.remove());
    });

    render();
});
