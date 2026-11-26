/* Баннер «Браузер устарел» (разметка с check): показывается, если браузер не умеет возможности,
 * на которых держится вёрстка: color-mix(), :has() и container queries. */
(() => {
    const banner = document.querySelector('[data-sf-browser-support]');
    if (!banner) {
        return;
    }
    const supports = window.CSS && CSS.supports
        && CSS.supports('color', 'color-mix(in srgb, red, blue)')
        && CSS.supports('selector(:has(a))')
        && CSS.supports('container-type', 'inline-size');
    if (!supports) {
        banner.hidden = false;
    }
})();
