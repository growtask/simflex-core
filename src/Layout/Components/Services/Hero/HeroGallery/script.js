/*
 * Галерея (HeroGallery) на swiper: миниатюры открывают картинку, на телефоне — свайп и индикатор; номер открытой —
 * aria-pressed у миниатюры и активная полоска индикатора. Стрелки ← → в галерее листают картинки
 */
(() => {
    if (window.SimflexHeroGalleryReady) {
        return;
    }
    window.SimflexHeroGalleryReady = true;

    const init = (root) => {
        const main = root.querySelector('[data-sf-hero-gallery-main]');
        if (!main || root.sfGallery || typeof window.Swiper !== 'function') {
            return;
        }
        const thumbs = [...root.querySelectorAll('[data-sf-hero-gallery-thumb]')];
        const bars = [...root.querySelectorAll('.hero-gallery__steps .step-indicator__item')];
        const mark = (index) => {
            thumbs.forEach((thumb, i) => {
                thumb.classList.toggle('hero-gallery__thumb_active', i === index);
                thumb.setAttribute('aria-pressed', i === index ? 'true' : 'false');
            });
            bars.forEach((bar, i) => bar.classList.toggle('step-indicator__item_active', i === index));
        };
        const swiper = new window.Swiper(main, {
            initialSlide: Number(root.dataset.active) || 0,
            spaceBetween: 12,
            speed: window.SfUi?.reduced?.() ? 0 : 400,
            keyboard: {enabled: true, onlyInViewport: true},
            on: {slideChange: (s) => mark(s.activeIndex)},
        });
        root.sfGallery = swiper;
        thumbs.forEach((thumb, i) => thumb.addEventListener('click', () => swiper.slideTo(i)));
    };

    const start = () => document.querySelectorAll('[data-sf-hero-gallery]').forEach(init);
    document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', start) : start();
    window.addEventListener('load', start);
})();
