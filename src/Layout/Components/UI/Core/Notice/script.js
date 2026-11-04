/* Уведомление (Notice): крестик «Закрыть» убирает уведомление со страницы */
document.addEventListener('click', (event) => {
    const close = event.target.closest?.('[data-sf-notice-close]');
    close?.closest('[data-sf-notice]')?.remove();
});
