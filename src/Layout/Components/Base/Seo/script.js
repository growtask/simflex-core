/* SEO-текст: «Читать далее» раскрывает текст целиком, «Свернуть» возвращает три строки */
document.addEventListener('click', (event) => {
    const toggle = event.target.closest?.('[data-sf-seo-toggle]');
    const seo = toggle?.closest('[data-sf-seo]');
    if (!seo) {
        return;
    }
    event.preventDefault();
    const expanded = seo.classList.toggle('seo_expanded');
    toggle.setAttribute('aria-expanded', expanded ? 'true' : 'false');
    const text = toggle.querySelector('.link__text');
    if (text) {
        text.textContent = expanded ? toggle.dataset.less : toggle.dataset.more;
    }
});
