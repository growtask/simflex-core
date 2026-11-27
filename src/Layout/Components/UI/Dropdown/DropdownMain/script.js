/*
 * Выпадающий список (Dropdown): открытие по кнопке, закрытие по клику снаружи и Esc (фокус возвращается на кнопку),
 * стрелки и Home/End по пунктам, Enter и клик — выбор, ввод буквы — переход к пункту. Панель открывается вверх, если
 * снизу не хватает места. Селект: выбранное значение в скрытом поле (событие change), подпись и галочка, поиск.
 * Поиск на сервере (data-sf-dropdown-url): url?text=… (адрес с «?» и без), ответ — массив или {items}, сбой — пустой
 * список, устаревший ответ (пришёл после более нового запроса) отбрасывается.
 */
(() => {
    const ROOT = '[data-sf-dropdown]';
    const OPTION = '.dropdown__option';

    const getTrigger = (root) => root.querySelector('[data-sf-dropdown-trigger]');
    const getPanel = (root) => root.querySelector('.dropdown__panel');
    const getOptions = (root) => [...root.querySelectorAll(OPTION)]
        .filter((option) => !option.hidden && option.getAttribute('aria-disabled') !== 'true' && !option.disabled);

    const isOpen = (root) => root.classList.contains('dropdown_open');
    // переходы панели (dropdown-panel-* в style.scss) и каскад пунктов при открытии; без общего скрипта - сразу
    const showPanel = (panel, show) => {
        if (window.SfUi?.transition) {
            return window.SfUi.transition(panel, 'dropdown-panel', show);
        }
        panel.hidden = !show;
        return Promise.resolve();
    };

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
        root.classList.remove('dropdown_open');
        const panel = getPanel(root);
        panel.classList.remove('dropdown__panel_cascade');
        // позиция fixed снимается после ухода панели, иначе она прыгнет на время перехода
        showPanel(panel, false).then(() => !isOpen(root) && unfix(panel));
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
        panel.classList.add('dropdown__panel_cascade');
        showPanel(panel, true);
        // каскад только при открытии: фильтр поиска и перерисовка его не повторяют
        setTimeout(() => panel.classList.remove('dropdown__panel_cascade'), 600);
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

    // запрос подсказок url?text=… — адрес с «?» и без; ответ — массив или
    // {items}; сбой сети и не-JSON — пустой список; null — ответ устарел (после него этот же root запросил снова)
    const requests = new WeakMap();
    const fetchSuggest = async (url, text, owner) => {
        const no = (requests.get(owner) || 0) + 1;
        requests.set(owner, no);
        let list = [];
        try {
            const address = new URL(url, document.baseURI);
            address.searchParams.set('text', String(text ?? ''));
            const response = await fetch(address.href, {
                headers: {'X-Requested-With': 'XMLHttpRequest'},
                credentials: 'same-origin',
            });
            if (response.ok) {
                const data = await response.json();
                list = Array.isArray(data) ? data : (Array.isArray(data?.items) ? data.items : []);
            }
        } catch (error) {
            list = [];
        }
        return requests.get(owner) === no ? list : null;
    };

    // поиск на сервере: ответ ([{id, name}] или {items: […]}) заменяет варианты списка
    const searchRemote = async (root, query) => {
        const items = await fetchSuggest(root.dataset.sfDropdownUrl, query, root);
        if (items === null) {
            return;
        }
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
