/* Проверка возраста: фокус на первой кнопке, Tab по кругу внутри окна, прокрутка страницы заблокирована.
 * Ответ - событие sf:age-gate на document с detail { action: 'confirm' | 'decline' }; по «Да» окно убирается.
 * Ответ запоминает сайт. */
(() => {
    const gate = document.querySelector('[data-sf-age-gate]');
    if (!gate) {
        return;
    }
    const root = document.documentElement;
    const overflow = root.style.overflow;
    root.style.overflow = 'hidden';
    const items = () => [...gate.querySelectorAll('button:not([disabled]), a[href]:not([tabindex="-1"])')];
    items()[0]?.focus();

    gate.addEventListener('keydown', (event) => {
        if (event.key !== 'Tab') {
            return;
        }
        const list = items();
        const first = list[0];
        const last = list[list.length - 1];
        if (event.shiftKey && document.activeElement === first) {
            event.preventDefault();
            last.focus();
        } else if (!event.shiftKey && document.activeElement === last) {
            event.preventDefault();
            first.focus();
        }
    });

    gate.addEventListener('click', (event) => {
        const action = event.target.closest?.('[data-sf-age-gate-action]')?.getAttribute('data-sf-age-gate-action');
        if (!action) {
            return;
        }
        document.dispatchEvent(new CustomEvent('sf:age-gate', { detail: { action } }));
        if (action === 'confirm') {
            root.style.overflow = overflow;
            gate.remove();
        }
    });
})();
