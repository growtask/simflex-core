/*
 * Поле телефона со страной (PhoneInput): плитка с флагом открывает список стран, номер вводится по маске страны
 * (# — цифра). Полный номер с кодом страны (цифры) лежит в скрытом поле [data-sf-phone-value]; выбор страны и ввод
 * вызывают на нём input и change. Вставка с кодом страны (+7…, 8…) разбирается по выбранной стране
 */
(() => {
    const ROOT = '[data-sf-phone]';

    const maskDigits = (mask) => (mask.match(/#/g) || []).length;

    const format = (mask, digits) => {
        let result = '';
        let index = 0;
        for (const char of mask) {
            if (index >= digits.length) {
                break;
            }
            result += char === '#' ? digits[index++] : char;
        }
        return result;
    };

    const init = (root) => {
        const field = root.querySelector('[data-sf-phone-field]');
        const hidden = root.querySelector('[data-sf-phone-value]');
        const toggle = root.querySelector('[data-sf-phone-toggle]');
        const panel = root.querySelector('.phone-input__panel');
        const flag = root.querySelector('[data-sf-phone-flag]');
        const options = [...panel.querySelectorAll('.phone-input__option')];
        let current = options.find((option) => option.getAttribute('aria-selected') === 'true') || options[0];

        const placeholderOf = (option) => option.dataset.mask.replaceAll('#', '_');

        const sync = () => {
            const digits = field.value.replace(/\D/g, '');
            const value = digits === '' ? '' : current.dataset.dial + digits;
            if (hidden.value !== value) {
                hidden.value = value;
                hidden.dispatchEvent(new Event('input', {bubbles: true}));
                hidden.dispatchEvent(new Event('change', {bubbles: true}));
            }
        };

        const applyMask = () => {
            let digits = field.value.replace(/\D/g, '');
            const dial = current.dataset.dial;
            // вставленный номер с кодом страны или с 8 вместо кода России
            if (digits.length > maskDigits(current.dataset.mask)) {
                if (digits.startsWith(dial)) {
                    digits = digits.slice(dial.length);
                } else if (dial === '7' && digits.startsWith('8')) {
                    digits = digits.slice(1);
                }
            }
            digits = digits.slice(0, maskDigits(current.dataset.mask));
            field.value = format(current.dataset.mask, digits);
            sync();
        };

        const close = (focus = false) => {
            panel.hidden = true;
            toggle.setAttribute('aria-expanded', 'false');
            panel.classList.remove('phone-input__panel_up');
            if (focus) {
                toggle.focus();
            }
        };

        const open = () => {
            panel.hidden = false;
            toggle.setAttribute('aria-expanded', 'true');
            // не помещается снизу и помещается сверху — открываем вверх
            const rect = panel.getBoundingClientRect();
            const below = window.innerHeight - toggle.getBoundingClientRect().bottom;
            const above = toggle.getBoundingClientRect().top;
            panel.classList.toggle('phone-input__panel_up', rect.height > below && above > below);
            (options.find((option) => option === current) || options[0]).focus();
        };

        const choose = (option) => {
            const previous = current;
            current = option;
            options.forEach((item) => item.setAttribute('aria-selected', String(item === option)));
            flag.className = `phone-flag phone-flag_${option.dataset.country}`;
            toggle.setAttribute('aria-label', `Страна: ${option.dataset.name} +${option.dataset.dial}`);
            if (field.placeholder === placeholderOf(previous)) {
                field.placeholder = placeholderOf(option);
            }
            applyMask();
            // состояние поля (заполнено, кнопка очистки) обновляет скрипт TextInput
            field.dispatchEvent(new Event('input', {bubbles: true}));
            close(true);
        };

        toggle.addEventListener('click', () => (panel.hidden ? open() : close()));
        options.forEach((option) => option.addEventListener('click', () => choose(option)));
        field.addEventListener('input', applyMask);

        root.addEventListener('keydown', (event) => {
            if (panel.hidden) {
                return;
            }
            if (event.key === 'Escape') {
                event.preventDefault();
                close(true);
            } else if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
                event.preventDefault();
                const index = options.indexOf(document.activeElement);
                const next = event.key === 'ArrowDown' ? index + 1 : index - 1;
                options[(next + options.length) % options.length].focus();
            } else if (event.key === 'Tab') {
                close();
            }
        });
        document.addEventListener('click', (event) => {
            if (!panel.hidden && !root.contains(event.target)) {
                close();
            }
        });

        sync();
    };

    const initAll = () => document.querySelectorAll(ROOT).forEach((root) => {
        if (!root.sfPhone) {
            root.sfPhone = true;
            init(root);
        }
    });
    document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', initAll) : initAll();
})();
