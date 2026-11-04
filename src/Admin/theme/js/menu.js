/**
 * Меню админки (theme/tpl/partial/sidebar.tpl): сворачивание до 72 px, раскрытие групп, поиск по пунктам,
 * шторка на планшете и телефоне. Свёрнутость меню и раскрытые группы хранятся в localStorage
 */
import {register} from './admin.js';

const COLLAPSED_KEY = 'sf-admin-menu-collapsed';
const GROUPS_KEY = 'sf-admin-menu-groups';
const MOBILE = window.matchMedia('(width <= 811px)');

const storage = {
    get(key, fallback) {
        try {
            return JSON.parse(window.localStorage.getItem(key)) ?? fallback;
        } catch {
            return fallback;
        }
    },
    set(key, value) {
        try {
            window.localStorage.setItem(key, JSON.stringify(value));
        } catch {
            // хранилище недоступно: состояние живёт до перезагрузки
        }
    },
};

register('menu', (menu) => {
    const groups = [...menu.querySelectorAll('[data-sf-menu-group]')];
    const collapse = menu.querySelector('[data-sf-menu-collapse]');
    const search = menu.querySelector('[data-sf-menu-search]');
    const empty = menu.querySelector('[data-sf-menu-empty]');
    const overlay = document.querySelector('.menu-overlay');
    const openButtons = document.querySelectorAll('[data-sf-menu-open]');

    const setGroupOpen = (group, isOpen) => {
        group.classList.toggle('menu-group_open', isOpen);
        group.querySelector('.menu-group__head').setAttribute('aria-expanded', String(isOpen));
        group.querySelector('.menu-group__body').inert = !isOpen;
    };
    const saveGroups = () => storage.set(GROUPS_KEY, groups
        .filter((group) => group.classList.contains('menu-group_open'))
        .map((group) => group.dataset.sfMenuGroup));

    // раскрытые группы: сохранённые и группа текущей страницы
    const opened = storage.get(GROUPS_KEY, []);
    groups.forEach((group) => setGroupOpen(
        group,
        group.classList.contains('menu-group_current') || opened.includes(group.dataset.sfMenuGroup)
    ));

    const setCollapsed = (isCollapsed) => {
        menu.classList.toggle('menu_collapsed', isCollapsed);
        document.documentElement.classList.toggle('sf-menu-collapsed', isCollapsed);
        collapse?.setAttribute('aria-expanded', String(!isCollapsed));
        collapse?.setAttribute('aria-label', isCollapsed ? 'Развернуть меню' : 'Свернуть меню');
    };
    setCollapsed(!MOBILE.matches && storage.get(COLLAPSED_KEY, false));
    // без анимации при загрузке
    requestAnimationFrame(() => menu.classList.add('menu_ready'));

    collapse?.addEventListener('click', () => {
        const isCollapsed = !menu.classList.contains('menu_collapsed');
        setCollapsed(isCollapsed);
        storage.set(COLLAPSED_KEY, isCollapsed);
    });

    menu.addEventListener('click', (event) => {
        const head = event.target.closest('.menu-group__head');
        if (!head) {
            return;
        }
        const group = head.closest('[data-sf-menu-group]');
        // в свёрнутом меню нажатие на иконку группы разворачивает меню и открывает группу
        if (menu.classList.contains('menu_collapsed')) {
            setCollapsed(false);
            storage.set(COLLAPSED_KEY, false);
            setGroupOpen(group, true);
        } else {
            setGroupOpen(group, !group.classList.contains('menu-group_open'));
        }
        saveGroups();
    });

    // поиск: пункты, в названии которых есть строка; группы с найденными пунктами раскрываются
    search?.addEventListener('input', () => {
        const query = search.value.trim().toLowerCase();
        let found = 0;
        groups.forEach((group) => {
            let groupFound = 0;
            group.querySelectorAll('[data-sf-menu-item]').forEach((item) => {
                const isMatch = query === '' || item.dataset.sfMenuItem.includes(query);
                item.closest('li').hidden = !isMatch;
                groupFound += isMatch ? 1 : 0;
            });
            const isGroupMatch = query !== '' && group.querySelector('.menu-group__name').textContent
                .toLowerCase().includes(query);
            if (isGroupMatch) {
                group.querySelectorAll('li').forEach((li) => {
                    li.hidden = false;
                });
            }
            group.hidden = groupFound === 0 && !isGroupMatch;
            if (query !== '') {
                setGroupOpen(group, true);
            }
            found += group.hidden ? 0 : 1;
        });
        menu.querySelectorAll('.menu__leaf').forEach((leaf) => {
            leaf.hidden = query !== '' && !leaf.querySelector('[data-sf-menu-item]').dataset.sfMenuItem.includes(query);
            found += leaf.hidden ? 0 : 1;
        });
        empty.hidden = found > 0;
        if (query === '') {
            const saved = storage.get(GROUPS_KEY, []);
            groups.forEach((group) => setGroupOpen(
                group,
                group.classList.contains('menu-group_current') || saved.includes(group.dataset.sfMenuGroup)
            ));
        }
    });

    // шторка меню на планшете и телефоне
    let returnFocus = null;
    const setDrawer = (isOpen) => {
        menu.classList.toggle('menu_open', isOpen);
        overlay.hidden = !isOpen;
        document.documentElement.classList.toggle('scroll-lock', isOpen);
        openButtons.forEach((button) => button.setAttribute('aria-expanded', String(isOpen)));
        if (isOpen) {
            returnFocus = document.activeElement;
            menu.querySelector('[data-sf-menu-close]')?.focus();
        } else {
            returnFocus?.focus();
        }
    };
    openButtons.forEach((button) => button.addEventListener('click', () => setDrawer(true)));
    document.querySelectorAll('[data-sf-menu-close]').forEach((button) => {
        button.addEventListener('click', () => setDrawer(false));
    });
    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && menu.classList.contains('menu_open')) {
            setDrawer(false);
        }
    });
    MOBILE.addEventListener('change', () => {
        setDrawer(false);
        setCollapsed(!MOBILE.matches && storage.get(COLLAPSED_KEY, false));
    });
});
