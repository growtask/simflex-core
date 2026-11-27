/*
 * Аккордеон (Accordion): клик по пункту вне содержимого
 * или кнопка-шеврон (Enter/Space) переключают его; свои ссылки, кнопки и поля в заголовке, комментарии и бейдже
 * работают как обычно. Кнопка — aria-expanded (и класс active), закрытое содержимое — inert. Без data-multiple-open
 * (у пункта или у списка) открытие закрывает другие пункты того же списка (не всего документа).
 * Высота содержимого анимируется Web Animations от фактической текущей высоты (в т. ч. середины прерванной
 * анимации) к целевой: открытие — --motion-slow и --ease-out, закрытие — --motion-base и --ease-in-out; при
 * prefers-reduced-motion — без анимации. Проявление содержимого — opacity и transform в style.scss.
 * Разметка без id/aria (старые шаблоны) дополняется при запуске. Событие accordion:toggle ({detail: {open}}) на li.
 */
(() => {
    if (window.SimflexAccordionReady) {
        return;
    }
    window.SimflexAccordionReady = true;

    const ITEM = '.accordion';
    const INTERACTIVE = 'a[href], button, input, select, textarea, label, summary, [contenteditable=""], '
        + '[contenteditable="true"], [tabindex]';
    let counter = 0;

    const parts = (item) => ({
        button: item.querySelector(':scope > .accordion__header .accordion__button'),
        content: item.querySelector(':scope > .accordion__content'),
        title: item.querySelector(':scope > .accordion__header .accordion__title'),
    });

    /** id, роли и связи для разметки без них */
    const prepare = (item) => {
        const {button, content, title} = parts(item);
        if (!button || !content || item.dataset.sfAccordionReady) {
            return;
        }
        item.dataset.sfAccordionReady = '1';
        const base = (content.id || title?.id || `sf-accordion-js-${++counter}`).replace(/-(content|title)$/, '');
        content.id ||= `${base}-content`;
        if (title) {
            title.id ||= `${base}-title`;
            button.hasAttribute('aria-labelledby') || button.setAttribute('aria-labelledby', title.id);
            content.hasAttribute('aria-labelledby') || content.setAttribute('aria-labelledby', title.id);
        }
        item.querySelector(':scope > .accordion__header[role="tab"]')?.removeAttribute('role');
        content.setAttribute('role', 'region');
        button.setAttribute('aria-controls', content.id);
        sync(item, item.classList.contains('active'));
    };

    const sync = (item, open) => {
        const {button, content} = parts(item);
        item.classList.toggle('active', open);
        button.classList.toggle('active', open);
        button.setAttribute('aria-expanded', String(open));
        content.inert = !open;
    };

    const animations = new WeakMap();

    // плавная высота: от видимой сейчас к целевой (после смены класса)
    const animateHeight = (content, open, change) => {
        const from = content.getBoundingClientRect().height;
        animations.get(content)?.cancel();
        change();
        if (typeof content.animate !== 'function' || window.SfUi?.reduced?.()) {
            return;
        }
        const to = open ? content.scrollHeight : 0;
        if (Math.abs(to - from) < 1) {
            return;
        }
        const ms = (name, fallback) => window.SfUi?.motionMs?.(null, name, fallback) ?? fallback;
        const easing = getComputedStyle(document.documentElement).getPropertyValue(open ? '--ease-out' : '--ease-in-out').trim() || 'ease';
        const animation = content.animate([{height: `${from}px`, overflow: 'hidden'}, {height: `${to}px`, overflow: 'hidden'}], {
            duration: open ? ms('--motion-slow', 240) : ms('--motion-base', 180),
            easing,
        });
        animations.set(content, animation);
        animation.onfinish = () => animations.get(content) === animation && animations.delete(content);
    };

    const setOpen = (item, open) => {
        if (item.classList.contains('active') === open) {
            return;
        }
        animateHeight(parts(item).content, open, () => sync(item, open));
        item.dispatchEvent(new CustomEvent('accordion:toggle', {bubbles: true, detail: {open}}));
    };

    document.addEventListener('click', (event) => {
        const item = event.target.closest?.(ITEM);
        if (!item || !parts(item).button || parts(item).content.contains(event.target)) {
            return;
        }
        prepare(item);
        const control = event.target.closest(INTERACTIVE);
        if (control && item.contains(control) && control !== item && !control.classList.contains('accordion__button')) {
            return;
        }
        const open = !item.classList.contains('active');
        const list = item.parentElement;
        if (open && !item.hasAttribute('data-multiple-open') && !list?.hasAttribute('data-multiple-open')) {
            [...list.children].forEach((other) => {
                if (other !== item && other.matches(ITEM) && other.classList.contains('active')) {
                    prepare(other);
                    setOpen(other, false);
                }
            });
        }
        setOpen(item, open);
    });

    const init = () => document.querySelectorAll(ITEM).forEach(prepare);
    document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', init) : init();
})();
