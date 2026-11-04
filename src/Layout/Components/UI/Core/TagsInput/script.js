/*
 * Поле тегов (TagsInput): ввод показывает подсказки (варианты разметки или поиск data-search-url&text=, ответ
 * [{id, name}]), уже выбранные не предлагаются. Enter или клик — добавить тег, при data-allow-new Enter добавляет
 * введённый текст; крестик тега и Backspace в пустом поле — удалить. Значения — в скрытом поле через запятую
 * (событие change), стрелки ходят по подсказкам (aria-activedescendant), Esc закрывает их.
 */
(() => {
    const ROOT = '[data-sf-tags-input]';
    const timers = new WeakMap();
    let counter = 0;

    const parts = (root) => ({
        hidden: root.querySelector('[data-sf-tags-value]'),
        text: root.querySelector('[data-sf-tags-text]'),
        panel: root.querySelector('.tags-input__panel'),
        list: root.querySelector('.tags-input__options'),
        tags: root.querySelector('.tags-input__tags'),
    });

    const getValues = (root) => [...parts(root).tags.querySelectorAll('.tags-input__tag')].map((tag) => tag.dataset.value);

    const sync = (root) => {
        const {hidden} = parts(root);
        const value = getValues(root).join(',');
        if (hidden.value !== value) {
            hidden.value = value;
            hidden.dispatchEvent(new Event('change', {bubbles: true}));
        }
    };

    const fromTemplate = (root, name) => root.querySelector(`template[data-sf-tags-${name}]`).content.firstElementChild.cloneNode(true);

    const setText = (node, text) => {
        let label = node.querySelector('.tab__text, .tag__text');
        if (!label) {
            // у пустого Tab подписи нет
            label = document.createElement('span');
            label.className = 'tab__text';
            node.append(label);
        }
        label.textContent = text;
    };

    const addTag = (root, value, text) => {
        if (value === '' || getValues(root).includes(String(value))) {
            return;
        }
        const tag = fromTemplate(root, 'tag');
        tag.dataset.value = String(value);
        setText(tag, text);
        tag.querySelector('.tag__close')?.setAttribute('aria-label', `Удалить ${text}`);
        parts(root).tags.append(tag);
        sync(root);
    };

    const getOptions = (root) => [...parts(root).list.querySelectorAll('.tags-input__option')].filter((option) => !option.hidden);

    const setActive = (root, option) => {
        const {text} = parts(root);
        getOptions(root).forEach((item) => item.classList.toggle('active', item === option));
        if (option) {
            option.id ||= `sf-tags-option-${++counter}`;
            text.setAttribute('aria-activedescendant', option.id);
            option.scrollIntoView({block: 'nearest'});
        } else {
            text.removeAttribute('aria-activedescendant');
        }
    };

    const close = (root) => {
        const {panel, text} = parts(root);
        panel.hidden = true;
        text.setAttribute('aria-expanded', 'false');
        setActive(root, null);
    };

    /** Подсказки по введённому тексту; «Добавить «…»» — первым, если можно добавить свой */
    const render = (root) => {
        const {panel, list, text} = parts(root);
        const query = text.value.trim().toLowerCase();
        const selected = getValues(root);
        list.querySelector('[data-new]')?.remove();
        let visible = 0;
        list.querySelectorAll('.tags-input__option').forEach((option) => {
            option.hidden = selected.includes(option.dataset.value)
                || (query !== '' && !option.textContent.toLowerCase().includes(query));
            visible += option.hidden ? 0 : 1;
        });
        const isExact = [...list.querySelectorAll('.tags-input__option')]
            .some((option) => option.textContent.trim().toLowerCase() === query);
        if (root.hasAttribute('data-allow-new') && query !== '' && !isExact && !selected.includes(text.value.trim())) {
            const option = fromTemplate(root, 'option');
            option.dataset.value = text.value.trim();
            option.dataset.new = '';
            setText(option, `Добавить «${text.value.trim()}»`);
            list.prepend(option);
            visible++;
        }
        root.querySelector('.tags-input__empty').hidden = visible > 0;
        panel.hidden = visible === 0 && query === '';
        text.setAttribute('aria-expanded', String(!panel.hidden));
        setActive(root, getOptions(root)[0] ?? null);
    };

    const search = async (root) => {
        const {list, text} = parts(root);
        const response = await fetch(`${root.dataset.searchUrl}&text=${encodeURIComponent(text.value.trim())}`, {
            headers: {'X-Requested-With': 'XMLHttpRequest'},
            credentials: 'same-origin',
        });
        const items = response.ok ? await response.json() : [];
        list.replaceChildren(...items.map((item) => {
            const option = fromTemplate(root, 'option');
            option.dataset.value = String(item.id);
            setText(option, item.name);
            return option;
        }));
        render(root);
    };

    const choose = (root, option) => {
        const {text} = parts(root);
        const label = option.hasAttribute('data-new') ? option.dataset.value : option.textContent.trim();
        addTag(root, option.dataset.value, label);
        text.value = '';
        render(root);
        text.focus();
    };

    document.addEventListener('input', (event) => {
        const root = event.target.matches?.('[data-sf-tags-text]') && event.target.closest(ROOT);
        if (!root) {
            return;
        }
        if (root.dataset.searchUrl) {
            clearTimeout(timers.get(root));
            timers.set(root, setTimeout(() => search(root), 250));
        } else {
            render(root);
        }
    });

    document.addEventListener('focusin', (event) => {
        const root = event.target.matches?.('[data-sf-tags-text]') && event.target.closest(ROOT);
        if (root && !root.dataset.searchUrl) {
            render(root);
        }
    });

    document.addEventListener('keydown', (event) => {
        const root = event.target.matches?.('[data-sf-tags-text]') && event.target.closest(ROOT);
        if (!root) {
            return;
        }
        const {panel, text} = parts(root);
        const options = getOptions(root);
        const active = options.find((option) => option.classList.contains('active'));
        if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
            event.preventDefault();
            if (panel.hidden) {
                render(root);
                return;
            }
            const index = options.indexOf(active) + (event.key === 'ArrowDown' ? 1 : -1);
            setActive(root, options[(index + options.length) % options.length] ?? null);
        } else if (event.key === 'Enter') {
            if (!panel.hidden && active) {
                event.preventDefault();
                choose(root, active);
            } else if (text.value.trim() !== '') {
                // форма не отправляется по Enter в поле тегов
                event.preventDefault();
            }
        } else if (event.key === 'Escape' && !panel.hidden) {
            event.preventDefault();
            event.stopPropagation();
            close(root);
        } else if (event.key === 'Backspace' && text.value === '') {
            const last = parts(root).tags.lastElementChild;
            if (last) {
                last.remove();
                sync(root);
            }
        }
    });

    document.addEventListener('mousedown', (event) => {
        // выбор подсказки не уводит фокус из поля
        if (event.target.closest('.tags-input__option')) {
            event.preventDefault();
        }
    });

    document.addEventListener('click', (event) => {
        const root = event.target.closest(ROOT);
        document.querySelectorAll(`${ROOT} .tags-input__panel:not([hidden])`).forEach((panel) => {
            if (panel.closest(ROOT) !== root) {
                close(panel.closest(ROOT));
            }
        });
        if (!root) {
            return;
        }
        const option = event.target.closest('.tags-input__option');
        const remove = event.target.closest('[data-sf-tag-remove]');
        if (option) {
            choose(root, option);
        } else if (remove) {
            remove.closest('.tags-input__tag').remove();
            sync(root);
            parts(root).text.focus();
        }
    });
})();
