/* Прелоадер: по window load плавно гаснет (класс preloader_hidden) и убирается;
 * data-sf-preloader - минимальное время показа в мс от начала загрузки страницы. */
(() => {
    const preloader = document.querySelector('[data-sf-preloader]');
    if (!preloader) {
        return;
    }
    const hide = () => {
        const left = (parseInt(preloader.dataset.sfPreloader, 10) || 0) - performance.now();
        setTimeout(() => {
            preloader.classList.add('preloader_hidden');
            preloader.removeAttribute('aria-busy');
            const duration = parseFloat(getComputedStyle(preloader).transitionDuration) || 0;
            setTimeout(() => preloader.remove(), duration * 1000 + 50);
        }, Math.max(0, left));
    };
    if (document.readyState === 'complete') {
        hide();
    } else {
        window.addEventListener('load', hide, { once: true });
    }
})();
