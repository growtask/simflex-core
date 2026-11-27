/**
 * Общий JS компонентов Layout (подключается на всех страницах раньше script.js компонентов). Без зависимостей.
 *
 * window.SfUi:
 *   reduced()                 - включён prefers-reduced-motion
 *   motionMs(el, name, def)   - длительность токена движения (--motion-base и т. п.) в мс
 *   finePointer()             - мышь (hover и точный указатель)
 *   hoverGrow(el, opts)       - увеличение при наведении и уменьшение при нажатии (--sf-grow, --sf-press)
 *   buttonLoad(btn, on)       - загрузка кнопки ButtonMain: спиннер, aria-busy, морф в круг
 *   buttonResult(btn, type)   - результат после загрузки: 'success' | 'error' на ~900 мс
 *
 * html.sf-kbd - последний ввод с клавиатуры: кольца фокуса полей и открытие меню по фокусу только в этом режиме
 * (мышь и касание снимают класс). Кнопки, кнопки соцсетей и меню увеличиваются при наведении сами (делегирование),
 * у primary и accent при нажатии из точки нажатия (с клавиатуры - из центра) расходится свечение.
 */
(() => {
    if (window.SfUi && window.SfUi.core) {
        return;
    }
    const SfUi = window.SfUi = window.SfUi || {};
    SfUi.core = true;

    const root = document.documentElement;
    const media = (query) => (window.matchMedia ? window.matchMedia(query) : null);

    SfUi.reduced = () => Boolean(media('(prefers-reduced-motion: reduce)')?.matches);
    SfUi.finePointer = () => Boolean(media('(hover: hover) and (pointer: fine)')?.matches);
    SfUi.cssVar = (el, name, fallback = '') => getComputedStyle(el || root).getPropertyValue(name).trim() || fallback;
    SfUi.motionMs = (el, name, fallback = 0) => {
        const value = SfUi.cssVar(el, name);
        if (!value) {
            return fallback;
        }
        const number = parseFloat(value);
        return Number.isNaN(number) ? fallback : (value.endsWith('ms') ? number : number * 1000);
    };

    /*----------КЛАВИАТУРНЫЙ РЕЖИМ (html.sf-kbd)-----------*/
    const KEYS = ['Tab', 'ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'Home', 'End', 'PageUp', 'PageDown',
        'Enter', ' ', 'Escape'];
    document.addEventListener('keydown', (event) => {
        if (!event.metaKey && !event.ctrlKey && !event.altKey && KEYS.includes(event.key)) {
            root.classList.add('sf-kbd');
        }
    }, true);
    document.addEventListener('pointerdown', () => root.classList.remove('sf-kbd'), true);

    /*----------УВЕЛИЧЕНИЕ ПРИ НАВЕДЕНИИ И УМЕНЬШЕНИЕ ПРИ НАЖАТИИ-----------*/
    // кнопка растёт не больше чем на px с каждой стороны и не выходит за край обрезающего контейнера;
    // сам scale задают стили (:hover - var(--sf-grow), :active - var(--sf-press))
    const clipBox = (el) => {
        for (let p = el.parentElement; p && p !== document.body && p !== root; p = p.parentElement) {
            const cs = getComputedStyle(p);
            if (cs.overflowX !== 'visible' || cs.overflowY !== 'visible' || /paint|strict|content/.test(cs.contain)) {
                const r = p.getBoundingClientRect();
                const left = r.left + p.clientLeft;
                const top = r.top + p.clientTop;
                return {left, top, right: left + p.clientWidth, bottom: top + p.clientHeight};
            }
        }
        return {left: 0, top: -Infinity, right: root.clientWidth, bottom: Infinity};
    };

    const setPress = (el, {pressPx = 0.75, minPress = 0.985} = {}) => {
        const w = el.offsetWidth;
        const h = el.offsetHeight;
        if (w && h) {
            el.style.setProperty('--sf-press', Math.max(minPress, 1 - (2 * pressPx) / Math.max(w, h)).toFixed(4));
        }
    };

    const setGrow = (el, {max = 1.015, px = 1} = {}) => {
        const w = el.offsetWidth;
        const h = el.offsetHeight;
        if (!w || !h) {
            return;
        }
        let scale = Math.min(max, 1 + (2 * px) / w, 1 + (2 * px) / h);
        const r = el.getBoundingClientRect();
        const cx = r.left + r.width / 2;
        const cy = r.top + r.height / 2;
        const box = clipBox(el);
        const room = Math.min(2 * Math.min(cx - box.left, box.right - cx) / w, 2 * Math.min(cy - box.top, box.bottom - cy) / h);
        scale = Math.max(1, Math.min(scale, room));
        el.style.setProperty('--sf-grow', scale.toFixed(4));
    };

    SfUi.hoverGrow = (el, opts = {}) => {
        const enabled = opts.enabled || (() => true);
        const onEnter = (event) => {
            setPress(el, opts);
            if (event.pointerType !== 'touch' && SfUi.finePointer() && !SfUi.reduced() && enabled()) {
                setGrow(el, opts);
            }
        };
        const onPress = () => setPress(el, opts);
        el.addEventListener('pointerenter', onEnter);
        el.addEventListener('pointerdown', onPress);
        el.addEventListener('focus', onPress);
        return {
            destroy() {
                el.removeEventListener('pointerenter', onEnter);
                el.removeEventListener('pointerdown', onPress);
                el.removeEventListener('focus', onPress);
                el.style.removeProperty('--sf-grow');
                el.style.removeProperty('--sf-press');
            },
        };
    };

    // делегирование: кнопки Layout (data-sf-grow="false" - без увеличения, только нажатие)
    const GROW = '.btn, .btn-social, .social';
    const PRESS = '.btn-menu';
    document.addEventListener('pointerover', (event) => {
        const el = event.target.closest?.(`${GROW}, ${PRESS}`);
        if (!el || (event.relatedTarget && el.contains(event.relatedTarget))) {
            return;
        }
        setPress(el);
        if (el.matches(GROW) && el.dataset.sfGrow !== 'false' && event.pointerType !== 'touch'
            && SfUi.finePointer() && !SfUi.reduced()) {
            setGrow(el);
        }
    });
    document.addEventListener('focusin', (event) => {
        const el = event.target.closest?.(`${GROW}, ${PRESS}`);
        if (el) {
            setPress(el);
        }
    });

    /*----------СВЕЧЕНИЕ НАЖАТИЯ (primary, accent)-----------*/
    const glowAt = (btn, x, y) => {
        let layer = btn.querySelector(':scope > .btn__glow');
        if (!layer) {
            layer = document.createElement('span');
            layer.className = 'btn__glow';
            layer.setAttribute('aria-hidden', 'true');
            btn.prepend(layer);
        }
        const w = layer.clientWidth;
        const h = layer.clientHeight;
        const r = Math.hypot(Math.max(x, w - x), Math.max(y, h - y));
        const dot = document.createElement('span');
        dot.className = 'btn__glow-dot';
        dot.style.cssText = `left:${x - r}px;top:${y - r}px;width:${2 * r}px;height:${2 * r}px`;
        layer.append(dot);
        if (!dot.animate) {
            dot.remove();
            return;
        }
        const animation = dot.animate([
            {transform: 'scale(0.12)', opacity: 0},
            {opacity: 1, offset: 0.18},
            {transform: 'scale(1)', opacity: 0},
        ], {duration: 650, easing: 'cubic-bezier(0.2, 0, 0, 1)', fill: 'forwards'});
        animation.onfinish = () => dot.remove();
        animation.oncancel = () => dot.remove();
        setTimeout(() => dot.remove(), 800);
    };

    const GLOW = '.btn-primary, .btn-accent';
    const canGlow = (btn) => btn && !btn.matches(':disabled, [aria-disabled="true"], .loading, .btn_result, .btn-state_success, .btn-state_error')
        && btn.dataset.sfGlow !== 'false' && !SfUi.reduced();

    document.addEventListener('pointerdown', (event) => {
        const btn = event.target.closest?.(GLOW);
        if (canGlow(btn) && event.button === 0) {
            const r = btn.getBoundingClientRect();
            glowAt(btn, event.clientX - r.left, event.clientY - r.top);
        }
    });
    document.addEventListener('keydown', (event) => {
        if ((event.key === 'Enter' || event.key === ' ') && !event.repeat) {
            const btn = event.target.closest?.(GLOW);
            if (canGlow(btn) && btn === event.target) {
                glowAt(btn, btn.clientWidth / 2, btn.clientHeight / 2);
            }
        }
    });

    /*----------ЗАГРУЗКА И РЕЗУЛЬТАТ КНОПКИ-----------*/
    const MORPH_MS = 320;
    const RESULT_MS = 900;
    const RESULT_ICONS = {
        success: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path pathLength="1" d="M5.5 12.5l4.25 4.25L18.5 8"/></svg>',
        error: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path pathLength="1" d="M7 7l10 10"/><path pathLength="1" d="M17 7L7 17"/></svg>',
    };
    const timers = new WeakMap();
    const clearTimer = (btn) => {
        clearTimeout(timers.get(btn));
        timers.delete(btn);
    };

    // морф только у кнопки со спиннером по центру: без текста или текст без боковых иконок
    const canMorph = (btn) => btn.dataset.sfMorph !== 'false' && !SfUi.reduced()
        && !btn.querySelector('.btn__icon_left, .btn__icon_right');

    const ensureLoader = (btn) => {
        if (!btn.querySelector(':scope > .btn__loader')) {
            const loader = document.createElement('span');
            loader.className = 'btn__loader';
            loader.setAttribute('aria-hidden', 'true');
            loader.innerHTML = '<svg class="loader-icon" viewBox="0 0 40 40"><circle class="loader-icon__track" cx="20" cy="20" r="18" pathlength="100" stroke-width="4" fill="none" stroke="currentColor"/><circle class="loader-icon__car" cx="20" cy="20" r="18" pathlength="100" fill="none" stroke="currentColor"/></svg>';
            btn.append(loader);
        }
    };

    SfUi.buttonLoad = (btn, on = true) => {
        if (!btn) {
            return;
        }
        clearTimer(btn);
        btn.classList.remove('btn_result');
        if (on) {
            ensureLoader(btn);
            btn.classList.add('loading');
            btn.setAttribute('aria-busy', 'true');
            if (canMorph(btn)) {
                const w = btn.offsetWidth;
                const h = btn.offsetHeight;
                btn.style.setProperty('--btn-morph-x', `${Math.max(0, (w - h) / 2)}px`);
                btn.style.setProperty('--btn-morph-r', getComputedStyle(btn).borderTopLeftRadius);
                btn.style.setProperty('--btn-morph-round', `${h / 2}px`);
                btn.classList.add('btn_morph');
                // сначала контур кнопки (точка отсчёта перехода clip-path), кадром позже - круг
                SfUi.nextFrame(() => {
                    if (btn.classList.contains('loading')) {
                        btn.classList.add('btn_morph-shrink');
                    }
                });
            }
            return;
        }
        btn.classList.remove('loading', 'btn_morph-shrink');
        btn.removeAttribute('aria-busy');
        timers.set(btn, setTimeout(() => btn.classList.remove('btn_morph'), MORPH_MS));
    };

    SfUi.buttonResult = (btn, type) => {
        if (!btn || !RESULT_ICONS[type]) {
            SfUi.buttonLoad(btn, false);
            return;
        }
        clearTimer(btn);
        btn.classList.remove('loading', 'btn_morph-shrink');
        btn.removeAttribute('aria-busy');
        let mark = btn.querySelector(':scope > .btn__result');
        if (!mark) {
            mark = document.createElement('span');
            mark.className = 'btn__result';
            mark.setAttribute('aria-hidden', 'true');
            btn.append(mark);
        }
        mark.innerHTML = RESULT_ICONS[type];
        btn.classList.add('btn_result', `btn_result-${type}`);
        timers.set(btn, setTimeout(() => {
            btn.classList.remove('btn_result', 'btn_result-success', 'btn_result-error', 'btn_morph');
            timers.delete(btn);
        }, SfUi.reduced() ? RESULT_MS / 2 : RESULT_MS));
    };

    /*----------СКОЛЬЗЯЩИЙ ИНДИКАТОР (вкладки, селектор)-----------*/
    /*
     * SfUi.glide(el, layerClass, isOn, animate = true): el стал активным; если в том же родителе до этого был активен
     * другой элемент, слой layerClass (окраска - в CSS, как у активного) едет FLIP-ом от прежнего к новому (пружина).
     * На время полёта: родитель [data-sf-glide], el [data-glide="move"|"land"], прежний [data-glide-from].
     * animate=false - только запомнить активный. SfUi.glide.release(el) - элемент уходит из DOM.
     * SfUi.glideGroup(container, selector, layerClass) - запомнить активные элементы группы при загрузке.
     */
    const groups = new WeakMap(); // родитель → { el, parent, isOn, from, layer, anim, timers }
    const DURATION = 560;
    let spring = null;
    // пружина с лёгким перелётом (~5 %): затухающее колебание ζ = 0.68 → linear(); без поддержки linear() — ease-out
    const springEasing = () => {
        if (spring) return spring;
        const zeta = 0.68;
        const omega = 6.9 / zeta; // к концу отрезка амплитуда < 0.1 %
        const wd = omega * Math.sqrt(1 - zeta * zeta);
        const points = [];
        for (let i = 0; i <= 48; i++) {
            const u = i / 48;
            const x = i === 48 ? 1 : 1 - Math.exp(-zeta * omega * u) * (Math.cos(wd * u) + (zeta * omega / wd) * Math.sin(wd * u));
            points.push(+x.toFixed(4));
        }
        const value = `linear(${points.join(', ')})`;
        spring = window.CSS && CSS.supports && CSS.supports('transition-timing-function', value) ? value : 'cubic-bezier(0.2, 0, 0, 1)';
        return spring;
    };
    const reduced = SfUi.reduced;

    // остановить полёт записи и снять все её следы
    const stop = (entry, keepParent = false) => {
        entry.timers.forEach(clearTimeout);
        entry.timers = [];
        if (entry.anim) {
            const anim = entry.anim;
            entry.anim = null;
            anim.cancel();
        }
        if (entry.layer) entry.layer.remove();
        entry.layer = null;
        entry.el.removeAttribute('data-glide');
        if (entry.from) entry.from.removeAttribute('data-glide-from');
        entry.from = null;
        if (!keepParent) entry.parent.removeAttribute('data-sf-glide');
    };

    SfUi.glide = (el, layerClass, isOn, animate = true) => {
        const parent = el && el.parentElement;
        if (!parent) return;
        const prev = groups.get(parent);
        const entry = { el, parent, isOn, from: null, layer: null, anim: null, timers: [] };
        groups.set(parent, entry);
        if (!prev) return;
        if (prev.el === el) {
            stop(prev);
            return;
        }
        // прежний ещё активен — это другая группа в том же родителе: не связываем
        const prevAlive = prev.el.isConnected && prev.el.parentElement === parent && !prev.isOn();
        if (!animate || !prevAlive || reduced() || typeof el.animate !== 'function') {
            if (!prevAlive && prev.el.isConnected && prev.isOn()) return;
            stop(prev);
            return;
        }
        // атрибуты — до первого чтения раскладки: смена окраски попадает в тот же пересчёт стилей, без переходов
        parent.setAttribute('data-sf-glide', '');
        el.setAttribute('data-glide', 'move');
        prev.el.setAttribute('data-glide-from', '');
        // перехват на лету — старт от текущего положения летящего слоя
        const from = (prev.layer && prev.layer.isConnected ? prev.layer : prev.el).getBoundingClientRect();
        const fromEl = prev.el;
        stop(prev, true);
        fromEl.setAttribute('data-glide-from', '');
        entry.from = fromEl;
        const to = el.getBoundingClientRect();
        if (!from.width || !from.height || !to.width || !to.height) {
            stop(entry);
            return;
        }

        const cs = getComputedStyle(el);
        const bw = ['Top', 'Right', 'Bottom', 'Left'].map((s) => parseFloat(cs[`border${s}Width`]) || 0);
        const radius = parseFloat(cs.borderTopLeftRadius) || 0;
        const layer = document.createElement('span');
        layer.className = layerClass;
        layer.setAttribute('aria-hidden', 'true');
        layer.style.inset = bw.map((v) => `${-v}px`).join(' ');
        layer.style.transformOrigin = '0 0';
        el.appendChild(layer);
        entry.layer = layer;

        const dx = from.left - to.left;
        const dy = from.top - to.top;
        const sx = from.width / to.width;
        const sy = from.height / to.height;
        // FLIP: translate + scale; скругление делится на масштаб, чтобы углы не искажались в полёте (толщину рамки
        // так не поправить — браузер округляет её до целых пикселей; искажение 2 px рамки на время полёта незаметно)
        const frames = [];
        for (let i = 0; i <= 6; i++) {
            const p = i / 6;
            const kx = sx + (1 - sx) * p;
            const ky = sy + (1 - sy) * p;
            const frame = {
                offset: p,
                transform: `translate(${dx * (1 - p)}px, ${dy * (1 - p)}px) scale(${kx}, ${ky})`,
            };
            if (radius) frame.borderRadius = `${radius / kx}px / ${radius / ky}px`;
            frames.push(frame);
        }
        const anim = layer.animate(frames, { duration: DURATION, easing: springEasing() });
        entry.anim = anim;
        // ближе к концу пути возвращается свой цвет текста (переход fast), окраска — после прилёта
        entry.timers.push(setTimeout(() => { if (entry.anim === anim) el.setAttribute('data-glide', 'land'); }, DURATION * 0.3));
        // страховка: если шкала анимаций стоит (фоновая вкладка), полёт завершается по таймеру
        entry.timers.push(setTimeout(() => { if (entry.anim === anim) anim.finish(); }, DURATION + 400));
        anim.finished.then(() => {
            if (entry.anim !== anim) return;
            entry.anim = null;
            el.removeAttribute('data-glide');
            if (entry.from) entry.from.removeAttribute('data-glide-from');
            entry.from = null;
            // своя окраска проявляется под слоем того же цвета (fast), затем слой гаснет и уходит
            entry.timers.push(setTimeout(() => {
                if (entry.layer === layer) layer.animate([{ opacity: 1 }, { opacity: 0 }], { duration: 140, easing: 'ease-out', fill: 'forwards' });
            }, 160));
            entry.timers.push(setTimeout(() => {
                if (entry.layer !== layer) return;
                layer.remove();
                entry.layer = null;
                if (groups.get(parent) === entry) parent.removeAttribute('data-sf-glide');
            }, 320));
        }, () => {});
    };

    // элемент размонтируется: снять его полёт и запись группы (иначе таймеры, слой и [data-sf-glide] остаются)
    SfUi.glide.release = (el) => {
        const parent = el && el.parentElement;
        if (!parent) return;
        const entry = groups.get(parent);
        if (!entry) return;
        if (entry.el === el) {
            stop(entry);
            groups.delete(parent);
        } else if (entry.from === el) {
            el.removeAttribute('data-glide-from');
            entry.from = null;
        }
    };

    SfUi.glideGroup = (container, selector, layerClass) => {
        container.querySelectorAll(selector).forEach((el) => {
            if (el.classList.contains('active') || el.getAttribute('aria-selected') === 'true') {
                SfUi.glide(el, layerClass, () => el.classList.contains('active'), false);
            }
        });
    };

    /** Следующий кадр после отрисовки (два requestAnimationFrame); в фоновой вкладке кадров нет - запасной таймер */
    SfUi.nextFrame = (callback) => {
        let called = false;
        const run = () => {
            if (!called) {
                called = true;
                callback();
            }
        };
        requestAnimationFrame(() => requestAnimationFrame(run));
        setTimeout(run, 50);
    };

    /*----------ПЕРЕХОДЫ ПОЯВЛЕНИЯ И СКРЫТИЯ-----------*/
    /*
     * SfUi.transition(el, name, show, done): показать или скрыть el с классами переходов, как у Vue <Transition>:
     * <name>-enter-from / -enter-active / -enter-to и <name>-leave-from / -leave-active / -leave-to (стили - в
     * style.scss компонентов). Показ снимает hidden сразу, скрытие ставит hidden после конца перехода.
     * Повторный вызов прерывает текущий переход. Возвращает Promise.
     */
    const running = new WeakMap();
    const STAGES = ['enter-from', 'enter-active', 'enter-to', 'leave-from', 'leave-active', 'leave-to'];
    SfUi.transition = (el, name, show, done) => new Promise((resolve) => {
        if (!el) {
            resolve();
            return;
        }
        running.get(el)?.();
        const clear = () => el.classList.remove(...STAGES.map((stage) => `${name}-${stage}`));
        const dir = show ? 'enter' : 'leave';
        clear();
        if (show) {
            el.hidden = false;
        }
        el.classList.add(`${name}-${dir}-from`, `${name}-${dir}-active`);
        let finished = false;
        let timer = 0;
        const finish = () => {
            if (finished) {
                return;
            }
            finished = true;
            clearTimeout(timer);
            el.removeEventListener('transitionend', onEnd);
            el.removeEventListener('animationend', onEnd);
            running.delete(el);
            clear();
            if (!show) {
                el.hidden = true;
            }
            done?.();
            resolve();
        };
        const onEnd = (event) => {
            if (event.target === el) {
                finish();
            }
        };
        running.set(el, () => {
            finished = true;
            clearTimeout(timer);
            el.removeEventListener('transitionend', onEnd);
            el.removeEventListener('animationend', onEnd);
            clear();
            resolve();
        });
        SfUi.nextFrame(() => {
            if (finished) {
                return;
            }
            el.classList.remove(`${name}-${dir}-from`);
            el.classList.add(`${name}-${dir}-to`);
            const cs = getComputedStyle(el);
            const longest = (durations, delays) => Math.max(0, ...durations.split(',').map((value, index) => {
                const delay = (delays.split(',')[index] ?? delays.split(',')[0]).trim();
                return parseFloat(value) * (value.trim().endsWith('ms') ? 1 : 1000)
                    + parseFloat(delay) * (delay.endsWith('ms') ? 1 : 1000);
            }));
            const total = Math.max(longest(cs.transitionDuration, cs.transitionDelay), longest(cs.animationDuration, cs.animationDelay));
            if (!total) {
                finish();
                return;
            }
            el.addEventListener('transitionend', onEnd);
            el.addEventListener('animationend', onEnd);
            timer = setTimeout(finish, total + 50);
        });
    });
})();
