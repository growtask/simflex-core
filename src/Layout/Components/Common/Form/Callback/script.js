/**
 * Форма «Связаться с нами»: клиентская проверка, отправка (fetch, JSON), результат на месте формы.
 * Ответ сервера - конверт JSON API: успех - HTTP 200 и error.code 0, ошибки полей - 422 и error.errors
 * ({поле: текст}), прочая ошибка - error.message.
 */
(() => {
    const MESSAGES = {
        required: 'Заполните поле',
        phone: 'Введите номер телефона',
        email: 'Введите почту в формате name@example.com',
        consent: 'Нужно согласие на обработку данных',
        server: 'Не удалось отправить, попробуйте позже',
    };

    class Callback {
        constructor(root) {
            this.root = root;
            this.form = root.querySelector('[data-callback-form]');
            this.resultBox = root.querySelector('[data-callback-result]');
            if (!this.form || !this.resultBox) {
                return;
            }
            this.submitButton = this.form.querySelector('.callback__submit');
            this.sending = false;

            this.form.addEventListener('submit', event => {
                event.preventDefault();
                this.submit();
            });
            // ошибка поля пропадает, когда его начинают править
            this.form.addEventListener('input', event => this.clearError(event.target));
            this.form.addEventListener('change', event => this.clearError(event.target));
            this.root.addEventListener('click', event => {
                const action = event.target.closest('[data-callback-action]');
                if (action) {
                    this.handleAction(action.getAttribute('data-callback-action'));
                }
            });

            // ошибки, пришедшие с сервера при выводе формы
            const initial = root.getAttribute('data-errors');
            if (initial) {
                try {
                    this.showErrors(JSON.parse(initial));
                } catch (e) {
                    // игнорируем повреждённые данные
                }
            }
        }

        /** Поля формы по имени */
        field(name) {
            return this.form.elements[name] || null;
        }

        /** Контейнер, куда выводится сообщение об ошибке поля */
        errorHost(input) {
            return input.closest('.text-input__wrapper, .textarea__wrapper, .callback__consent-wrap') || input.parentElement;
        }

        showError(input, message) {
            const host = this.errorHost(input);
            let box = host.querySelector('.callback__error');
            if (!box) {
                box = host.querySelector('.text-input__error-message, .textarea__message');
                if (box) {
                    box.classList.add('callback__error');
                } else {
                    box = document.createElement('span');
                    box.className = 'callback__error';
                    host.appendChild(box);
                }
            }
            if (!box.id) {
                box.id = `${this.form.id}-${input.name}-error`;
            }
            box.textContent = message;
            box.classList.remove('hidden');
            box.hidden = false;
            input.setAttribute('aria-invalid', 'true');
            input.setAttribute('aria-describedby', box.id);
            host.classList.add('is-error');
        }

        clearError(input) {
            if (!input || !input.name || input.getAttribute('aria-invalid') !== 'true') {
                return;
            }
            const host = this.errorHost(input);
            const box = host.querySelector('.callback__error');
            if (box) {
                box.textContent = '';
                box.hidden = true;
            }
            input.removeAttribute('aria-invalid');
            input.removeAttribute('aria-describedby');
            host.classList.remove('is-error');
        }

        clearAllErrors() {
            Array.from(this.form.elements).forEach(el => this.clearError(el));
        }

        showErrors(errors) {
            let first = null;
            Object.keys(errors).forEach(name => {
                const input = this.field(name);
                if (input && input.name) {
                    this.showError(input, errors[name]);
                    first = first || input;
                }
            });
            if (first) {
                first.focus();
            }
            return first;
        }

        /** Проверка на клиенте; возвращает объект ошибок */
        validate() {
            const errors = {};
            const value = name => (this.field(name) ? this.field(name).value.trim() : null);

            const name = value('name');
            if (name !== null && name === '') {
                errors.name = MESSAGES.required;
            }
            const phone = value('phone');
            if (phone !== null) {
                const digits = phone.replace(/\D/g, '');
                if (phone === '') {
                    errors.phone = MESSAGES.required;
                } else if (digits.length < 10 || digits.length > 15) {
                    errors.phone = MESSAGES.phone;
                }
            }
            const email = value('email');
            if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                errors.email = MESSAGES.email;
            }
            const consent = this.field('consent');
            if (consent && !consent.checked) {
                errors.consent = MESSAGES.consent;
            }
            return errors;
        }

        setSending(on) {
            this.sending = on;
            this.form.setAttribute('aria-busy', on ? 'true' : 'false');
            if (this.submitButton) {
                this.submitButton.classList.toggle('loading', on);
                this.submitButton.disabled = on;
                this.submitButton.setAttribute('aria-busy', on ? 'true' : 'false');
            }
            this.root.classList.toggle('callback-state_sending', on);
        }

        async submit() {
            if (this.sending) {
                return;
            }
            this.clearAllErrors();
            const errors = this.validate();
            if (Object.keys(errors).length) {
                this.showErrors(errors);
                return;
            }

            this.setSending(true);
            try {
                const response = await fetch(this.form.getAttribute('action'), {
                    method: 'POST',
                    body: JSON.stringify(Object.fromEntries(new FormData(this.form))),
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest',
                        'Accept': 'application/json',
                    },
                    credentials: 'same-origin',
                });
                // ответ - конверт JSON API: {error: {code, message, errors}}
                const data = await response.json();
                this.setSending(false);
                const errors = data?.error?.errors ?? {};
                if (response.ok && !data?.error?.code) {
                    this.showResult('success');
                } else if (Object.keys(errors).length) {
                    this.showErrors(errors);
                } else {
                    this.showResult('error');
                }
            } catch (e) {
                this.setSending(false);
                this.showResult('error');
            }
        }

        /** Результат встаёт на место формы */
        showResult(type) {
            const template = this.root.querySelector(`[data-callback-template="${type}"]`);
            if (!template) {
                return;
            }
            this.resultBox.replaceChildren(template.content.cloneNode(true));
            this.form.hidden = true;
            this.resultBox.hidden = false;
            this.root.classList.add(`callback-state_${type}`);
            const button = this.resultBox.querySelector('button');
            if (button) {
                button.focus();
            }
        }

        showForm() {
            this.resultBox.replaceChildren();
            this.resultBox.hidden = true;
            this.form.hidden = false;
            this.root.classList.remove('callback-state_success', 'callback-state_error');
        }

        handleAction(action) {
            if (action === 'retry') {
                this.showForm();
                const first = this.form.querySelector('input:not([type="hidden"]):not([tabindex="-1"]), textarea');
                if (first) {
                    first.focus();
                }
                return;
            }

            // reset: форма очищается; в окне Modal окно закрывается
            this.form.reset();
            this.form.querySelectorAll('.textarea__field').forEach(el => el.dispatchEvent(new Event('input', {bubbles: true})));
            this.form.querySelectorAll('.text-input__field').forEach(el => el.dispatchEvent(new Event('input', {bubbles: true})));
            this.showForm();
            const modal = this.root.closest('.modal');
            if (modal && window.SimflexModal) {
                window.SimflexModal.close(modal.id);
            }
        }
    }

    const init = () => document.querySelectorAll('[data-callback]').forEach(root => new Callback(root));
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
