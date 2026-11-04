/**
 * Страница редактирования (Table/tpl/form.tpl): раскрытие секций по шапке, вкладки (выбранная — в адресе #tab-…,
 * вкладка с ошибкой валидации открывается сама), скрытие правой панели (localStorage), групповое редактирование —
 * поле приглушено, пока не отмечено «Изменять это поле»
 */
import {register} from './admin.js';

const ASIDE_KEY = 'sf-admin-edit-aside-hidden';

const storage = {
    get(key) {
        try {
            return window.localStorage.getItem(key) === '1';
        } catch {
            return false;
        }
    },
    set(key, value) {
        try {
            window.localStorage.setItem(key, value ? '1' : '0');
        } catch {
            // без хранилища состояние живёт до перезагрузки
        }
    },
};

register('edit-form', (form) => {
    form.addEventListener('click', (event) => {
        const head = event.target.closest('.form-section__head');
        if (!head) {
            return;
        }
        const section = head.closest('[data-sf-form-section]');
        const isOpen = !section.classList.contains('form-section_open');
        section.classList.toggle('form-section_open', isOpen);
        head.setAttribute('aria-expanded', String(isOpen));
        section.querySelector('.form-section__body').inert = !isOpen;
    });

    // вкладки
    const tabButtons = [...form.querySelectorAll('[data-sf-tab-button]')];
    const showTab = (id, updateHash = true) => {
        const button = tabButtons.find((item) => item.dataset.sfTabButton === id) ?? tabButtons[0];
        if (!button) {
            return;
        }
        tabButtons.forEach((item) => {
            const isActive = item === button;
            item.classList.toggle('active', isActive);
            item.setAttribute('aria-selected', String(isActive));
            item.tabIndex = isActive ? 0 : -1;
        });
        form.querySelectorAll('[data-sf-tab]').forEach((section) => {
            section.hidden = section.dataset.sfTab !== button.dataset.sfTabButton;
        });
        if (updateHash) {
            history.replaceState(null, '', `#${button.dataset.sfTabButton}`);
        }
    };
    if (tabButtons.length) {
        tabButtons.forEach((button) => button.addEventListener('click', () => showTab(button.dataset.sfTabButton)));
        form.querySelector('[role="tablist"]')?.addEventListener('keydown', (event) => {
            const index = tabButtons.indexOf(document.activeElement);
            if (index === -1 || !['ArrowLeft', 'ArrowRight'].includes(event.key)) {
                return;
            }
            const next = tabButtons[(index + (event.key === 'ArrowRight' ? 1 : -1) + tabButtons.length) % tabButtons.length];
            next.focus();
            showTab(next.dataset.sfTabButton);
        });
        // вкладка с ошибкой, иначе из адреса, иначе первая
        const errorTab = form.querySelector('[data-sf-error]')?.closest('[data-sf-tab]')?.dataset.sfTab;
        showTab(errorTab ?? window.location.hash.slice(1), Boolean(errorTab));
    }

    // правая панель
    const aside = form.querySelector('[data-sf-edit-aside]');
    const asideToggle = aside?.querySelector('[data-sf-aside-toggle]');
    const setAsideHidden = (isHidden) => {
        form.classList.toggle('edit-form_aside-hidden', isHidden);
        asideToggle?.setAttribute('aria-expanded', String(!isHidden));
        asideToggle?.setAttribute('aria-label', isHidden ? 'Показать панель' : 'Скрыть панель');
        asideToggle?.setAttribute('title', isHidden ? 'Показать панель' : 'Скрыть панель');
    };
    setAsideHidden(storage.get(ASIDE_KEY));
    asideToggle?.addEventListener('click', () => {
        const isHidden = !form.classList.contains('edit-form_aside-hidden');
        setAsideHidden(isHidden);
        storage.set(ASIDE_KEY, isHidden);
    });

    // групповое редактирование: неотмеченное поле приглушено
    const updateBulk = (check) => check.closest('.form-input')?.classList.toggle('form-input_bulk-on', check.checked);
    form.querySelectorAll('[data-sf-bulk]').forEach(updateBulk);
    form.addEventListener('change', (event) => {
        if (event.target.matches('[data-sf-bulk]')) {
            updateBulk(event.target);
        }
    });
    // изменение поля отмечает его для сохранения
    form.addEventListener('input', (event) => {
        const check = event.target.closest('.form-input_bulk')?.querySelector('[data-sf-bulk]');
        if (check && event.target !== check && !check.checked) {
            check.checked = true;
            updateBulk(check);
        }
    });

    form.querySelector('[data-sf-error]')?.scrollIntoView({block: 'center'});
});
