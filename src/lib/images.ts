import type { ImageMetadata } from 'astro';

const coverImages = import.meta.glob<{ default: ImageMetadata }>(
  '/src/content/blog/**/images/*.{webp,png,jpg,jpeg,avif}',
  { eager: true },
);

/** Resolve a cover path (e.g. "./images/foo.webp") to an ImageMetadata object, or null. */
export function resolveCover(path: string | undefined): ImageMetadata | null {
  if (!path) return null;
  const file = path.split('/').at(-1)!;
  const match = Object.entries(coverImages).find(([k]) => k.endsWith(`/images/${file}`));
  return match?.[1]?.default ?? null;
}
