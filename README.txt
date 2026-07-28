## PilotDECODER — Site Structure Brief

Copy the block below into Claude Cowork as context before working on the site.

---

**Repo:** `zwubbena/pilotdecoder` — deployed via GitHub Pages to `pilotdecoder.com` (custom domain set via `CNAME` file at repo root).

**File structure:**
```
/
├── CNAME                     → custom domain config, don't touch
├── index.html                → homepage / landing page (tool directory)
├── assets/
│   ├── site.css              → THE design system: tokens, themes, chrome, components
│   └── site.js               → theme toggle (+ favicon recolor) and copyright year
├── preview.command           → double-click local preview server (optional to commit)
├── _template/
│   └── index.html            → copy-me starting point for every new tool
│                               (underscore folder = not published by GitHub Pages)
├── metar-decoder/index.html          → METAR Decoder
├── density-altitude-decoder/index.html → Density Altitude Decoder
├── wind-tunnel-decoder/index.html     → Wind Tunnel Decoder
└── flight-pattern-decoder/index.html → Flight Pattern Decoder (standard site chrome; the animated
                                sheet inside keeps its own poster palette, scoped to .sheet)
```
No build step, no framework, no external dependencies (no CDN fonts/libraries).
Each tool lives in its own folder as one `index.html`; the folder name is the
URL slug (lowercase, hyphenated).

**Architecture rule — the one that keeps styling consistent:**
ALL shared styling lives in `/assets/site.css`, loaded by every page. A page's
inline `<style>` may contain ONLY styles unique to that page. If a style would
help a second page, promote it into `site.css`; never copy it between pages.
Shared behavior (theme toggle, year stamp) lives in `/assets/site.js`, loaded
at the end of every `<body>`. The only sanctioned duplication is three small
head lines per page: the pre-paint theme snippet (must be inline to avoid a
flash of the wrong theme), the data-URI favicon, and the site.css `<link>`.

**Design system (`/assets/site.css`), in layer order:**
1. Tokens — CSS custom properties on `:root` for the default "green" (teal)
   theme, with a `[data-theme="blue"]` override block. Key variables:
   `--brand`, `--brand-deep`, `--mid`, `--accent`, `--wash`, `--surface`,
   `--ink`, `--ink-soft`, `--rule`, `--card-bd`, `--ifr` (warning red),
   `--err-bg`/`--err-fg`, `--focus-ring`, `--btn-shadow`, plus `--mono` and
   `--sans` font stacks. Pages NEVER hardcode brand colors; they use tokens,
   so both themes work everywhere automatically.
2. Base — reset, sticky-footer flex body, `.wrap` container (max-width 880px,
   20px side padding), `.sr-only`, `code`, focus-visible outlines.
3. Chrome — `.topbar` (brand + `#theme-btn`), `.masthead` (+ `.eyebrow`,
   `.masthead-desc`, `.intro-note`), `footer` (+ `.source`, `.source-list`,
   `.disclaimer`, `.copyright`).
4. Components — `.sec-label`, `.calc-head` (gradient-underline section head),
   `.block-head` (small bordered sub-head; also styles `.block h2`/`.step h3`),
   `.panel` + `.panel-label` (full-bleed wash input band), `.field-grid`/
   `.field` inputs + hints, `textarea.text-input`, `select.select`,
   `.controls`, `.btn-primary`, `.btn-secondary` (+ `.btn-sm`, active via
   `.active` or `aria-pressed="true"`), `.link-btn`, `.card`, `.tool-list`/
   `.tool-card`, `.chart-frame`, `.callout`, `.summary-list`, `.note-line`,
   `.res-list`/`.res-sublabel`, `.metar-source-hint`, `.error-note`,
   `.range-warn`.

**Typography rule:** headings and labels are sentence case in the `--sans`
stack — no all-caps, no stretched letter-spacing. `.eyebrow` is the large page
title in the masthead. The `--mono` stack is reserved for actual data: the
brand wordmark, code, METAR text, inputs, calc chains, readouts, and
chart/instrument internals (where uppercase is authentic, e.g. cockpit
annunciators and FAA chart labels, it stays).

**Theme system:** `#theme-btn` in the topbar flips green ↔ blue, persists to
`localStorage` key `pd-theme`, recolors the favicon, and fires a `pd:theme`
CustomEvent on `document` (listen for it if a page draws canvas/SVG in theme
colors and needs a redraw). Handled entirely by `/assets/site.js`.

**Intentional page-local palettes (do not "fix" these):**
- `wind-tunnel-decoder/` keeps its two canvases as dark "instruments" (`--inst-bg`,
  `--lift`, `--drag`, `--resultant`, `--stall`, `--amber`) so flow colors stay
  readable; the page around them is fully site-themed.

**Common page skeleton (every page):** `.topbar` → `.masthead` (`.crumbs`
breadcrumb + h1.eyebrow + `.masthead-desc`) → optional `.panel` input band →
`main.wrap` content → `footer` (references → disclaimer → `.copyright` bar
with `#yr`). The breadcrumb is `Home → Tool Name` with Home linked; the
homepage shows a plain `Home` crumb and an h1 of "Home".

**Internal links are ROOT-RELATIVE CLEAN URLS** matching each page's canonical
exactly: brand + breadcrumb link `/`, homepage tool cards and cross-tool links
use `/slug/` (never `/slug/index.html`). This keeps internal linking, canonical
tags, and sitemap.xml all pointing at one URL per page. Local preview requires
a server &mdash; double-click `preview.command` (file:// browsing from Finder no
longer resolves these links). Only external links and canonical/OG/JSON-LD URLs
are absolute. Renamed slugs keep a redirect stub at the old path (meta refresh +
canonical to the new URL, e.g. `/metar/` -> `/metar-decoder/`).

**Adding a new tool — checklist:**
1. Copy `/_template/index.html` to `/your-slug/index.html` and fill in every
   `___PLACEHOLDER___` (SEO title/description/keywords, canonical, OG/Twitter,
   JSON-LD, masthead, content, references).
2. Build the UI from existing `site.css` components before writing any new
   CSS; keep page CSS page-specific.
3. Homepage: add a `.tool-card` to the tool list AND an entry to the JSON-LD
   `hasPart` array in `index.html`.
4. Tool logic is vanilla JS, inline in the page, no external dependencies.
5. If you changed `assets/site.css` or `site.js`, bump the `?v=` query string
   on EVERY page that links them (cache busting).

**Reviewing a page (what to flag):**
- Any `<style>` rule that duplicates something in `site.css`.
- Hardcoded brand hex colors where a token should be used.
- Missing chrome (topbar/theme button/masthead/footer), missing pre-paint
  theme snippet, or missing per-page SEO block.
- Homepage tool list / JSON-LD `hasPart` out of sync with actual folders.

**Local preview:** assets AND internal navigation use relative paths, so the
whole site — styling, theme toggle, and links between pages — works by simply
double-clicking any page in Finder. `preview.command` (double-click) is still
there to serve the site at `http://localhost:8000/` when you want to preview
it exactly as GitHub Pages will serve it.

---
