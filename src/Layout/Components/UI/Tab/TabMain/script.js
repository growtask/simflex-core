/*
 * Группа вкладок (Tab): контейнер с data-sf-tabs, вкладки .tab внутри - соседи (кнопки; ссылки переходят сами).
 * Клик или Enter/Space делают вкладку активной: класс active, aria-selected, панель из aria-controls показывается,
 * панели остальных скрываются (hidden). При role="tablist" - клавиатура как у вкладок: стрелки по кругу, Home/End,
 * roving tabindex (в порядке Tab только активная). Подложка активной переезжает к новой (SfUi.glide,
 * assetsGlobal/script.js); data-sf-tabs="static" - без переезда. Событие tab:change ({detail: {tab, value}}) на
 * контейнере; value - data-value вкладки.
 */
(() => {
    if (window.SimflexTabsReady) {
        return;
    }
    window.SimflexTabsReady = true;

    const GROUP = '[data-sf-tabs]';
    const TAB = '.tab';

    const tabsOf = (group) => [...group.querySelectorAll(TAB)].filter((tab) => tab.closest(GROUP) === group);
    const isDisabled = (tab) => tab.disabled || tab.getAttribute('aria-disabled') === 'true';
    const isTabList = (group) => group.getAttribute('role') === 'tablist';

    const glide = (tab, animate) => {
        if (window.SfUi?.glide) {
            window.SfUi.glide(tab, 'tab__glide', () => tab.classList.contains('active'), animate);
        }
    };

    const setRoving = (group) => {
        if (!isTabList(group)) {
            return;
        }
        const tabs = tabsOf(group);
        const active = tabs.find((tab) => tab.classList.contains('active') && !isDisabled(tab))
            ?? tabs.find((tab) => !isDisabled(tab));
        tabs.forEach((tab) => {
            tab.tabIndex = tab === active ? 0 : -1;
        });
    };

    const activate = (group, tab, focus = false) => {
        if (!tab || isDisabled(tab) || tab.classList.contains('active')) {
            focus && tab?.focus();
            return;
        }
        tabsOf(group).forEach((other) => {
            const on = other === tab;
            other.classList.toggle('active', on);
            if (other.getAttribute('role') === 'tab') {
                other.setAttribute('aria-selected', on ? 'true' : 'false');
            }
            const panelId = other.getAttribute('aria-controls');
            const panel = panelId ? document.getElementById(panelId) : null;
            if (panel) {
                panel.hidden = !on;
            }
        });
        glide(tab, group.dataset.sfTabs !== 'static');
        setRoving(group);
        if (focus) {
            tab.focus();
        }
        group.dispatchEvent(new CustomEvent('tab:change', {bubbles: true, detail: {tab, value: tab.dataset.value ?? ''}}));
    };

    const init = (group) => {
        if (group.dataset.sfTabsReady) {
            return;
        }
        group.dataset.sfTabsReady = '1';
        tabsOf(group).forEach((tab) => {
            if (tab.classList.contains('active')) {
                glide(tab, false);
            }
        });
        setRoving(group);
    };

    document.addEventListener('click', (event) => {
        const tab = event.target.closest(TAB);
        const group = tab?.closest(GROUP);
        if (!group || tab.tagName === 'A') {
            return;
        }
        init(group);
        activate(group, tab);
    });

    document.addEventListener('keydown', (event) => {
        const tab = event.target.closest?.(TAB);
        const group = tab?.closest(GROUP);
        if (!group || !isTabList(group)) {
            return;
        }
        const tabs = tabsOf(group).filter((item) => !isDisabled(item));
        const index = tabs.indexOf(tab);
        const vertical = group.getAttribute('aria-orientation') === 'vertical';
        const next = {
            [vertical ? 'ArrowDown' : 'ArrowRight']: tabs[(index + 1) % tabs.length],
            [vertical ? 'ArrowUp' : 'ArrowLeft']: tabs[(index - 1 + tabs.length) % tabs.length],
            Home: tabs[0],
            End: tabs[tabs.length - 1],
        }[event.key];
        if (next) {
            event.preventDefault();
            init(group);
            activate(group, next, true);
        }
    });

    const ready = () => document.querySelectorAll(GROUP).forEach(init);
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', ready);
    } else {
        ready();
    }
})();
