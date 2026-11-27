/*
 * Тосты (Toast): закрытие по таймеру (анимация .toast__timer, пауза при наведении и фокусе), Esc закрывает последний (если фокус в стопке или ни на чём),
 * не больше трёх в стопке. window.sfToast(message, options) показывает тост в стопке [data-sf-toast-stack].
 * Фокус из закрытого тоста переходит на следующий фокусируемый элемент (соседний тост, иначе страница), а не в body.
 * Стопка — колода: новый тост спереди, старые позади уменьшены (−5 % на ступень) и обрезаны до размера переднего;
 * наведение или фокус раскрывают колоду списком (промежуток стопки), уход — снова колода (через 120 мс). Место
 * тоста — переменные --toast-y, --toast-scale, --toast-clip-t, --toast-clip-x (переход — в style.scss).
 * Появление и уход — переходы toast-enter-* / toast-leave-* (SfUi.transition, assetsGlobal/script.js).
 */
(() => {
    const MAX_TOASTS = 3;
    const MIN_TIMEOUT = 5000;

    // фокус после удаления узла: ближайший фокусируемый элемент после него в документе, иначе перед ним
    const FOCUSABLE = 'a[href], button:not([disabled]), input:not([disabled]):not([type="hidden"]), select:not([disabled]), '
        + 'textarea:not([disabled]), [tabindex]:not([tabindex="-1"])';
    const nextFocus = (node) => {
        const all = [...document.querySelectorAll(FOCUSABLE)]
            .filter((el) => !node.contains(el) && el.getClientRects().length > 0);
        return all.find((el) => node.compareDocumentPosition(el) & Node.DOCUMENT_POSITION_FOLLOWING)
            ?? all.reverse().find((el) => node.compareDocumentPosition(el) & Node.DOCUMENT_POSITION_PRECEDING) ?? null;
    };
    // удалить узел; если фокус был внутри — перенести его, а не потерять в body
    const removeKeepingFocus = (node) => {
        const target = node.contains(document.activeElement) ? nextFocus(node) : null;
        node.remove();
        target?.focus();
    };

    const getStack = () => document.querySelector('[data-sf-toast-stack]');
    const openToasts = (stack) => [...stack.querySelectorAll('[data-sf-toast]')]
        .filter((toast) => !toast.hasAttribute('data-toast-leaving'));

    const layout = (stack) => {
        if (!stack) {
            return;
        }
        const list = openToasts(stack);
        const expanded = stack.hasAttribute('data-expanded');
        const gap = parseFloat(getComputedStyle(stack).rowGap) || 8;
        const n = list.length;
        const frontH = n ? list[n - 1].offsetHeight : 0;
        const frontW = n ? list[n - 1].offsetWidth : 0;
        let acc = 0;
        for (let k = 0; k < n; k++) {
            const toast = list[n - 1 - k];
            const height = toast.offsetHeight;
            let y = 0;
            let scale = 1;
            let clip = 0;
            let clipX = 0;
            if (expanded) {
                y = -acc;
            } else if (k > 0) {
                // видимая часть не выше переднего (лишнее сверху обрезано), выглядывает на gap × k
                const visible = Math.min(height, frontH);
                clip = height - visible;
                clipX = Math.max(0, (toast.offsetWidth - frontW) / 2);
                y = -(frontH - visible) - gap * k;
                scale = 1 - 0.05 * k;
            }
            acc += height + gap;
            toast.style.setProperty('--toast-y', `${y}px`);
            toast.style.setProperty('--toast-scale', String(scale));
            toast.style.setProperty('--toast-clip', `${clip}px`);
            // без обрезки рамка клипа за краями на 32 px (тень не обрезается)
            const cut = clip > 0 || clipX > 0;
            toast.style.setProperty('--toast-clip-t', `${cut ? clip : -32}px`);
            toast.style.setProperty('--toast-clip-x', `${cut ? clipX : -32}px`);
            toast.toggleAttribute('data-toast-back', !expanded && k > 0);
        }
        stack.style.setProperty('--toast-stack-h', `${Math.max(0, acc - gap)}px`);
        if (!n) {
            stack.removeAttribute('data-expanded');
        }
    };

    const resizer = typeof ResizeObserver === 'function'
        ? new ResizeObserver((entries) => layout(entries[0]?.target.closest('[data-sf-toast-stack]')))
        : null;

    const close = (toast) => {
        if (toast.hasAttribute('data-toast-leaving')) {
            return;
        }
        toast.setAttribute('data-toast-leaving', '');
        resizer?.unobserve(toast);
        const stack = toast.closest('[data-sf-toast-stack]');
        layout(stack);
        const done = () => {
            removeKeepingFocus(toast);
            layout(stack);
        };
        if (window.SfUi?.transition) {
            window.SfUi.transition(toast, 'toast', false).then(done);
        } else {
            done();
        }
    };

    const initToast = (toast) => {
        if (toast.dataset.sfToastReady) {
            return;
        }
        toast.dataset.sfToastReady = '1';
        toast.querySelector('.toast__timer')?.addEventListener('animationend', (event) => {
            if (event.target.classList.contains('toast__timer')) {
                close(toast);
            }
        });
        resizer?.observe(toast);
    };

    const limit = (stack) => {
        const toasts = openToasts(stack);
        toasts.slice(0, Math.max(0, toasts.length - MAX_TOASTS)).forEach(close);
    };

    // раскрытие колоды списком: наведение или фокус внутри; сворачивание — с задержкой (курсор пересекает промежутки)
    let collapseTimer = 0;
    const setExpanded = (stack, value) => {
        clearTimeout(collapseTimer);
        if (stack.hasAttribute('data-expanded') === value || (value && !openToasts(stack).length)) {
            return;
        }
        stack.toggleAttribute('data-expanded', value);
        layout(stack);
    };
    document.addEventListener('pointerover', (event) => {
        const stack = event.target.closest?.('[data-sf-toast-stack]');
        if (stack) {
            setExpanded(stack, true);
        }
    });
    document.addEventListener('pointerout', (event) => {
        const stack = event.target.closest?.('[data-sf-toast-stack]');
        if (!stack || stack.contains(event.relatedTarget)) {
            return;
        }
        clearTimeout(collapseTimer);
        collapseTimer = setTimeout(() => {
            if (!stack.contains(document.activeElement)) {
                setExpanded(stack, false);
            }
        }, 120);
    });
    document.addEventListener('focusin', (event) => {
        const stack = event.target.closest?.('[data-sf-toast-stack]');
        if (stack) {
            setExpanded(stack, true);
        }
    });
    document.addEventListener('focusout', (event) => {
        const stack = event.target.closest?.('[data-sf-toast-stack]');
        if (stack && !stack.contains(event.relatedTarget) && !stack.matches(':hover')) {
            setExpanded(stack, false);
        }
    });

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

        toast.hidden = true;
        // новые — после открытых, перед шаблонами: порядок в DOM = порядок показа (последний — спереди)
        stack.querySelector(':scope > template').before(toast);
        initToast(toast);
        limit(stack);
        if (window.SfUi?.transition) {
            window.SfUi.transition(toast, 'toast', true);
        } else {
            toast.hidden = false;
        }
        layout(stack);

        return toast;
    };

    // Esc закрывает последний тост, только если он не нужен другому: событие не обработано (defaultPrevented), а фокус
    // в стопке, курсор над тостом или фокус ни на чём (body). Esc в поле, меню, диалоге тосты не трогает
    document.addEventListener('keydown', (event) => {
        if (event.key !== 'Escape' || event.defaultPrevented) {
            return;
        }
        const stack = getStack();
        const active = document.activeElement;
        const own = stack && (stack.contains(active) || stack.matches(':hover'));
        if (!own && active && active !== document.body && active !== document.documentElement) {
            return;
        }
        const toasts = stack?.querySelectorAll('[data-sf-toast]');
        if (toasts?.length) {
            close(toasts[toasts.length - 1]);
        }
    });

    const initAll = () => {
        document.querySelectorAll('[data-sf-toast]').forEach(initToast);
        document.querySelectorAll('[data-sf-toast-stack]').forEach(layout);
    };
    document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', initAll) : initAll();
})();
