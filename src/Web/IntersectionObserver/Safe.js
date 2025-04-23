export const root = (observer) => observer.root;
export const rootMargin = (observer) => observer.rootMargin;
export const scrollMargin = (observer) => observer.rootMargin;
export const thresholds = (observer) => observer.thresholds;
export const _observe = (observer, target) => observer.observe(target);
export const _unobserve = (observer, target) => observer.unobserve(target);
export const _disconnect = (observer) => observer.disconnect();
export const _takeRecords = (observer) => observer.takeRecords();
