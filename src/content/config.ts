import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

// ─── Blog Post Schema ──────────────────────────────────────────────────────
//
// Required fields (must be set before setting draft: false):
//   title       Short, descriptive title
//   description One-sentence summary shown in cards and SEO meta
//   date        Publication date (YYYY-MM-DD)
//   tags        At least one tag from the approved list
//
// Optional fields:
//   author      Defaults to "Bhuvan". Set explicitly for guest posts.
//   updatedAt   Set when content changes meaningfully after publication.
//   featured    Only one post should be featured at a time.
//   series      Slug of the parent series (e.g. "production-kubernetes-azure").
//   part        Part number within the series (1-based integer).
//   readTime    Manual override, e.g. "12 min". Auto-calculated if omitted.
//   draft       Keep true until ready to publish. Draft posts are never rendered.

const blog = defineCollection({
  loader: glob({ pattern: ['**/*.md', '!README.md', '!**/README.md'], base: './src/content/blog' }),
  schema: z.object({
    title:       z.string(),
    description: z.string().optional(),
    date:        z.date(),
    updatedAt:   z.date().optional(),
    author:      z.string().default('Bhuvan'),
    tags:        z.array(z.string()).default([]),
    primaryTag:  z.string().optional(),
    featured:    z.boolean().default(false),
    draft:       z.boolean().default(false),
    series:      z.string().optional(),   // matches a slug in src/content/series/
    part:        z.number().int().positive().optional(),
    readTime:    z.string().optional(),   // e.g. "12 min" — overrides auto-calc
    cover:       z.string().optional(),   // relative path to cover image
    crossPost:   z.object({
      medium: z.string().url().optional(),
      dev:    z.string().url().optional(),
    }).optional(),
  }),
});

// ─── Series Schema ─────────────────────────────────────────────────────────
//
// A series groups related blog posts into a structured curriculum.
//
// Required fields:
//   title         Full series title
//   description   One-to-two sentence summary
//   level         beginner | intermediate | advanced
//   hours         Estimated total reading time in hours (number)
//   status        active (in progress) | complete
//   statusLabel   Human label shown in UI, e.g. "In progress" or "Complete"
//   topics        Tag-like topics for filtering (array of strings)
//   objectives    What the reader will be able to do after completing the series
//   modules       Curriculum sections, each with a heading and list of posts
//
// Optional fields:
//   prerequisites What the reader should already know
//   iconPath      SVG path data for the series icon
//   accentHue     HSL hue for the series accent colour (default: "220")
//
// Module post fields:
//   slug          Filename of the blog post (without .md, without topic folder)
//   title         Display title for the post in the curriculum list
//   readTime      Estimated reading time shown in the curriculum, e.g. "12 min"
//
// Note: whether a post is published is determined automatically at build time
// by checking the blog collection. There is no manual "done" flag.

const seriesPost = z.object({
  slug:     z.string(),
  title:    z.string(),
  readTime: z.string().optional(),
});

const seriesModule = z.object({
  heading: z.string(),
  posts:   z.array(seriesPost),
});

const series = defineCollection({
  type: 'content',
  schema: z.object({
    title:         z.string(),
    description:   z.string(),
    level:         z.enum(['beginner', 'intermediate', 'advanced']),
    hours:         z.number(),
    status:        z.enum(['active', 'complete']),
    statusLabel:   z.string(),
    topics:        z.array(z.string()).default([]),
    objectives:    z.array(z.string()).default([]),
    prerequisites: z.array(z.string()).default([]),
    modules:       z.array(seriesModule).default([]),
    iconPath:      z.string().optional(),
    accentHue:     z.string().default('220'),
  }),
});

export const collections = { blog, series };
