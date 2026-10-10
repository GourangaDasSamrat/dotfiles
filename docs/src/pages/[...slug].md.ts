import type { APIRoute, GetStaticPaths } from "astro";
import { getCollection } from "astro:content";

/**
 * Serves every docs page as plain Markdown at `/<slug>.md`. The "Copy page"
 * and "Open in ..." actions point AI assistants at these files.
 */
export const getStaticPaths = (async () => {
  const docs = await getCollection("docs");
  return docs
    .filter((doc) => doc.id !== "index")
    .map((doc) => ({ params: { slug: doc.id }, props: { doc } }));
}) satisfies GetStaticPaths;

export const GET: APIRoute = ({ props }) => {
  const { doc } = props;
  const body = `# ${doc.data.title}\n\n${doc.body ?? ""}\n`;
  return new Response(body, {
    headers: { "Content-Type": "text/markdown; charset=utf-8" },
  });
};
