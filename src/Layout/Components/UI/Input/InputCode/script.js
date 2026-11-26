/*
 * Поле одноразового кода (CodeInput): ввод цифры переводит фокус дальше, Backspace очищает цифру и возвращает назад,
 * стрелки двигают между полями, вставка раскладывает цифры по полям. Код целиком — в скрытом поле
 * [data-sf-code-value] (события input и change), на заполнении всех цифр на корне срабатывает sf-code-complete
 */
(() => {
    const ROOT = '[data-sf-code-input]';

    const digitsOf = (root) => [...root.querySelectorAll('.code-input__digit')];

    const sync = (root) => {
        const value = digitsOf(root).map((field) => field.value).join('');
        const hidden = root.querySelector('[data-sf-code-value]');
        if (hidden.value === value) {
            return;
        }
        hidden.value = value;
        hidden.dispatchEvent(new Event('input', {bubbles: true}));
        hidden.dispatchEvent(new Event('change', {bubbles: true}));
        if (value.length === digitsOf(root).length) {
            root.dispatchEvent(new CustomEvent('sf-code-complete', {bubbles: true, detail: {value}}));
        }
    };

    // сообщение об ошибке пропадает, как только посетитель правит код
    const clearError = (root) => {
        if (root.classList.contains('code-input_state_error')) {
            root.classList.remove('code-input_state_error');
            root.querySelectorAll('[aria-invalid]').forEach((field) => field.removeAttribute('aria-invalid'));
            root.querySelector('.code-input__message').hidden = true;
        }
    };

    const fill = (root, from, text) => {
        const fields = digitsOf(root);
        const digits = text.replace(/\D/g, '');
        let last = from;
        [...digits].slice(0, fields.length - from).forEach((digit, index) => {
            fields[from + index].value = digit;
            last = from + index;
        });
        fields[Math.min(last + (digits ? 1 : 0), fields.length - 1)].focus();
        sync(root);
    };

    document.addEventListener('input', (event) => {
        const field = event.target.closest?.('.code-input__digit');
        const root = field?.closest(ROOT);
        if (!root) {
            return;
        }
        clearError(root);
        const fields = digitsOf(root);
        const index = fields.indexOf(field);
        // автозаполнение браузера кладёт весь код в одно поле; нецифры отбрасываем
        if (field.value.length > 1 || /\D/.test(field.value)) {
            const text = field.value;
            field.value = '';
            fill(root, index, text);
            return;
        }
        sync(root);
        if (field.value !== '' && index < fields.length - 1) {
            fields[index + 1].focus();
        }
    });

    document.addEventListener('keydown', (event) => {
        const field = event.target.closest?.('.code-input__digit');
        const root = field?.closest(ROOT);
        if (!root) {
            return;
        }
        const fields = digitsOf(root);
        const index = fields.indexOf(field);
        if (event.key === 'Backspace' && field.value === '' && index > 0) {
            event.preventDefault();
            fields[index - 1].value = '';
            fields[index - 1].focus();
            sync(root);
        } else if (event.key === 'ArrowLeft' && index > 0) {
            event.preventDefault();
            fields[index - 1].focus();
        } else if (event.key === 'ArrowRight' && index < fields.length - 1) {
            event.preventDefault();
            fields[index + 1].focus();
        }
    });

    document.addEventListener('paste', (event) => {
        const field = event.target.closest?.('.code-input__digit');
        const root = field?.closest(ROOT);
        if (!root) {
            return;
        }
        event.preventDefault();
        clearError(root);
        fill(root, digitsOf(root).indexOf(field), event.clipboardData.getData('text'));
    });

    document.addEventListener('focusin', (event) => {
        if (event.target.matches?.('.code-input__digit')) {
            event.target.select();
        }
    });
})();
