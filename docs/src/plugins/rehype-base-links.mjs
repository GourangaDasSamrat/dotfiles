import { visit } from "unist-util-visit";

/**
 * Prefixes root-relative links (`/guide/stow/`) with the site's `base`, so the
 * Markdown stays independent of where the site is deployed.
 */
export function rehypeBaseLinks({ base = "" } = {}) {
  const prefix = base.replace(/\/+$/, "");
  return (tree) => {
    if (!prefix) return;
    visit(tree, "element", (node) => {
      if (node.tagName !== "a") return;
      const href = node.properties?.href;
      if (
        typeof href === "string" &&
        href.startsWith("/") &&
        !href.startsWith("//") &&
        !href.startsWith(`${prefix}/`)
      ) {
        node.properties.href = prefix + href;
      }
    });
  };
}
