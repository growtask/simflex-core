/*
 * Тосты (Toast): закрытие по таймеру (анимация .toast__timer, пауза при наведении и фокусе), Esc закрывает последний,
 * не больше трёх в стопке. window.sfToast(message, options) показывает тост в стопке [data-sf-toast-stack]
 */
(() => {
    const MAX_TOASTS = 3;
    const MIN_TIMEOUT = 5000;

    const close = (toast) => toast.remove();

    const initToast = (toast) => {
        toast.querySelector('.toast__timer')?.addEventListener('animationend', () => close(toast));
    };

    const getStack = () => document.querySelector('[data-sf-toast-stack]');

    const limit = (stack) => {
        const toasts = stack.querySelectorAll('[data-sf-toast]');
        [...toasts].slice(0, Math.max(0, toasts.length - MAX_TOASTS)).forEach(close);
    };

    /**
     * @param {string} message
     * @param {{type?: 'default'|'success'|'error', action?: {text: string, href?: string, onClick?: Function},
     *          timeout?: number, timer?: boolean, icon?: boolean}} options
     * @returns {HTMLElement|null}
     */
    window.sfToast = (message, {type = 'default', action = null, timeout = MIN_TIMEOUT, timer = true, icon = true} = {}) => {
        const stack = getStack();
        const template = stack?.querySelector(`template[data-sf-toast-template="${type}"]`)
            ?? stack?.querySelector('template[data-sf-toast-template="default"]');
        if (!template) {
            return null;
        }

        const toast = template.content.firstElementChild.cloneNode(true);
        toast.querySelector('.toast__text').textContent = message;
        toast.style.setProperty('--toast-timeout', `${Math.max(timeout, MIN_TIMEOUT)}ms`);
        toast.querySelector('.toast__timer').classList.toggle('toast__timer_hidden', !timer);
        toast.querySelector('.toast__icon').classList.toggle('toast__icon_hidden', !icon);

        let actionElement = toast.querySelector('.toast__action');
        if (action) {
            if (action.href) {
                const link = document.createElement('a');
                link.className = actionElement.className;
                link.href = action.href;
                actionElement.replaceWith(link);
                actionElement = link;
            }
            actionElement.textContent = action.text;
            if (action.onClick) {
                actionElement.addEventListener('click', (event) => {
                    action.onClick(event);
                    close(toast);
                });
            }
        } else {
            actionElement.remove();
        }

        template.before(toast);
        initToast(toast);
        limit(stack);

        return toast;
    };

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            const toasts = getStack()?.querySelectorAll('[data-sf-toast]');
            if (toasts?.length) {
                close(toasts[toasts.length - 1]);
            }
        }
    });

    const initAll = () => document.querySelectorAll('[data-sf-toast]').forEach(initToast);
    document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', initAll) : initAll();
})();
