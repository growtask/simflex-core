/* Полоса прокрутки: размер и положение ползунка, перетаскивание, щелчок по дорожке, стрелки */
(() => {
    const MIN_THUMB = 24;
    const ARROW_STEP = 48;

    const init = root => {
        if (root.dataset.scrollbarReady) {
            return;
        }
        root.dataset.scrollbarReady = '1';
        const vertical = root.classList.contains('scrollbar_vertical');
        const viewport = root.querySelector('.scrollbar__viewport');
        const track = root.querySelector('.scrollbar__track');
        const thumb = root.querySelector('.scrollbar__thumb');
        const metrics = () => vertical
            ? {view: viewport.clientHeight, total: viewport.scrollHeight, pos: viewport.scrollTop, track: track.clientHeight}
            : {view: viewport.clientWidth, total: viewport.scrollWidth, pos: viewport.scrollLeft, track: track.clientWidth};
        const scrollTo = value => viewport.scrollTo(vertical ? {top: value} : {left: value});

        const update = () => {
            const m = metrics();
            const scrollable = m.total - m.view > 1;
            root.classList.toggle('scrollbar_scrollable', scrollable);
            if (!scrollable || m.track <= 0) {
                return;
            }
            const length = Math.max(MIN_THUMB, Math.round(m.track * m.view / m.total));
            const offset = (m.track - length) * (m.pos / (m.total - m.view));
            thumb.style[vertical ? 'height' : 'width'] = `${length}px`;
            thumb.style.transform = vertical ? `translateY(${offset}px)` : `translateX(${offset}px)`;
        };

        root.classList.add('scrollbar_ready');
        viewport.addEventListener('scroll', update, {passive: true});
        if ('ResizeObserver' in window) {
            const observer = new ResizeObserver(update);
            observer.observe(viewport);
            [...viewport.children].forEach(child => observer.observe(child));
        } else {
            window.addEventListener('resize', update);
        }

        thumb.addEventListener('pointerdown', event => {
            event.preventDefault();
            event.stopPropagation();
            thumb.setPointerCapture(event.pointerId);
            root.classList.add('scrollbar_dragging');
            const start = vertical ? event.clientY : event.clientX;
            const startPos = metrics().pos;
            const move = moveEvent => {
                const m = metrics();
                const length = vertical ? thumb.offsetHeight : thumb.offsetWidth;
                const free = m.track - length;
                if (free > 0) {
                    const delta = (vertical ? moveEvent.clientY : moveEvent.clientX) - start;
                    viewport[vertical ? 'scrollTop' : 'scrollLeft'] = startPos + delta * (m.total - m.view) / free;
                }
            };
            const stop = () => {
                root.classList.remove('scrollbar_dragging');
                thumb.removeEventListener('pointermove', move);
                thumb.removeEventListener('pointerup', stop);
                thumb.removeEventListener('pointercancel', stop);
            };
            thumb.addEventListener('pointermove', move);
            thumb.addEventListener('pointerup', stop);
            thumb.addEventListener('pointercancel', stop);
        });

        // щелчок по дорожке: страница в сторону щелчка
        track.addEventListener('pointerdown', event => {
            if (event.target === thumb) {
                return;
            }
            const rect = thumb.getBoundingClientRect();
            const before = vertical ? event.clientY < rect.top : event.clientX < rect.left;
            const m = metrics();
            scrollTo(m.pos + (before ? -m.view : m.view) * 0.9);
        });

        root.querySelectorAll('[data-scrollbar-step]').forEach(arrow => {
            arrow.addEventListener('click', () => {
                scrollTo(metrics().pos + Number(arrow.dataset.scrollbarStep) * ARROW_STEP);
            });
        });

        update();
    };

    const scan = scope => scope.querySelectorAll?.('.scrollbar').forEach(init);
    const start = () => {
        scan(document);
        // блоки, добавленные позже (подгрузка, модальные окна)
        new MutationObserver(records => records.forEach(record => record.addedNodes.forEach(node => {
            if (node.nodeType === 1) {
                node.matches('.scrollbar') && init(node);
                scan(node);
            }
        }))).observe(document.body, {childList: true, subtree: true});
    };
    document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', start) : start();
})();
