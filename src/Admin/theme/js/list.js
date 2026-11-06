/**
 * Список раздела (Table/tpl/show.tpl): выбор строк и «выбрать все», состояние панели действий по числу выбранных,
 * массовые действия (редактирование, копирование, удаление с подтверждением), удаление строки, сведения о записи,
 * переключатели, статусы и порядок в ячейках (сохраняются сразу), меню фильтров колонок, окно фильтров, поиск
 * и теги фильтров
 */
import {confirm, register, request, toast} from './admin.js';

const path = () => window.location.pathname;

/**
 * Адрес списка с фильтрами: значения полей [data-sf-filter] внутри root (меню фильтра колонки, окно фильтров,
 * поиск) и списков фильтров (Dropdown .filter-select); у переключателей radio — выбранный
 */
const filtersUrl = (root) => {
    const params = new URLSearchParams();
    root.querySelectorAll('[data-sf-filter], .filter-select input[type="hidden"]').forEach((input) => {
        if (!input.name || (input.type === 'radio' && !input.checked)) {
            return;
        }
        params.set(input.name, input.value);
    });
    params.set('p', '0');
    return `${path()}?${params}`;
};

// фильтр числа (FieldInt): вводятся только цифры — остальное убирается при вводе и вставке, курсор остаётся на месте
document.addEventListener('input', (event) => {
    const input = event.target;
    if (!input.matches?.('[data-sf-digits]') || /^\d*$/.test(input.value)) {
        return;
    }
    const caret = input.selectionStart ?? input.value.length;
    const digitsBeforeCaret = input.value.slice(0, caret).replace(/\D/g, '').length;
    input.value = input.value.replace(/\D/g, '');
    input.setSelectionRange(digitsBeforeCaret, digitsBeforeCaret);
});

// фильтр «период» у дат: «От» и «До» (ДД.ММ.ГГГГ) собираются в значение фильтра ГГГГ-ММ-ДД|ГГГГ-ММ-ДД
const toIsoDate = (text) => {
    const match = /^(\d{2})\.(\d{2})\.(\d{4})$/.exec(text.trim());
    return match ? `${match[3]}-${match[2]}-${match[1]}` : '';
};
const syncDateRange = (target) => {
    const box = target.closest?.('[data-sf-date-range-box]');
    if (!box) {
        return;
    }
    const [from, to] = ['from', 'to']
        .map((side) => toIsoDate(box.querySelector(`[data-sf-date-range="${side}"]`).value));
    box.querySelector('[data-sf-date-range-value]').value = from || to ? `${from}|${to}` : '';
};
// дата из календаря приходит в поле событиями input и change
document.addEventListener('input', (event) => syncDateRange(event.target));
document.addEventListener('change', (event) => syncDateRange(event.target));

/** Зазор между кнопкой фильтра колонки и меню, отступ меню от края окна */
const MENU_GAP = 12;

/**
 * Меню фильтров колонок (th-filter): открыто одно; кнопка открывает и закрывает, Esc и клик вне — закрывают,
 * прокрутка вне меню — закрывает (меню поверх таблицы стоит на месте экрана). «Применить» и Enter в поле —
 * список с фильтром колонки
 */
