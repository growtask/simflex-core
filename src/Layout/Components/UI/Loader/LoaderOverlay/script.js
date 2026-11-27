/*
 * Подложка загрузки (LoaderOverlay): SfUi.loaderOverlay(el, on) включает и выключает вуаль над блоком —
 * класс loader-overlay_active и aria-busy; вуаль появляется проявлением, уходит быстрее (style.scss).
 * el — корень .loader-overlay или элемент внутри него.
 */
(() => {
    const SfUi = window.SfUi = window.SfUi || {};
    if (SfUi.loaderOverlay) {
        return;
    }
    SfUi.loaderOverlay = (el, on = true) => {
        const root = el?.closest?.('.loader-overlay');
        if (!root || root.classList.contains('loader-overlay_active') === on) {
            return;
        }
        const scrim = root.querySelector(':scope > .loader-overlay__scrim');
        if (on) {
            root.classList.add('loader-overlay_active');
            root.setAttribute('aria-busy', 'true');
            return;
        }
        root.removeAttribute('aria-busy');
        if (!scrim || !SfUi.transition) {
            root.classList.remove('loader-overlay_active');
            return;
        }
        SfUi.transition(scrim, 'loader-overlay', false).then(() => {
            scrim.hidden = false;
            if (!root.hasAttribute('aria-busy')) {
                root.classList.remove('loader-overlay_active');
            }
        });
    };
})();
