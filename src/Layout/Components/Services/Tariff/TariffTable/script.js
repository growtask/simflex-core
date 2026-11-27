/*
 * Таблица тарифов (TariffTable): на телефоне селектор (SelectorMain, событие sf-selector-change, значение — номер
 * тарифа) показывает один тариф — класс tariff-table_plan_N
 */
(() => {
    if (window.SimflexTariffTableReady) {
        return;
    }
    window.SimflexTariffTableReady = true;

    document.addEventListener('sf-selector-change', (event) => {
        const table = event.target.closest?.('[data-sf-tariff-table]');
        const index = Number(event.detail?.value);
        if (!table || !Number.isInteger(index)) {
            return;
        }
        [...table.classList].filter((name) => name.startsWith('tariff-table_plan_')).forEach((name) => table.classList.remove(name));
        table.classList.add(`tariff-table_plan_${index}`);
    });
})();
