/*
 * Подсказки (Tooltip): показ по наведению и фокусу — в CSS; здесь Esc прячет открытую подсказку, а на тач-устройствах
 * подсказка открывается и закрывается нажатием на элемент
 */
(() => {
    const WRAP = '[data-sf-tooltip]';

    document.addEventListener('keydown', (event) => {
        if (event.key !== 'Escape') {
            return;
        }
        document.querySelectorAll(`${WRAP}:hover, ${WRAP}:focus-within, ${WRAP}.tooltip-wrap_open`).forEach((wrap) => {
            wrap.classList.remove('tooltip-wrap_open');
            wrap.classList.add('tooltip-wrap_closed');
        });
    });

    // после ухода курсора и фокуса подсказка снова показывается как обычно
    const reset = (event) => {
        const wrap = event.target.closest?.(WRAP);
        if (wrap && !wrap.matches(':hover') && !wrap.contains(document.activeElement)) {
            wrap.classList.remove('tooltip-wrap_closed', 'tooltip-wrap_open');
        }
    };
    document.addEventListener('pointerout', reset);
    document.addEventListener('focusout', (event) => setTimeout(() => reset(event)));

    document.addEventListener('pointerup', (event) => {
        if (event.pointerType !== 'touch') {
            return;
        }
        const wrap = event.target.closest(WRAP);
        document.querySelectorAll(`${WRAP}.tooltip-wrap_open`).forEach((open) => open !== wrap && open.classList.remove('tooltip-wrap_open'));
        wrap?.classList.toggle('tooltip-wrap_open');
    });
})();
