/*
 * Блок тарифов (TariffList): переключатель периода (SelectorMain, событие sf-selector-change) показывает цены за
 * месяц или за год у всех тарифов (класс tariff-list_period_year). На планшете и телефоне (до 1024 px) ряд — слайдер
 * swiper с точками; на широком экране слайдер снимается.
 */
(() => {
    if (window.SimflexTariffListReady) {
        return;
    }
    window.SimflexTariffListReady = true;

    const SLIDER = '(max-width: 1023px)';

    const init = (root) => {
        root.addEventListener('sf-selector-change', (event) => {
            const year = event.detail?.value === 'year';
            root.classList.toggle('tariff-list_period_year', year);
            root.classList.toggle('tariff-list_period_month', !year);
        });

        const viewport = root.querySelector('[data-sf-tariff-viewport]');
        const dots = root.querySelector('[data-sf-tariff-dots]');
        let swiper = null;
        const media = window.matchMedia(SLIDER);
        const forced = root.classList.contains('tariff-list_view_mobile');
        const apply = () => {
            const want = (forced || media.matches) && typeof window.Swiper === 'function';
            if (want && !swiper) {
                root.classList.add('tariff-list_slider');
                swiper = new window.Swiper(viewport, {
                    slidesPerView: 'auto',
                    spaceBetween: 16,
                    centeredSlides: false,
                    pagination: {el: dots, clickable: true, bulletElement: 'button'},
                    speed: window.SfUi?.reduced?.() ? 0 : 400,
                });
            } else if (!want && swiper) {
                swiper.destroy(true, true);
                swiper = null;
                root.classList.remove('tariff-list_slider');
                dots.replaceChildren();
            }
        };
        media.addEventListener?.('change', apply);
        apply();
        if (!swiper) {
            window.addEventListener('load', apply, {once: true});
        }
    };

    const start = () => document.querySelectorAll('[data-sf-tariff-list]').forEach((root) => {
        if (!root.dataset.sfTariffReady) {
            root.dataset.sfTariffReady = '1';
            init(root);
        }
    });
    document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', start) : start();
})();
