/** Last segment of a content entry id, used as the URL slug. */
export function flatSlug(id: string): string {
  return id.split('/').at(-1) ?? id;
}

/**
 * Calculate read time from body text.
 * Returns the frontmatter override as-is if provided, otherwise estimates from word count.
 */
export function calcReadTime(body: string | null | undefined, override?: string): string {
  if (override) return override;
  return `${Math.max(1, Math.ceil((body ?? '').split(/\s+/).length / 200))} min`;
}

/**
 * Format a date for display.
 * style 'long'  → "March 2026"
 * style 'short' → "Mar 2026"
 */
export function fmtDate(d: Date, style: 'long' | 'short' = 'long'): string {
  return new Date(d).toLocaleDateString('en-US', { month: style, year: 'numeric' });
}

/** Capitalize the first letter of a string. */
export function capitalize(s: string): string {
  return s.charAt(0).toUpperCase() + s.slice(1);
}

/**
 * Derive a display group from a content entry's id path or optional category field.
 * e.g. "cloud/azure/something" → "cloud"
 */
export function deriveGroup(id: string, category?: string): string {
  const parts = id.split('/');
  if (parts.length > 1) return parts[0];
  return category ?? 'general';
}
