/* Список меню: пункт с подменю раскрывается на месте, Esc закрывает и возвращает фокус на пункт */
document.addEventListener('click', (event) => {
    const toggle = event.target.closest?.('[data-sf-menu-toggle]');
    const item = toggle?.closest('.nav-menu-list__item');
    if (!item) {
        return;
    }
    const open = item.classList.toggle('nav-menu-list__item_open');
    toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
});

document.addEventListener('keydown', (event) => {
    if (event.key !== 'Escape') {
        return;
    }
    const item = event.target.closest?.('.nav-menu-list__item_open');
    const toggle = item?.querySelector('[data-sf-menu-toggle]');
    if (!toggle) {
        return;
    }
    item.classList.remove('nav-menu-list__item_open');
    toggle.setAttribute('aria-expanded', 'false');
    toggle.focus();
});
