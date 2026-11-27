/*
 * Степпер (Stepper): кнопки меняют значение на шаг в пределах min/max, ввод вне диапазона приводится к границе
 * при уходе из поля; на границах кнопки недоступны. Изменение — события input и change на поле.
 * Число принимается и с запятой («2,5»). Кнопка, которая под фокусом дошла до границы, не теряет фокус:
 * до ухода фокуса она aria-disabled="true" (нажатия игнорируются), затем — disabled.
 */
(() => {
    const ROOT = '[data-sf-stepper]';
    const STEP = '[data-sf-stepper-step]';

    const getLimits = (input) => ({
        min: input.hasAttribute('min') ? Number(input.getAttribute('min')) : -Infinity,
        max: input.hasAttribute('max') ? Number(input.getAttribute('max')) : Infinity,
        step: Number(input.getAttribute('step')) || 1,
    });

    // «2,5» → 2.5; пусто и мусор → NaN
    const parse = (value) => parseFloat(String(value).replace(',', '.'));

    const isOff = (button) => button.disabled || button.getAttribute('aria-disabled') === 'true';

    // недоступная кнопка под фокусом остаётся фокусируемой (иначе фокус уходит в body)
    const lock = (button, off) => {
        if (off && button === document.activeElement) {
            button.disabled = false;
            button.setAttribute('aria-disabled', 'true');
        } else {
            button.disabled = off;
            button.removeAttribute('aria-disabled');
        }
    };

    const update = (root) => {
        const input = root.querySelector('.stepper__input');
        const {min, max} = getLimits(input);
        const value = parse(input.value);
        const isLocked = input.readOnly || input.disabled;
        lock(root.querySelector('[data-sf-stepper-step="-1"]'), isLocked || value <= min);
        lock(root.querySelector('[data-sf-stepper-step="1"]'), isLocked || value >= max);
        // among: счётчик «текущее/всего»
        const counter = root.querySelector('[data-sf-stepper-counter]');
        if (counter) {
            counter.textContent = max === Infinity ? input.value : `${input.value}/${max}`;
        }
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
        const button = event.target.closest?.(STEP);
        const root = button?.closest(ROOT);
        if (!root || isOff(button)) {
            return;
        }
        const input = root.querySelector('.stepper__input');
        setValue(root, parse(input.value) + Number(button.dataset.sfStepperStep) * getLimits(input).step);
    });

    // фокус ушёл с кнопки на границе — теперь её можно выключить совсем
    document.addEventListener('focusout', (event) => {
        const button = event.target.closest?.(STEP);
        if (button?.closest(ROOT) && button.getAttribute('aria-disabled') === 'true') {
            button.removeAttribute('aria-disabled');
            button.disabled = true;
        }
    });

    // ввод: значение приводится при уходе из поля (change), стрелки вверх и вниз — шаг
    document.addEventListener('change', (event) => {
        const root = event.target.matches?.('.stepper__input') && event.target.closest(ROOT);
        if (root) {
            setValue(root, parse(event.target.value));
        }
    }, true);

    document.addEventListener('keydown', (event) => {
        const root = event.target.matches?.('.stepper__input') && event.target.closest(ROOT);
        if (root && ['ArrowUp', 'ArrowDown'].includes(event.key) && !event.target.readOnly) {
            event.preventDefault();
            const {step} = getLimits(event.target);
            setValue(root, parse(event.target.value) + (event.key === 'ArrowUp' ? step : -step));
        }
    });
})();
