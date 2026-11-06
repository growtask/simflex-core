/* Состояние partial: input с data-indeterminate становится indeterminate, выбор пользователем снимает его */
// скрипт может подключаться в <head> без defer (админка): чекбоксы ищутся, когда разметка готова
(() => {
    const init = () => {
        document.querySelectorAll('.checkbox__input[data-indeterminate]').forEach(input => {
            input.indeterminate = true;
            input.addEventListener('change', () => {
                input.indeterminate = false;
            });
        });
    };
    document.readyState === 'loading' ? document.addEventListener('DOMContentLoaded', init) : init();
})();