const initColumnFilters = (head) => {
    let opened = null;

    const close = (isFocusButton = false) => {
        if (!opened) {
            return;
        }
        const button = opened.querySelector('[data-sf-th-filter-toggle]');
        opened.querySelector('.th-filter__menu').hidden = true;
        button.setAttribute('aria-expanded', 'false');
        if (isFocusButton) {
            button.focus();
        }
        opened = null;
    };

    // у кнопки по левому краю; у правого края окна — внутрь; если снизу нет места — над кнопкой
    const place = (filter) => {
        const menu = filter.querySelector('.th-filter__menu');
        const rect = filter.querySelector('[data-sf-th-filter-toggle]').getBoundingClientRect();
        const left = Math.max(MENU_GAP, Math.min(rect.left, window.innerWidth - menu.offsetWidth - MENU_GAP));
        let top = rect.bottom + MENU_GAP;
        if (top + menu.offsetHeight > window.innerHeight && rect.top - MENU_GAP - menu.offsetHeight > 0) {
            top = rect.top - MENU_GAP - menu.offsetHeight;
        }
        menu.style.left = `${left}px`;
        menu.style.top = `${top}px`;
    };

    const open = (filter) => {
        close();
        const menu = filter.querySelector('.th-filter__menu');
        menu.hidden = false;
        filter.querySelector('[data-sf-th-filter-toggle]').setAttribute('aria-expanded', 'true');
        opened = filter;
        place(filter);
        (menu.querySelector('input:checked, input:not([type="hidden"]), button') ?? menu).focus();
    };

    head.addEventListener('click', (event) => {
        const toggle = event.target.closest('[data-sf-th-filter-toggle]');
        if (toggle) {
            const filter = toggle.closest('[data-sf-th-filter]');
            filter === opened ? close() : open(filter);
            return;
        }
        const apply = event.target.closest('[data-sf-th-filter-apply]');
        if (apply) {
            window.location.href = filtersUrl(apply.closest('.th-filter__menu'));
        }
    });
    head.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && opened) {
            event.preventDefault();
            close(true);
        } else if (event.key === 'Enter'
            && event.target.matches('.th-filter__menu [data-sf-filter], .th-filter__menu [data-sf-date-range]')) {
            event.preventDefault();
            syncDateRange(event.target);
            window.location.href = filtersUrl(event.target.closest('.th-filter__menu'));
        }
    });
    document.addEventListener('click', (event) => {
        // путь события — на момент нажатия: календарь перерисовывает дни, и нажатый день выпадает из DOM раньше
        // этой проверки; панель списка (Dropdown с поиском) может быть вынесена поверх — клик по ней тоже внутри
        const path = event.composedPath();
        if (opened && !path.includes(opened) && !path.some((node) => node.classList?.contains('dropdown__panel'))) {
            close();
        }
    });
    document.addEventListener('scroll', (event) => {
        if (opened && !opened.contains(event.target)) {
            close();
        }
    }, true);
    window.addEventListener('resize', () => close());
};

