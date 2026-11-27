/*
 * Цена-панель (PriceMain, style Sticky): видна внизу экрана телефона, пока блок цены страницы (id в
 * data-sf-price-sticky) не на экране; без id — всегда. Для скринридера панель скрыта, пока не видна (aria-hidden).
 */
(() => {
    if (window.SimflexPriceReady) {
        return;
    }
    window.SimflexPriceReady = true;

    const init = (bar) => {
        const setShown = (shown) => {
            bar.classList.toggle('price_sticky-shown', shown);
            bar.setAttribute('aria-hidden', shown ? 'false' : 'true');
            bar.inert = !shown;
        };
        const target = bar.dataset.sfPriceSticky ? document.getElementById(bar.dataset.sfPriceSticky) : null;
        if (!target || typeof IntersectionObserver !== 'function') {
            setShown(true);
            return;
        }
        new IntersectionObserver((entries) => {
            const entry = entries[entries.length - 1];
            // блок цены ниже экрана (ещё не дошли) или выше (прошли) — панель видна
            setShown(!entry.isIntersecting);
        }).observe(target);
    };

    const start = () => document.querySelectorAll('[data-sf-price-sticky]').forEach((bar) => {
        if (!bar.dataset.sfPriceReady) {
            bar.dataset.sfPriceReady = '1';
            init(bar);
        }
    });
    document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', start) : start();
})();
