/* Хлебные крошки: «…» на телефоне раскрывает скрытые пункты, фокус переходит на первый из них */
document.addEventListener('click', (event) => {
    const more = event.target.closest?.('[data-sf-breadcrumbs-more]');
    const breadcrumbs = more?.closest('[data-sf-breadcrumbs]');
    if (!breadcrumbs) {
        return;
    }
    more.setAttribute('aria-expanded', 'true');
    breadcrumbs.classList.add('breadcrumbs_expanded');
    breadcrumbs.querySelector('.breadcrumbs__item_middle a')?.focus();
});
