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

        if (this.isButton) {
            this.trigger.addEventListener('click', this.handleTriggerClick);
            document.addEventListener('click', this.handleDocumentClick);
        }
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
    }

    handleLeave(event) {
        if (event.type === 'focusout' && event.relatedTarget && this.container.contains(event.relatedTarget)) return;

        this.container.classList.remove('dropdown-tab_dismissed');
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
        this.trigger.setAttribute('aria-expanded', 'true');
    }

    close() {
        if (this.isLocked) return;

        this.menu.classList.remove('dropdown-tab__menu_active');
        this.trigger.classList.remove('dropdown-tab__trigger_active');
        this.trigger.setAttribute('aria-expanded', 'false');
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
        if (this.isButton) {
            this.trigger.removeEventListener('click', this.handleTriggerClick);
            document.removeEventListener('click', this.handleDocumentClick);
        }
        clearTimeout(this.hoverIntent);
    }
}

// Initialize dropdowns
document.addEventListener('DOMContentLoaded', () => {
    const dropdowns = document.querySelectorAll('.dropdown-tab');
    dropdowns.forEach(container => {
        new DropdownTab(container);
    });
});

/** If you need to populate options with JS instead */
// document.addEventListener('DOMContentLoaded', () => {
//     const dropdowns = document.querySelectorAll('.dropdown-tab');
//     dropdowns.forEach(container => {
//         const dataOptions = container.dataset.options;
//         const options = phpOptions ? { data: JSON.parse(dataOptions) } : {};
//
//         new DropdownTab(container, options);
//     });
// });