register('list', (list) => {
    const bar = document.querySelector('[data-sf-table-bar]');
    const selectAll = list.querySelector('[data-sf-select-all]');
    const rowChecks = () => [...list.querySelectorAll('[data-sf-row-select]')];
    const selectedIds = () => rowChecks().filter((check) => check.checked).map((check) => check.value);

    const setDisabled = (button, isDisabled) => {
        if (!button) {
            return;
        }
        button.disabled = isDisabled;
        button.setAttribute('aria-disabled', String(isDisabled));
    };

    // панель действий: «Редактировать» — одна запись (несколько — при групповом редактировании), копирование
    // и удаление — для всех выбранных
    const update = () => {
        const ids = selectedIds();
        const checks = rowChecks();
        rowChecks().forEach((check) => check.closest('tr')?.classList.toggle('tr_selected', check.checked));
        if (selectAll) {
            selectAll.checked = checks.length > 0 && ids.length === checks.length;
            selectAll.indeterminate = ids.length > 0 && ids.length < checks.length;
        }
        if (!bar) {
            return;
        }
        const edit = bar.querySelector('[data-sf-list-action="edit"]');
        setDisabled(edit, ids.length === 0 || (ids.length > 1 && edit?.dataset.sfGroup !== '1'));
        setDisabled(bar.querySelector('[data-sf-list-action="copy"]'), ids.length === 0);
        setDisabled(bar.querySelector('[data-sf-list-action="delete"]'), ids.length === 0);
        bar.querySelectorAll('.action-with-select').forEach((button) => setDisabled(button, ids.length === 0));
        bar.querySelector('[data-sf-selected]').hidden = ids.length === 0;
        bar.querySelector('[data-sf-selected-count]').textContent = String(ids.length);
        bar.classList.toggle('table-bar_selected', ids.length > 0);
    };

    selectAll?.addEventListener('change', () => {
        rowChecks().forEach((check) => {
            check.checked = selectAll.checked;
        });
        update();
    });
    list.addEventListener('change', (event) => {
        if (event.target.matches('[data-sf-row-select]')) {
            update();
        }
    });
    bar?.querySelector('[data-sf-select-clear]')?.addEventListener('click', () => {
        rowChecks().forEach((check) => {
            check.checked = false;
        });
        update();
    });

    bar?.addEventListener('click', async (event) => {
        const button = event.target.closest('[data-sf-list-action]');
        const ids = selectedIds();
        if (!button || button.disabled || !ids.length) {
            return;
        }
        const action = button.dataset.sfListAction;
        if (action === 'edit') {
            window.location.href = `?action=form&ids=${ids.join(',')}`;
        } else if (action === 'copy') {
            window.location.href = `?action=copy&ids=${ids.join(',')}`;
        } else if (action === 'delete') {
            const isConfirmed = await confirm(
                ids.length === 1 ? 'Запись будет удалена без возможности восстановления.'
                    : `Будет удалено записей: ${ids.length}. Удаление нельзя отменить.`,
                {title: ids.length === 1 ? 'Удалить запись?' : 'Удалить записи?', confirmText: 'Удалить', danger: true}
            );
            if (isConfirmed) {
                const params = new URLSearchParams({action: 'delete'});
                ids.forEach((id) => params.append('rows[]', id));
                window.location.href = `?${params}`;
            }
        }
    });

    list.addEventListener('click', async (event) => {
        const remove = event.target.closest('[data-sf-row-delete]');
        if (remove) {
            if (await confirm('Запись будет удалена без возможности восстановления.', {
                title: 'Удалить запись?',
                confirmText: 'Удалить',
                danger: true,
            })) {
                window.location.href = remove.dataset.sfRowDelete;
            }
            return;
        }

        const info = event.target.closest('[data-sf-row-info]');
        if (info) {
            const modal = document.getElementById('sf-modal-info');
            const html = await request(`?action=showDetail&id=${encodeURIComponent(info.dataset.sfRowInfo)}`);
            modal.querySelector('.modal-info__talbe-wrapper').innerHTML = html;
            modal.querySelector('.modal-info__btn-edit')
                ?.setAttribute('href', `?action=form&${list.dataset.pk}=${encodeURIComponent(info.dataset.sfRowInfo)}`);
            window.SimflexModal?.open('sf-modal-info', info);
            return;
        }

        const tagReset = event.target.closest('[data-sf-tag-remove]')?.closest('[data-sf-filter-reset]');
        if (tagReset) {
            window.location.href = tagReset.dataset.sfFilterReset;
        }
    });

    // переключатель в ячейке: значение меняется на сервере, при ошибке возвращается
    list.addEventListener('change', async (event) => {
        const toggle = event.target.closest('[data-sf-bool-change]');
        const cell = toggle?.closest('td[data-field]');
        if (!cell) {
            return;
        }
        try {
            const answer = await request(
                `?ajax=1&action=boolChange&field=${encodeURIComponent(cell.dataset.field)}&pk=${encodeURIComponent(cell.dataset.pk)}`,
                {method: 'POST'}
            );
            if (answer !== '0' && answer !== '1') {
                throw new Error(answer);
            }
            toggle.checked = answer === '1';
        } catch {
            toggle.checked = !toggle.checked;
            toast('Не удалось изменить значение', {type: 'error'});
        }
    });

    // статус в ячейке (FieldEnum) и порядок (FieldNPP): сохраняются сразу
    list.addEventListener('change', async (event) => {
        const enumInput = event.target.closest('.td-enum')?.querySelector('input[type="hidden"]');
        const enumButton = event.target.closest('.td-enum')?.querySelector('[data-sf-enum-change]');
        try {
            if (enumInput && event.target === enumInput && enumButton) {
                await request(`${enumButton.dataset.sfEnumChange}&newstatus=${encodeURIComponent(enumInput.value)}`);
                toast('Статус изменён', {type: 'success'});
            } else if (event.target.matches('[data-sf-npp]')) {
                await request(`${event.target.dataset.sfNpp}&val=${encodeURIComponent(event.target.value)}`);
            }
        } catch (error) {
            toast(error.message || 'Не удалось сохранить изменение', {type: 'error'});
        }
    });

    // фильтры колонок: меню в шапке
    const head = list.querySelector('thead');
    if (head) {
        initColumnFilters(head);
    }

    // поиск над таблицей: Enter — список с найденным, очистка заданного поиска — список без него
    const search = list.querySelector('[data-sf-search]');
    search?.addEventListener('keydown', (event) => {
        if (event.key === 'Enter') {
            event.preventDefault();
            window.location.href = filtersUrl(list.querySelector('.table-toolbar'));
        }
    });
    search?.closest('.text-input')?.querySelector('.text-input__reset')?.addEventListener('click', () => {
        if (search.defaultValue !== '') {
            window.location.href = `${path()}?q=&p=0`;
        }
    });

    // окно фильтров
    document.querySelector('[data-sf-filters-apply]')?.addEventListener('click', () => {
        window.location.href = filtersUrl(document.querySelector('[data-sf-filters-modal]'));
    });

    list.querySelector('.tr_saved')?.scrollIntoView({block: 'center'});
    update();
});
