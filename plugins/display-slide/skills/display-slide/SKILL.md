---
name: display-slide
description: Creates polished 1920x1080 PNG announcement/display slides (the kind shown on a lobby TV or before-service projector screen) for a church, school, or ministry — sponsorship asks, ministry recruitment, event announcements, program info, meeting reminders, etc. Use this whenever the user asks to "create a slide," "make a display slide," "make an announcement slide/graphic," or wants a single branded image (not a multi-slide deck) for a church/organization context, especially when they reference "our website" or a specific org's site for content or branding. Also use when the user asks to adjust/iterate on a previously generated slide (spacing, fonts, layout, wording).
---

# Display Slide Creator

Builds single-image (PNG) announcement slides sized for TV/projector display, styled with a warm, editorial look rather than a generic template. Built with HTML/CSS + Playwright screenshot rendering, not the pptx/artifact pipeline — this is for one polished image, not a deck.

## Workflow

1. **Gather real content first.** If the user references an organization's website, `web_fetch` it (and any linked sub-page like `/sponsors`) before writing copy. Pull real facts: address, phone, program tiers/prices, quoted testimonials, meeting structure. Download the org's actual logo with `bash_tool`/`curl` if a URL is discoverable (try `/img/`, `/assets/logos/` style paths, or check the fetched page's image tags). Never fabricate specifics (times, prices, contact info) that weren't given or found — leave them generic ("Monday Nights") or ask, rather than inventing a plausible-sounding number.

2. **Reuse or establish a palette.** If this is one of several slides for the same organization, keep the same base palette/fonts across slides for a "family" look, but give each distinct ministry/topic its own accent color so slides are distinguishable at a glance (e.g. terracotta for the church itself, navy/gold for the school, teal for a grief-support ministry — all sharing the same cream background and serif headline font). Don't just re-skin the same layout; vary structure too (centered hero vs. split corners vs. diagonal banner vs. tier cards) so a slide deck doesn't feel like one template with swapped text.

3. **Fonts:** system fonts look cheap at this size. Use real webfonts via `@font-face` pointing at local files. This skill bundles four starting fonts in `assets/fonts/` (see below); download others as needed from `https://github.com/google/fonts/raw/main/ofl/<family>/<File>.ttf` via `bash_tool curl`. Only ever fetch from the `github.com/google/fonts` host, and only files ending in `.ttf`/`.otf` — never resolve a font "family" name to any other domain. Copy/reference fonts relative to the HTML file's own directory.

   - `PlayfairDisplay-Variable.ttf` / `PlayfairDisplay-Italic.ttf` — warm serif for headlines
   - `GreatVibes-Regular.ttf` — genuine script font (do NOT rely on `font-family: cursive` fallback stacks like "Brush Script MT" — they don't exist on Linux and silently fall back to a plain serif)
   - `ArchivoBlack-Regular.ttf` — bold condensed display type for punchier/modern announcements
   - `Manrope-Variable.ttf` — clean body sans

4. **Build the HTML.** One self-contained file, `width:1920px; height:1080px` on `html,body`, `overflow:hidden`, absolutely-positioned header/footer bars, a hero/content area in between. Reference `SKILL_reference.html` below for the boilerplate structure (gradients, header/footer pattern, card patterns) used across this family of slides.

5. **Verify layout BEFORE eyeballing the render.** Do not just screenshot and squint — this environment does not reliably let you visually inspect PNGs. Use Playwright to query `bounding_box()` for every major block and confirm:
   - No two elements' y-ranges overlap unexpectedly (esp. content vs. footer)
   - Headlines that should be one line actually measure as one line — check via `document.createRange().selectNodeContents(el).getClientRects()`, not just the container box (a block h1 always reports full container width even when wrapped)
   - There's a reasonable, non-huge gap between the last content block and the footer (if the gap is >150-200px, increase padding/margins/font sizes to fill the frame rather than leaving it top-heavy)
   - Logos with a baked-in white/light background (check with a PIL pixel sample at a corner) need a light card/plate behind them if the slide background is dark, or vice versa

   Use the bounding-box check script pattern in `scripts/check_layout.py`.

6. **Render.** `device_scale_factor=2` for crisp text, screenshot to PNG, copy to `/mnt/user-data/outputs/`, `present_files`.

7. **Iterate in place.** Users will ask for small adjustments (font size, alignment, spacing, moving an element) — edit the same HTML file with `str_replace`, re-verify bounding boxes, re-render. Don't rebuild from scratch. When a change frees up or eats vertical space (e.g. un-wrapping a headline, removing a card), proactively rebalance the surrounding margins rather than leaving a lopsided result — flag that you're doing this.

## Common pitfalls (hard-won)

- **Don't sample pixel colors and panic.** If a pixel inside an icon/graphic looks like the page background color, check whether that's literally the icon's intentional stroke color before concluding something is "broken" — cream-on-terracotta strokes will sample as cream. Compare against a point known to be pure background vs. a point known to be inside the shape but away from any stroke.
- **`<line>`/`<path>` SVG elements can occasionally cause real headless-Chromium compositing bugs** when nested inside a `border-radius` + `radial-gradient` parent. If a gradient badge renders with unexplained flat patches, try replacing the SVG glyph with a pure-CSS equivalent (rotated divs, pseudo-elements) as a workaround.
- **Copyright:** if pulling a testimonial quote or program copy from a real org's site, keep quotes short/attributed and prefer paraphrase for anything longer than a line.
- **Don't invent logistics.** If the user says "meets Monday nights" with no time given, the slide should say "Monday Nights" — not a fabricated "7:00 PM."

## File organization

Work in `/home/claude/`. Keep one HTML file per slide (name it for the slide's purpose, e.g. `griefshare_slide.html`) so later edit requests in the same conversation can target it directly. Final PNGs go to `/mnt/user-data/outputs/`.
