/**
 * Список раздела (Table/tpl/show.tpl): выбор строк и «выбрать все», состояние панели действий по числу выбранных,
 * массовые действия (редактирование, копирование, удаление с подтверждением), удаление строки, сведения о записи,
 * переключатели, статусы и порядок в ячейках (сохраняются сразу), фильтры, поиск и теги фильтров
 */
import {confirm, register, request, toast} from './admin.js';

const path = () => window.location.pathname;

/**
 * Адрес списка с фильтрами: значения полей [data-sf-filter] внутри root (фильтры колонок, окно фильтров, поиск)
 */
const filtersUrl = (root) => {
    const params = new URLSearchParams();
    root.querySelectorAll('[data-sf-filter], .th-filter input[type="hidden"]').forEach((input) => {
        if (input.name) {
            params.set(input.name, input.value);
        }
    });
    params.set('p', '0');
    return `${path()}?${params}`;
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
        } catch {
            toast('Не удалось сохранить изменение', {type: 'error'});
        }
    });

    // фильтры колонок и поиск: Enter в поле или выбор в списке — список с новыми фильтрами
    const head = list.querySelector('thead');
    const toolbar = list.querySelector('.table-toolbar');
    [head, toolbar].forEach((area) => {
        area?.addEventListener('keydown', (event) => {
            if (event.key === 'Enter' && event.target.matches('[data-sf-filter]')) {
                event.preventDefault();
                window.location.href = filtersUrl(list);
            }
        });
        area?.addEventListener('change', (event) => {
            if (event.target.matches('.th-filter input[type="hidden"]')) {
                window.location.href = filtersUrl(list);
            }
        });
    });

    // окно фильтров (планшет и телефон)
    document.querySelector('[data-sf-filters-apply]')?.addEventListener('click', () => {
        window.location.href = filtersUrl(document.querySelector('[data-sf-filters-modal]'));
    });

    list.querySelector('.tr_saved')?.scrollIntoView({block: 'center'});
    update();
});
