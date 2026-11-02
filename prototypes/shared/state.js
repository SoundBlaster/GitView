/* Local fallback for the two state calls used by the conversation prototypes. */
(() => {
  if (window.openai && typeof window.openai.setWidgetState === 'function') return;
  const key = 'gitview-prototype:' + document.documentElement.dataset.prototype;
  let snapshot = null;
  try { snapshot = JSON.parse(localStorage.getItem(key) || 'null'); } catch (_) { /* In-memory fallback. */ }
  window.openai = {
    widgetState: snapshot,
    async setWidgetState(next) {
      const value = typeof next === 'function' ? next(snapshot) : next;
      snapshot = JSON.parse(JSON.stringify(value));
      this.widgetState = snapshot;
      try { localStorage.setItem(key, JSON.stringify(snapshot)); } catch (_) { /* File mode may restrict storage. */ }
    }
  };
  window.addEventListener('storage', event => {
    if (event.key !== key) return;
    try { snapshot = JSON.parse(event.newValue || 'null'); } catch (_) { return; }
    window.openai.widgetState = snapshot;
    window.dispatchEvent(new CustomEvent('openai:set_globals', {
      detail: { globals: { widgetState: snapshot } }
    }));
  });
})();
