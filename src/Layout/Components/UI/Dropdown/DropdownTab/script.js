/*
 * Вкладка с меню (DropdownTab): меню открывается наведением мыши, фокусом с клавиатуры внутри (CSS) и кликом по
 * кнопке-триггеру (фиксация, dropdown-tab_locked); Esc закрывает и возвращает фокус на триггер, клик снаружи снимает
 * фиксацию. aria-expanded триггера отражает фактическое открытие — и по наведению и фокусу тоже (условия те же,
 * что в style.scss). Всё в IIFE, запуск — сразу или по DOMContentLoaded. API: container.sfDropdownTab
 * (populate(data), destroy()), класс — window.SimflexDropdownTab.
 */
(() => {
    if (window.SimflexDropdownTab) {
        return;
    }

    const FINE = '(hover: hover) and (pointer: fine)';
    const instances = new Set();

    class DropdownTab {
        constructor(container, options = {}) {
            this.container = container;
            this.trigger = container.querySelector('.dropdown-tab__trigger');
            this.menu = container.querySelector('.dropdown-tab__menu');
            this.isButton = this.trigger.tagName.toLowerCase() === 'button';
            this.isLocked = false;
            this.hoverIntent = null;

            this.handleTriggerClick = this.handleTriggerClick.bind(this);
            this.handleDocumentClick = this.handleDocumentClick.bind(this);
            this.handleKeydown = this.handleKeydown.bind(this);
            this.handleLeave = this.handleLeave.bind(this);
            this.refresh = this.refresh.bind(this);
            this.refreshLater = () => requestAnimationFrame(this.refresh);

            this.init();
            if (options.data) {
                this.populate(options.data);
            }
        }

        init() {
            this.trigger.setAttribute('aria-expanded', 'false');

            // Esc закрывает меню и возвращает фокус на триггер; снова открывается, когда фокус и курсор ушли
            this.container.addEventListener('keydown', this.handleKeydown);
            this.container.addEventListener('mouseleave', this.handleLeave);
            this.container.addEventListener('focusout', this.handleLeave);
            // открытие наведением и фокусом — в CSS; aria-expanded следит за тем же
            this.container.addEventListener('mouseenter', this.refresh);
            this.container.addEventListener('focusin', this.refreshLater);

            if (this.isButton) {
                this.trigger.addEventListener('click', this.handleTriggerClick);
                document.addEventListener('click', this.handleDocumentClick);
            }
            instances.add(this);
        }

        /** Открыто ли меню сейчас — те же условия, что в style.scss */
        isShown() {
            if (this.container.classList.contains('dropdown-tab_dismissed')) {
                return false;
            }
            if (this.isLocked || this.menu.classList.contains('dropdown-tab__menu_active')) {
                return true;
            }
            if (window.matchMedia(FINE).matches && this.container.matches(':hover')) {
                return true;
            }
            // в ките кольцо фокуса (и открытие по нему) — только с клавиатуры: html.sf-kbd ставит ui.js;
            // без ui.js — просто :focus-visible
            const keyboard = !window.SfUi || document.documentElement.classList.contains('sf-kbd');
            return keyboard && this.container.querySelector(':focus-visible') !== null;
        }

        refresh() {
            this.trigger.setAttribute('aria-expanded', String(this.isShown()));
        }

        handleTriggerClick(event) {
            if (!this.isButton) return;

            event.preventDefault();
            event.stopPropagation();

            if (this.isLocked) {
                this.unlock();
                this.close();
            } else {
                this.lock();
                this.open();
            }
        }

        handleKeydown(event) {
            if (event.key !== 'Escape') return;

            this.container.classList.add('dropdown-tab_dismissed');
            this.unlock();
            this.close();
            this.trigger.focus();
            this.refresh();
        }

        handleLeave(event) {
            if (event.type === 'focusout' && event.relatedTarget && this.container.contains(event.relatedTarget)) return;

            this.container.classList.remove('dropdown-tab_dismissed');
            this.refreshLater();
        }

        handleDocumentClick(event) {
            if (this.isLocked && !this.container.contains(event.target)) {
                this.unlock();
                this.close();
            }
        }

        lock() {
            this.isLocked = true;
            this.container.classList.add('dropdown-tab_locked');
        }

        unlock() {
            this.isLocked = false;
            this.container.classList.remove('dropdown-tab_locked');
        }

        open() {
            this.menu.classList.add('dropdown-tab__menu_active');
            this.trigger.classList.add('dropdown-tab__trigger_active');
            this.refresh();
        }

        close() {
            if (this.isLocked) return;

            this.menu.classList.remove('dropdown-tab__menu_active');
            this.trigger.classList.remove('dropdown-tab__trigger_active');
            this.refresh();
        }

        populate(data) {
            this.menu.innerHTML = '';

            data.forEach(item => {
                const option = document.createElement('li');
                option.className = 'dropdown-tab__option';

                const link = document.createElement('a');
                link.className = 'dropdown-tab__link';
                link.href = item.link;
                link.textContent = item.text;
                link.setAttribute('data-value', item.value);

                option.appendChild(link);
                this.menu.appendChild(option);
            });
        }

        destroy() {
            this.container.removeEventListener('keydown', this.handleKeydown);
            this.container.removeEventListener('mouseleave', this.handleLeave);
            this.container.removeEventListener('focusout', this.handleLeave);
            this.container.removeEventListener('mouseenter', this.refresh);
            this.container.removeEventListener('focusin', this.refreshLater);
            if (this.isButton) {
                this.trigger.removeEventListener('click', this.handleTriggerClick);
                document.removeEventListener('click', this.handleDocumentClick);
            }
            clearTimeout(this.hoverIntent);
            instances.delete(this);
            delete this.container.sfDropdownTab;
        }
    }

    // клавиатура и мышь переключают html.sf-kbd (кольцо фокуса) — открытие по фокусу могло смениться
    const refreshAll = () => requestAnimationFrame(() => instances.forEach((instance) => instance.refresh()));
    document.addEventListener('pointerdown', refreshAll, true);
    document.addEventListener('keydown', (event) => {
        if (event.key === 'Tab') {
            refreshAll();
        }
    }, true);

    const init = () => document.querySelectorAll('.dropdown-tab').forEach((container) => {
        if (!container.sfDropdownTab && container.querySelector('.dropdown-tab__trigger')
            && container.querySelector('.dropdown-tab__menu')) {
            container.sfDropdownTab = new DropdownTab(container);
        }
    });
    document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', init) : init();

    window.SimflexDropdownTab = DropdownTab;
})();
