/*
 * Уведомление (Notice): крестик «Закрыть» убирает уведомление со страницы. Если у уведомления есть
 * data-sf-notice-dismiss (адрес) и data-sf-notice-key, перед удалением на адрес уходит POST с ключом и CSRF-токеном
 * (<meta name="csrf-token">): сервер запоминает, что пользователь скрыл уведомление
 */
document.addEventListener('click', (event) => {
    const close = event.target.closest?.('[data-sf-notice-close]');
    const notice = close?.closest('[data-sf-notice]');
    if (!notice) {
        return;
    }
    const url = notice.dataset.sfNoticeDismiss;
    if (url) {
        fetch(url, {
            method: 'POST',
            credentials: 'same-origin',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') ?? '',
            },
            body: new URLSearchParams({key: notice.dataset.sfNoticeKey ?? ''}),
        }).catch(() => {});
    }
    notice.remove();
});
