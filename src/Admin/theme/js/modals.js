/**
 * Окна админки на Modal/main (theme/tpl/modals): удаление, сведения о записи, подтверждение sfAdmin.confirm().
 * window.openDeleteModal() / closeDeleteModal() / openInfoModal() / closeInfoModal() — для скриптов списка, которые
 * ещё не переведены на новый дизайн (theme/js/extra.js, app.js)
 */
import {setConfirm} from './admin.js';

const open = (id) => window.SimflexModal?.open(id);
const close = (id) => window.SimflexModal?.close(id);

window.openDeleteModal = () => open('sf-modal-delete');
window.closeDeleteModal = () => close('sf-modal-delete');
window.openInfoModal = () => open('sf-modal-info');
window.closeInfoModal = () => close('sf-modal-info');

/**
 * Подтверждение: окно sf-modal-confirm, Promise<boolean>. Закрытие окна (Esc, подложка, крестик) — отказ
 */
setConfirm((message, {title = 'Подтвердите действие', confirmText = 'Да', danger = false} = {}) => new Promise((resolve) => {
    const modal = document.getElementById('sf-modal-confirm');
    if (!modal || !window.SimflexModal) {
        resolve(window.confirm(message));
        return;
    }
    const yes = modal.querySelector('[data-sf-confirm="yes"]');
    modal.querySelector('.modal__title').textContent = title;
    modal.querySelector('.modal__text').textContent = message;
    yes.querySelector('.btn__text').textContent = confirmText;
    // опасное действие — не главная кнопка
    yes.classList.toggle('btn-primary', !danger);
    yes.classList.toggle('btn-secondary', danger);

    let result = false;
    const onClick = (event) => {
        const answer = event.target.closest('[data-sf-confirm]')?.dataset.sfConfirm;
        if (answer) {
            result = answer === 'yes';
            close('sf-modal-confirm');
        }
    };
    const onClose = () => {
        modal.removeEventListener('click', onClick);
        resolve(result);
    };
    modal.addEventListener('click', onClick);
    modal.addEventListener('modal:close', onClose, {once: true});
    open('sf-modal-confirm');
}));
