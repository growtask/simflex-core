/*
 * Степпер (Stepper): кнопки меняют значение на шаг в пределах min/max, ввод вне диапазона приводится к границе
 * при уходе из поля; на границах кнопки недоступны. Изменение — события input и change на поле
 */
(() => {
    const ROOT = '[data-sf-stepper]';

    const getLimits = (input) => ({
        min: input.hasAttribute('min') ? Number(input.getAttribute('min')) : -Infinity,
        max: input.hasAttribute('max') ? Number(input.getAttribute('max')) : Infinity,
        step: Number(input.getAttribute('step')) || 1,
    });

    const update = (root) => {
        const input = root.querySelector('.stepper__input');
        const {min, max} = getLimits(input);
        const value = Number(input.value);
        const isLocked = input.readOnly || input.disabled;
        root.querySelector('[data-sf-stepper-step="-1"]').disabled = isLocked || value <= min;
        root.querySelector('[data-sf-stepper-step="1"]').disabled = isLocked || value >= max;
    };

    const setValue = (root, value) => {
        const input = root.querySelector('.stepper__input');
        const {min, max, step} = getLimits(input);
        const decimals = (String(step).split('.')[1] ?? '').length;
        const clamped = Math.min(Math.max(Number.isFinite(value) ? value : (min > -Infinity ? min : 0), min), max);
        const next = clamped.toFixed(decimals);
        const changed = input.value !== next;
        input.value = next;
        update(root);
        if (changed) {
            input.dispatchEvent(new Event('input', {bubbles: true}));
            input.dispatchEvent(new Event('change', {bubbles: true}));
        }
    };

    document.addEventListener('click', (event) => {
        const button = event.target.closest?.('[data-sf-stepper-step]');
        const root = button?.closest(ROOT);
        if (!root || button.disabled) {
            return;
        }
        const input = root.querySelector('.stepper__input');
        setValue(root, Number(input.value) + Number(button.dataset.sfStepperStep) * getLimits(input).step);
    });

    // ввод: значение приводится при уходе из поля (change), стрелки вверх и вниз — шаг
    document.addEventListener('change', (event) => {
        const root = event.target.matches?.('.stepper__input') && event.target.closest(ROOT);
        if (root) {
            setValue(root, parseFloat(event.target.value.replace(',', '.')));
        }
    }, true);

    document.addEventListener('keydown', (event) => {
        const root = event.target.matches?.('.stepper__input') && event.target.closest(ROOT);
        if (root && ['ArrowUp', 'ArrowDown'].includes(event.key) && !event.target.readOnly) {
            event.preventDefault();
            const {step} = getLimits(event.target);
            setValue(root, Number(event.target.value) + (event.key === 'ArrowUp' ? step : -step));
        }
    });
})();
