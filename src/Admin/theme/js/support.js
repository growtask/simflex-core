/**
 * Панель поддержки (theme/tpl/partial/support.tpl): открытие кнопкой [data-sf-support-open], закрытие крестиком
 * и Esc с возвратом фокуса. Форма обращения грузится при первом открытии; её сообщения: close-iframe — закрыть
 * панель, success — закрыть и показать тост
 */
import {register, toast} from './admin.js';

register('support', (panel) => {
    const frame = panel.querySelector('.support-bar__frame');
    let opener = null;

    const close = () => {
        if (panel.hidden) {
            return;
        }
        panel.hidden = true;
        document.querySelectorAll('[data-sf-support-open]').forEach((button) => button.setAttribute('aria-expanded', 'false'));
        opener?.focus();
    };
    const open = (button) => {
        opener = button;
        if (!frame.src) {
            frame.src = frame.dataset.src;
        }
        panel.hidden = false;
        button?.setAttribute('aria-expanded', 'true');
        panel.querySelector('[data-sf-support-close]').focus();
    };

    document.addEventListener('click', (event) => {
        const button = event.target.closest('[data-sf-support-open]');
        if (button) {
            panel.hidden ? open(button) : close();
        } else if (event.target.closest('[data-sf-support-close]')) {
            close();
        }
    });
    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            close();
        }
    });
    window.addEventListener('message', (event) => {
        if (event.source !== frame.contentWindow) {
            return;
        }
        if (event.data === 'close-iframe') {
            close();
        } else if (event.data === 'success') {
            close();
            toast('Заявка успешно отправлена', {type: 'success'});
        }
    });
});
