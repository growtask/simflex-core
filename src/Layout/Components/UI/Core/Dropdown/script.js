/*
 * Выпадающий список (Dropdown): открытие по кнопке, закрытие по клику снаружи и Esc (фокус возвращается на кнопку),
 * стрелки и Home/End по пунктам, Enter и клик — выбор, ввод буквы — переход к пункту. Панель открывается вверх, если
 * снизу не хватает места. Селект: выбранное значение в скрытом поле (событие change), подпись и галочка, поиск.
 */
(() => {
    const ROOT = '[data-sf-dropdown]';
    const OPTION = '.dropdown__option';

    const getTrigger = (root) => root.querySelector('[data-sf-dropdown-trigger]');
    const getPanel = (root) => root.querySelector('.dropdown__panel');
    const getOptions = (root) => [...root.querySelectorAll(OPTION)]
        .filter((option) => !option.hidden && option.getAttribute('aria-disabled') !== 'true' && !option.disabled);

    const isOpen = (root) => !getPanel(root).hidden;

    // ближайший предок, который обрезает содержимое (прокрутка таблицы и т. п.)
    const getClipParent = (root) => {
        for (let node = root.parentElement; node && node !== document.body; node = node.parentElement) {
            const style = getComputedStyle(node);
            if (style.overflowX !== 'visible' || style.overflowY !== 'visible') {
                return node;
            }
        }
        return null;
    };

    const unfix = (panel) => {
        panel.classList.remove('dropdown__panel_fixed');
        panel.style.removeProperty('top');
        panel.style.removeProperty('left');
        panel.style.removeProperty('width');
    };

    const place = (root) => {
        const panel = getPanel(root);
        unfix(panel);
        panel.classList.remove('dropdown__panel_position_top');
        if (root.dataset.sfDropdownPosition === 'top') {
            panel.classList.add('dropdown__panel_position_top');
        } else {
            const rect = panel.getBoundingClientRect();
            if (rect.bottom > window.innerHeight && root.getBoundingClientRect().top > rect.height) {
                panel.classList.add('dropdown__panel_position_top');
            }
        }
        // панель вылезает за предка с overflow: показывается поверх (fixed) на том же месте экрана
        const clip = getClipParent(root)?.getBoundingClientRect();
        const rect = panel.getBoundingClientRect();
        if (clip && (rect.top < clip.top || rect.bottom > clip.bottom || rect.left < clip.left
            || rect.right > clip.right)) {
            panel.classList.add('dropdown__panel_fixed');
            panel.style.top = `${rect.top}px`;
            panel.style.left = `${rect.left}px`;
            // ширина как до переключения: min-width 100% у fixed считался бы от окна
            panel.style.width = `${rect.width}px`;
        }
    };

    const close = (root, focusTrigger = false) => {
        if (!isOpen(root)) {
            return;
        }
        getPanel(root).hidden = true;
        unfix(getPanel(root));
        getTrigger(root)?.setAttribute('aria-expanded', 'false');
        root.classList.remove('dropdown_open');
        if (focusTrigger) {
            getTrigger(root)?.focus();
        }
    };

    const open = (root) => {
        document.querySelectorAll(`${ROOT}.dropdown_open`).forEach((other) => other !== root && close(other));
        const panel = getPanel(root);
        // позиция из разметки (top) запоминается, остальное считается по месту
        if (root.dataset.sfDropdownPosition === undefined) {
            root.dataset.sfDropdownPosition = panel.classList.contains('dropdown__panel_position_top') ? 'top' : '';
        }
        panel.hidden = false;
        getTrigger(root)?.setAttribute('aria-expanded', 'true');
        root.classList.add('dropdown_open');
        place(root);
        const search = root.querySelector('[data-sf-dropdown-search]');
        const options = getOptions(root);
        // без прокрутки: прокрутка закрыла бы панель поверх (fixed)
        (search ?? options.find((option) => option.classList.contains('active')) ?? options[0])
            ?.focus({preventScroll: true});
    };

    const select = (root, option) => {
        const input = root.querySelector('input[type="hidden"]');
        root.querySelectorAll(OPTION).forEach((item) => {
            const isSelected = item === option;
            item.classList.toggle('active', isSelected);
            item.setAttribute('aria-selected', isSelected ? 'true' : 'false');
        });
        const value = root.querySelector('.dropdown__value');
        value.textContent = option.textContent.trim();
        value.classList.remove('dropdown__value_placeholder');
        if (input.value !== option.dataset.value) {
            input.value = option.dataset.value;
            input.dispatchEvent(new Event('change', {bubbles: true}));
        }
        close(root, true);
    };

    const move = (root, step) => {
        const options = getOptions(root);
        if (!options.length) {
            return;
        }
        const last = options.length - 1;
        const index = options.indexOf(document.activeElement);
        let next;
        if (Math.abs(step) === Infinity) {
            next = step > 0 ? last : 0;
        } else if (index === -1) {
            // фокус в поиске: вниз — первый пункт, вверх — последний
            next = step > 0 ? 0 : last;
        } else {
            next = (index + step + options.length) % options.length;
        }
        options[next].focus();
    };

    const filter = (root, query) => {
        const text = query.trim().toLowerCase();
        let visible = 0;
        root.querySelectorAll(OPTION).forEach((option) => {
            option.hidden = text !== '' && !option.textContent.toLowerCase().includes(text);
            visible += option.hidden ? 0 : 1;
        });
        root.querySelector('.dropdown__empty').hidden = visible > 0;
    };

    document.addEventListener('click', (event) => {
        const root = event.target.closest?.(ROOT);
        document.querySelectorAll(`${ROOT}.dropdown_open`).forEach((other) => other !== root && close(other));
        if (!root) {
            return;
        }
        if (event.target.closest('[data-sf-dropdown-trigger]')) {
            isOpen(root) ? close(root) : open(root);
            return;
        }
        const option = event.target.closest(OPTION);
        if (!option || option.getAttribute('aria-disabled') === 'true') {
            return;
        }
        if (root.dataset.sfDropdown === 'select') {
            select(root, option);
        } else {
            close(root, true);
        }
    });

    // панель поверх (fixed) не едет вместе со страницей: при прокрутке вне панели меню закрывается
    document.addEventListener('scroll', (event) => {
        document.querySelectorAll(`${ROOT}.dropdown_open .dropdown__panel_fixed`).forEach((panel) => {
            if (!panel.contains(event.target)) {
                close(panel.closest(ROOT));
            }
        });
    }, true);

    document.addEventListener('keydown', (event) => {
        const root = event.target.closest?.(ROOT);
        if (!root || getTrigger(root)?.disabled) {
            return;
        }
        const onTrigger = event.target.closest('[data-sf-dropdown-trigger]');
        if (!isOpen(root)) {
            if (onTrigger && ['ArrowDown', 'ArrowUp'].includes(event.key)) {
                event.preventDefault();
                open(root);
            }
            return;
        }
        const keys = {ArrowDown: 1, ArrowUp: -1, Home: -Infinity, End: Infinity};
        if (event.key in keys) {
            event.preventDefault();
            move(root, keys[event.key]);
        } else if (event.key === 'Escape') {
            event.preventDefault();
            close(root, true);
        } else if (event.key === 'Tab') {
            close(root);
        } else if (event.key === 'Enter' && event.target.matches('[data-sf-dropdown-search]')) {
            event.preventDefault();
            getOptions(root)[0]?.click();
        } else if (event.key.length === 1 && !event.target.matches('input') && !event.ctrlKey && !event.metaKey) {
            // ввод буквы: следующий пункт, который с неё начинается
            const options = getOptions(root);
            const start = options.indexOf(document.activeElement) + 1;
            const letter = event.key.toLowerCase();
            const found = [...options.slice(start), ...options.slice(0, start)]
                .find((option) => option.textContent.trim().toLowerCase().startsWith(letter));
            found?.focus();
        }
    });

    // поиск на сервере: ответ [{id, name}] заменяет варианты списка
    const searchRemote = async (root, query) => {
        const response = await fetch(`${root.dataset.sfDropdownUrl}&text=${encodeURIComponent(query)}`, {
            headers: {'X-Requested-With': 'XMLHttpRequest'},
            credentials: 'same-origin',
        });
        const items = response.ok ? await response.json() : [];
        const list = root.querySelector('.dropdown__list');
        const template = root.querySelector('template[data-sf-dropdown-option]');
        const value = root.querySelector('input[type="hidden"]').value;
        list.replaceChildren(...items.map((item) => {
            const option = template.content.firstElementChild.cloneNode(true);
            const isSelected = String(item.id) === value;
            option.dataset.value = String(item.id);
            option.querySelector('.tab__text')?.remove();
            const text = document.createElement('span');
            text.className = 'tab__text';
            text.textContent = item.name;
            option.prepend(text);
            option.classList.toggle('active', isSelected);
            option.setAttribute('aria-selected', String(isSelected));
            return option;
        }));
        root.querySelector('.dropdown__empty').hidden = items.length > 0;
    };

    const timers = new WeakMap();
    document.addEventListener('input', (event) => {
        const root = event.target.matches?.('[data-sf-dropdown-search]') && event.target.closest(ROOT);
        if (!root) {
            return;
        }
        if (root.dataset.sfDropdownUrl) {
            clearTimeout(timers.get(root));
            timers.set(root, setTimeout(() => searchRemote(root, event.target.value), 200));
        } else {
            filter(root, event.target.value);
        }
    });
})();
