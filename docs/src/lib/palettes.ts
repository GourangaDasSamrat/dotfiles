export interface Palette {
  id: string;
  label: string;
  /** Accent colour shown as the swatch next to the name. */
  swatch: string;
}

/** Colour palettes selectable from the header. Keep in sync with `palettes.css`. */
export const PALETTES: Palette[] = [
  { id: "dracula", label: "Dracula", swatch: "#bd93f9" },
  { id: "catppuccin", label: "Catppuccin", swatch: "#cba6f7" },
  { id: "tokyo-night", label: "Tokyo Night", swatch: "#7aa2f7" },
  { id: "nord", label: "Nord", swatch: "#88c0d0" },
  { id: "rose-pine", label: "Rosé Pine", swatch: "#c4a7e7" },
];

export const DEFAULT_PALETTE = "dracula";
export const PALETTE_STORAGE_KEY = "dotfiles-palette";
