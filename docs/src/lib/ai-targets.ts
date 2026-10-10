import {
  siClaude,
  siCursor,
  siDuckduckgo,
  siGoogle,
  siPerplexity,
  siX,
} from "simple-icons";

export interface AiTarget {
  id: string;
  label: string;
  description: string;
  /** SVG path (24x24 viewBox, filled). */
  icon: string;
  /** Builds the URL that opens the assistant with the prompt pre-filled. */
  url: (prompt: string) => string;
}

// Simple Icons has no OpenAI mark, so ChatGPT gets a neutral chat glyph.
const CHAT_GLYPH =
  "M12 2C6.48 2 2 5.92 2 10.75c0 2.55 1.26 4.84 3.27 6.44-.1 1.2-.5 2.44-1.27 3.56a.5.5 0 0 0 .54.77c1.9-.4 3.43-1.2 4.5-1.97.9.2 1.9.3 2.96.3 5.52 0 10-3.92 10-8.75S17.52 2 12 2Zm-4 9.75a1.25 1.25 0 1 1 0-2.5 1.25 1.25 0 0 1 0 2.5Zm4 0a1.25 1.25 0 1 1 0-2.5 1.25 1.25 0 0 1 0 2.5Zm4 0a1.25 1.25 0 1 1 0-2.5 1.25 1.25 0 0 1 0 2.5Z";

const q = encodeURIComponent;

/** Assistants offered in the "Open" menu, in display order. */
export const AI_TARGETS: AiTarget[] = [
  {
    id: "chatgpt",
    label: "Open in ChatGPT",
    description: "Ask questions about this page",
    icon: CHAT_GLYPH,
    url: (p) => `https://chatgpt.com/?hints=search&q=${q(p)}`,
  },
  {
    id: "claude",
    label: "Open in Claude",
    description: "Ask questions about this page",
    icon: siClaude.path,
    url: (p) => `https://claude.ai/new?q=${q(p)}`,
  },
  {
    id: "perplexity",
    label: "Open in Perplexity",
    description: "Search with this page as context",
    icon: siPerplexity.path,
    url: (p) => `https://www.perplexity.ai/search?q=${q(p)}`,
  },
  {
    id: "google-ai",
    label: "Open in Google AI Mode",
    description: "Ask Google about this page",
    icon: siGoogle.path,
    url: (p) => `https://www.google.com/search?udm=50&q=${q(p)}`,
  },
  {
    id: "grok",
    label: "Open in Grok",
    description: "Ask questions about this page",
    icon: siX.path,
    url: (p) => `https://grok.com/?q=${q(p)}`,
  },
  {
    id: "duckai",
    label: "Open in Duck.ai",
    description: "Private AI chat about this page",
    icon: siDuckduckgo.path,
    url: (p) => `https://duck.ai/?q=${q(p)}`,
  },
  {
    id: "cursor",
    label: "Open in Cursor",
    description: "Send this page to your editor",
    icon: siCursor.path,
    url: (p) => `https://cursor.com/link/prompt?text=${q(p)}`,
  },
];
