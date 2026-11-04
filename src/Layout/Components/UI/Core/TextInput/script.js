class TextInput {
    constructor(element) {
        this.element = element;
        this.input = element.querySelector('.text-input__field');
        this.resetButton = element.querySelector('.text-input__reset');
        this.counter = element.querySelector('.text-input__counter');
        this.status = element.querySelector('.text-input__status');
        this.errorMessage = element.querySelector('.text-input__error-message');
        this.mask = this.input.dataset.mask || '';
        this.max = parseInt(this.input.dataset.max || '0', 10);
        this.isEmail = this.input.type === 'email';
        this.invalidMessage = this.input.dataset.errorInvalid || '';

        if (this.resetButton) {
            this.resetButton.removeAttribute('aria-hidden');
            this.resetButton.setAttribute('aria-label', 'Очистить');

            this.resetButton.addEventListener('click', () => this.handleReset());
        }

        this.input.addEventListener('input', (event) => this.handleInput(event));
        this.input.addEventListener('blur', () => this.validate());

        // В форму уходят цифры телефона, а не значение с маской
        if (this.mask && this.input.form && this.input.name) {
            this.input.form.addEventListener('formdata', (event) => {
                event.formData.set(this.input.name, this.getDigits());
            });
        }

        if (this.mask) {
            this.applyMask(false);
        }
        this.refresh();
    }

    /** Цифры телефона с кодом страны: ведущие 8 заменяются на 7, пустой ввод начинается с 7 */
    getDigits() {
        let digits = this.input.value.replace(/\D/g, '');
        if (digits === '') return '';
        if (digits[0] === '8') digits = '7' + digits.slice(1);
        if (digits[0] !== '7') digits = '7' + digits;
        return digits.slice(0, this.max || 11);
    }

    /** Подставляет цифры в маску вида +7 (###) ###-##-##, каретка остаётся за теми же цифрами */
    applyMask(keepCaret = true) {
        const digits = this.getDigits();
        const raw = this.input.value;
        const caret = this.input.selectionStart ?? raw.length;
        const digitsBeforeCaret = raw.slice(0, caret).replace(/\D/g, '').length;

        let result = '';
        let index = 0;
        for (const ch of this.mask) {
            if (index >= digits.length) break;
            if (ch === '#') {
                result += digits[index++];
            } else if (/\d/.test(ch)) {
                // Код страны в маске (+7): его цифра берётся из введённых
                result += ch;
                index++;
            } else {
                result += ch;
            }
        }
        this.input.value = result;

        if (keepCaret && document.activeElement === this.input) {
            let pos = result.length;
            // Каретка в середине: ставим после той же по счёту цифры
            if (caret < raw.length) {
                let seen = 0;
                pos = 0;
                for (let i = 0; i < result.length && seen < digitsBeforeCaret; i++) {
                    if (/\d/.test(result[i])) seen++;
                    pos = i + 1;
                }
            }
            this.input.setSelectionRange(pos, pos);
        }
    }

    handleInput(event) {
        if (this.mask) {
            // Остался только код страны: удаление очищает поле целиком
            const deleting = event && event.inputType && event.inputType.startsWith('delete');
            if (deleting && this.getDigits().length <= 1) {
                this.input.value = '';
            } else {
                this.applyMask();
            }
        }
        this.clearError();
        this.refresh();
    }

    /** Состояния filled, счётчик и кнопка очистки */
    refresh() {
        const hasValue = this.input.value.length > 0;
        this.element.classList.toggle('text-input_filled', hasValue);
        this.input.classList.toggle('has-value', hasValue);

        if (this.resetButton) {
            this.resetButton.style.display = hasValue ? 'block' : 'none';
            this.resetButton.setAttribute('aria-hidden', (!hasValue).toString());
            this.resetButton.tabIndex = hasValue ? 0 : -1;
        }

        if (this.counter) {
            const length = this.mask ? this.getDigits().length : this.input.value.length;
            this.counter.textContent = length + '/' + this.max;
            // Предел объявляем один раз, а не на каждый символ
            if (this.status) {
                this.status.textContent = length >= this.max ? 'Достигнут предел: ' + this.max : '';
            }
        }
    }

    /** Проверка формата при потере фокуса (телефон, почта) */
    validate() {
        if (!this.invalidMessage || this.input.value === '') return;

        const invalid = this.mask
            ? this.getDigits().length < (this.max || 11)
            : this.isEmail && !this.input.checkValidity();
        if (invalid) {
            this.setError(this.invalidMessage);
        }
    }

    setError(message) {
        this.element.classList.add('text-input_error');
        this.input.setAttribute('aria-invalid', 'true');
        if (this.errorMessage) {
            this.errorMessage.textContent = message;
            this.errorMessage.classList.remove('hidden');
        }
    }

    clearError() {
        this.element.classList.remove('text-input_error');
        this.input.removeAttribute('aria-invalid');
        if (this.errorMessage) {
            this.errorMessage.textContent = '';
            this.errorMessage.classList.add('hidden');
        }
    }

    handleReset() {
        this.input.value = '';
        this.clearError();
        this.input.dispatchEvent(new Event('input'));
        this.input.focus();
    }
}

document.querySelectorAll('.text-input').forEach(element => {
    new TextInput(element);
});

// Пароль: кнопка-глаз показывает и прячет введённый пароль
document.addEventListener('click', (event) => {
    const toggle = event.target.closest?.('[data-sf-password-toggle]');
    const input = toggle?.closest('.text-input')?.querySelector('.text-input__field');
    if (!input) {
        return;
    }
    const isShown = input.type === 'password';
    input.type = isShown ? 'text' : 'password';
    toggle.setAttribute('aria-pressed', String(isShown));
    toggle.setAttribute('aria-label', isShown ? 'Скрыть пароль' : 'Показать пароль');
    toggle.querySelector('use')?.setAttribute(
        'href',
        toggle.querySelector('use').getAttribute('href').replace(/#icon-eye(-off)?$/, isShown ? '#icon-eye-off' : '#icon-eye')
    );
});
