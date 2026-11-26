/* Дерево: раскрытие веток, выбор узла отмечает потомков, у родителя — partial; событие sf-tree-change */
(() => {
    const checkboxOf = node => node.querySelector(':scope > .tree-item input[type="checkbox"]');
    const childNodes = node => [...node.querySelectorAll(':scope > .tree-node__children > .tree__group > .tree-node')];

    // состояние родителя выводится из прямых детей
    const syncUp = node => {
        let parent = node.parentElement?.closest('.tree-node');
        while (parent) {
            const own = checkboxOf(parent);
            const kids = childNodes(parent).map(checkboxOf).filter(Boolean);
            const on = kids.filter(kid => kid.checked && !kid.indeterminate).length;
            const partial = kids.some(kid => kid.indeterminate);
            if (own) {
                own.checked = kids.length > 0 && on === kids.length;
                own.indeterminate = !own.checked && (on > 0 || partial);
            }
            parent = parent.parentElement?.closest('.tree-node');
        }
    };

    document.addEventListener('change', event => {
        const input = event.target;
        const node = input.closest?.('.tree .tree-node');
        if (!node || !input.matches('.tree-item input[type="checkbox"]')) {
            return;
        }
        input.indeterminate = false;
        node.querySelectorAll(':scope > .tree-node__children input[type="checkbox"]:not(:disabled)').forEach(child => {
            child.checked = input.checked;
            child.indeterminate = false;
        });
        syncUp(node);
        const tree = node.closest('.tree');
        const values = [...tree.querySelectorAll('.tree-node')]
            .filter(item => !item.querySelector(':scope > .tree-node__children'))
            .map(checkboxOf)
            .filter(box => box?.checked)
            .map(box => box.value);
        tree.dispatchEvent(new CustomEvent('sf-tree-change', {bubbles: true, detail: {values}}));
    });

    document.addEventListener('click', event => {
        const toggle = event.target.closest?.('.tree-item__toggle');
        const node = toggle?.closest('.tree-node');
        const group = node?.querySelector(':scope > .tree-node__children');
        if (!toggle || !group) {
            return;
        }
        const open = toggle.getAttribute('aria-expanded') !== 'true';
        toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
        node.classList.toggle('tree-node_expanded', open);
        group.hidden = !open;
    });
})();
