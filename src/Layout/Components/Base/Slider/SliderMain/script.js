/*
 * Слайдер (SliderMain) на swiper: ряд [data-sf-slider-viewport] (.swiper), стрелки [data-sf-slider-prev|next] листают
 * на экран и отключаются у края, индикатор шагов (.step-indicator) показывает долю прокрутки, свайп и перетаскивание
 * мышью — swiper, в ряду с фокусом — стрелки, PageUp/PageDown, Home/End. Зазор между карточками — column-gap ряда.
 * При prefers-reduced-motion листание без анимации. Экземпляр swiper — root.sfSlider.
 */
(() => {
    if (window.SimflexSliderReady) {
        return;
    }
    window.SimflexSliderReady = true;

    const reduced = () => window.matchMedia?.('(prefers-reduced-motion: reduce)').matches;
    const speed = () => (reduced() ? 0 : (window.SfUi?.motionMs?.(null, '--motion-slow', 240) ?? 240) + 160);

    const init = (root, final = false) => {
        const viewport = root.querySelector('[data-sf-slider-viewport]');
        if (!viewport || root.sfSlider) {
            return;
        }
        const prevBtn = root.querySelector('[data-sf-slider-prev]');
        const nextBtn = root.querySelector('[data-sf-slider-next]');
        const bars = [...root.querySelectorAll('.step-indicator__item')];
        const counter = root.querySelector('.step-indicator .visually-hidden');
        const gap = () => parseFloat(getComputedStyle(viewport).columnGap) || 0;
        const perPage = (swiper) => Math.max(1, Math.floor((swiper.width + gap()) / ((swiper.slides[0]?.offsetWidth || 1) + gap()) + 0.01));

        const setDisabled = (btn, off) => {
            if (!btn) {
                return;
            }
            const hadFocus = off && !btn.disabled && btn === document.activeElement;
            btn.disabled = off;
            if (off) {
                btn.setAttribute('aria-disabled', 'true');
            } else {
                btn.removeAttribute('aria-disabled');
            }
            // disabled выбросил бы фокус в body: на ряд
            if (hadFocus) {
                viewport.focus({preventScroll: true});
            }
        };

        const update = (swiper) => {
            setDisabled(prevBtn, swiper.isBeginning);
            setDisabled(nextBtn, swiper.isEnd);
            if (bars.length) {
                const p = Math.min(1, Math.max(0, swiper.progress || 0));
                const active = Math.round(p * (bars.length - 1));
                bars.forEach((bar, i) => bar.classList.toggle('step-indicator__item_active', i === active));
                if (counter) {
                    counter.textContent = `${active + 1} / ${bars.length}`;
                }
            }
        };

        // swiper.js подключается раньше скрипта компонента (PageAssets, idx 50); если его нет — ряд просто прокручивается
        if (typeof window.Swiper !== 'function') {
            if (final) {
                viewport.style.overflowX = 'auto';
            }
            return;
        }
        viewport.style.removeProperty('overflow-x');

        const swiper = new window.Swiper(viewport, {
            slidesPerView: 'auto',
            spaceBetween: gap(),
            speed: speed(),
            grabCursor: true,
            watchOverflow: true,
            a11y: {enabled: false},
            on: {
                init: update,
                progress: update,
                resize(s) {
                    s.params.spaceBetween = gap();
                    s.update();
                    update(s);
                },
            },
        });
        root.sfSlider = swiper;

        const page = (dir) => {
            const target = Math.max(0, Math.min(swiper.slides.length - 1, swiper.activeIndex + dir * perPage(swiper)));
            swiper.params.speed = speed();
            swiper.slideTo(target);
        };
        prevBtn?.addEventListener('click', () => page(-1));
        nextBtn?.addEventListener('click', () => page(1));

        viewport.addEventListener('keydown', (event) => {
            if (event.target !== viewport) {
                return;
            }
            const last = swiper.slides.length - 1;
            const keys = {
                ArrowRight: () => swiper.slideTo(Math.min(last, swiper.activeIndex + 1)),
                ArrowLeft: () => swiper.slideTo(Math.max(0, swiper.activeIndex - 1)),
                PageDown: () => page(1),
                PageUp: () => page(-1),
                Home: () => swiper.slideTo(0),
                End: () => swiper.slideTo(last),
            };
            if (keys[event.key]) {
                event.preventDefault();
                keys[event.key]();
            }
        });

        // фокус на карточке за краем — ряд доезжает до неё
        viewport.addEventListener('focusin', (event) => {
            const slide = event.target.closest?.('.swiper-slide');
            const index = slide ? swiper.slides.indexOf(slide) : -1;
            if (index >= 0 && !slide.classList.contains('swiper-slide-visible')) {
                const rect = slide.getBoundingClientRect();
                const box = viewport.getBoundingClientRect();
                if (rect.left < box.left || rect.right > box.right) {
                    swiper.slideTo(index);
                }
            }
        });
    };

    const start = (final = false) => document.querySelectorAll('[data-sf-slider]').forEach((root) => init(root, final));
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => start());
    } else {
        start();
    }
    // swiper мог загрузиться позже (defer): повтор после загрузки страницы
    window.addEventListener('load', () => start(true));
})();
