/*
 * Подсказки (Tooltip): показ по наведению и фокусу — в CSS; здесь Esc прячет открытую подсказку, а на тач-устройствах
 * подсказка открывается и закрывается нажатием на элемент. Подсказка, которую обрезал бы предок с overflow
 * (прокрутка таблицы), показывается поверх (tooltip_fixed) на том же месте экрана
 */
(() => {
    const WRAP = '[data-sf-tooltip]';

    const getClipParent = (wrap) => {
        for (let node = wrap.parentElement; node && node !== document.body; node = node.parentElement) {
            const style = getComputedStyle(node);
            if (style.overflowX !== 'visible' || style.overflowY !== 'visible') {
                return node;
            }
        }
        return null;
    };

    const unfix = (tooltip) => {
        tooltip.classList.remove('tooltip_fixed');
        tooltip.style.removeProperty('top');
        tooltip.style.removeProperty('left');
    };

    // место считается по скрытой подсказке (visibility: hidden, размеры есть)
    const place = (event) => {
        const wrap = event.target.closest?.(WRAP);
        const tooltip = wrap?.querySelector(':scope > .tooltip');
        if (!tooltip) {
            return;
        }
        unfix(tooltip);
        const clip = getClipParent(wrap)?.getBoundingClientRect();
        const rect = tooltip.getBoundingClientRect();
        if (clip && (rect.top < clip.top || rect.bottom > clip.bottom || rect.left < clip.left
            || rect.right > clip.right)) {
            tooltip.classList.add('tooltip_fixed');
            tooltip.style.top = `${rect.top}px`;
            tooltip.style.left = `${rect.left}px`;
        }
    };
    document.addEventListener('pointerover', place);
    document.addEventListener('focusin', place);
    // поверх подсказка не едет вместе со страницей: при прокрутке — снова на месте элемента
    document.addEventListener('scroll', () => {
        document.querySelectorAll('.tooltip_fixed').forEach(unfix);
    }, true);

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
