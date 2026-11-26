/* Ползунок: ручки мышью, пальцем и стрелками, синхрон с полями, значение над нажатой ручкой, событие sf-range-change */
(() => {
    const num = (value, fallback) => {
        const parsed = parseFloat(String(value).replace(',', '.').replace(/\s/g, ''));
        return Number.isFinite(parsed) ? parsed : fallback;
    };

    const bounds = range => ({
        min: num(range.dataset.min, 0),
        max: num(range.dataset.max, 100),
        step: num(range.dataset.step, 1) || 1,
    });

    const dotOf = (range, key) => range.querySelector(`[data-range-dot="${key}"]`);
    const fieldOf = (range, key) => range.querySelector(`[data-range-field="${key}"]`);
    const isRange = range => range.classList.contains('range-type_range');

    const current = (range, key) => num(dotOf(range, key)?.getAttribute('aria-valuenow'), 0);

    // значение ручки: в шаг и в границы (ручка «от» не заходит за «до» и наоборот)
    const setValue = (range, key, raw, notify = true) => {
        const {min, max, step} = bounds(range);
        let value = Math.round((raw - min) / step) * step + min;
        value = Math.min(max, Math.max(min, value));
        value = Number(value.toFixed(6));
        if (isRange(range)) {
            value = key === 'from' ? Math.min(value, current(range, 'to')) : Math.max(value, current(range, 'from'));
        }
        const dot = dotOf(range, key);
        const percent = max > min ? (value - min) / (max - min) * 100 : 0;
        dot.style.left = `${percent}%`;
        dot.setAttribute('aria-valuenow', String(value));
        dot.querySelector('.range__tooltip').textContent = value.toLocaleString('ru-RU');
        const field = fieldOf(range, key);
        if (field && document.activeElement !== field) {
            field.value = String(value);
        }

        const fill = range.querySelector('.range__fill');
        const fromPercent = isRange(range) ? parseFloat(dotOf(range, 'from').style.left) || 0 : 0;
        const toPercent = parseFloat(dotOf(range, 'to').style.left) || 0;
        fill.style.left = `${fromPercent}%`;
        fill.style.right = `${100 - toPercent}%`;

        if (notify) {
            range.dispatchEvent(new CustomEvent('sf-range-change', {
                bubbles: true,
                detail: {from: isRange(range) ? current(range, 'from') : null, to: current(range, 'to')},
            }));
        }
        return value;
    };

    const valueAt = (range, clientX) => {
        const rail = range.querySelector('.range__rail').getBoundingClientRect();
        const {min, max} = bounds(range);
        const ratio = rail.width > 0 ? Math.min(1, Math.max(0, (clientX - rail.left) / rail.width)) : 0;
        return min + ratio * (max - min);
    };

    document.addEventListener('pointerdown', event => {
        const track = event.target.closest?.('.range__track');
        const range = track?.closest('.range');
        if (!range || range.classList.contains('range_disabled') || event.button > 0) {
            return;
        }
        const raw = valueAt(range, event.clientX);
        let dot = event.target.closest('.range__dot');
        if (!dot) {
            // щелчок по треку: ближайшая ручка (при равенстве — в сторону щелчка)
            const dots = [...range.querySelectorAll('.range__dot')];
            dot = dots.reduce((best, item) => {
                const distance = Math.abs(num(item.getAttribute('aria-valuenow'), 0) - raw);
                const bestDistance = Math.abs(num(best.getAttribute('aria-valuenow'), 0) - raw);
                return distance < bestDistance || (distance === bestDistance && raw > num(item.getAttribute('aria-valuenow'), 0)) ? item : best;
            });
            setValue(range, dot.dataset.rangeDot, raw);
        }
        event.preventDefault();
        dot.focus({preventScroll: true});
        dot.classList.add('range__dot_active');
        const move = moveEvent => setValue(range, dot.dataset.rangeDot, valueAt(range, moveEvent.clientX));
        const stop = () => {
            dot.classList.remove('range__dot_active');
            document.removeEventListener('pointermove', move);
            document.removeEventListener('pointerup', stop);
            document.removeEventListener('pointercancel', stop);
        };
        document.addEventListener('pointermove', move);
        document.addEventListener('pointerup', stop);
        document.addEventListener('pointercancel', stop);
    });

    document.addEventListener('keydown', event => {
        const dot = event.target.closest?.('.range__dot');
        const range = dot?.closest('.range');
        if (!dot || range.classList.contains('range_disabled')) {
            return;
        }
        const {min, max, step} = bounds(range);
        const now = num(dot.getAttribute('aria-valuenow'), min);
        const delta = {
            ArrowRight: step, ArrowUp: step, ArrowLeft: -step, ArrowDown: -step,
            PageUp: step * 10, PageDown: -step * 10,
        }[event.key];
        let next = delta === undefined ? null : now + delta;
        if (event.key === 'Home') {
            next = min;
        } else if (event.key === 'End') {
            next = max;
        }
        if (next !== null) {
            event.preventDefault();
            setValue(range, dot.dataset.rangeDot, next);
        }
    });

    // поля ввода двигают ручки: при вводе — на лету, при потере фокуса значение приводится к шагу и границам
    const fromField = event => {
        const field = event.target.closest?.('[data-range-field]');
        const range = field?.closest('.range');
        return range ? {field, range} : null;
    };

    document.addEventListener('input', event => {
        const found = fromField(event);
        if (found && found.field.value.trim() !== '') {
            setValue(found.range, found.field.dataset.rangeField, num(found.field.value, 0));
        }
    });

    document.addEventListener('focusout', event => {
        const found = fromField(event);
        if (!found) {
            return;
        }
        const key = found.field.dataset.rangeField;
        const value = found.field.value.trim() === '' ? current(found.range, key) : num(found.field.value, 0);
        found.field.value = String(setValue(found.range, key, value));
    });
})();
