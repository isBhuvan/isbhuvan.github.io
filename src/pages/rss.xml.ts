import rss from "@astrojs/rss";
import { getCollection } from "astro:content";
import type { APIContext } from "astro";

export async function GET(context: APIContext) {
  const posts = await getCollection("blog", ({ data }) => !data.draft);
  const sorted = posts.sort(
    (a, b) => b.data.date.valueOf() - a.data.date.valueOf(),
  );

  return rss({
    title: "isBhuvan",
    description:
      "Azure Cloud Engineer writing about Kubernetes, Terraform, and platform engineering.",
    site: context.site!,
    items: sorted.map((post) => ({
      title: post.data.title,
      pubDate: post.data.date,
      description: post.data.description ?? "",
      link: `/blog/${post.id.split("/").at(-1) ?? post.id}/`,
    })),
    customData: `<language>en-us</language>`,
  });
}
