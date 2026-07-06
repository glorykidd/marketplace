# display-slide

Skill plugin that builds single-image (PNG) announcement slides sized for TV/projector display — sponsorship asks, ministry recruitment, event announcements, program info, meeting reminders — for a church, school, or ministry.

## Type

Skill (single entry point, no separate commands or agents).

## Skill

- `skills/display-slide/SKILL.md` — the skill definition. Triggers on requests like "create a slide," "make a display slide/announcement graphic," or requests to iterate on a previously generated slide.

## How it works

Builds one self-contained HTML/CSS file (1920x1080) styled with real webfonts and an editorial look, verifies layout with Playwright bounding-box checks (`scripts/check_layout.py`), then renders it to PNG via a headless-Chromium screenshot. Not the pptx/deck pipeline — this produces a single polished image.

## Bundled assets

- `assets/fonts/` — four starting webfonts (Playfair Display, Great Vibes, Archivo Black, Manrope)
- `references/SKILL_reference.html` — boilerplate HTML structure (header/footer bars, gradients, card patterns) reused across slides
- `scripts/check_layout.py` — Playwright-based bounding-box sanity checker, run before rendering the final PNG

## External dependencies

- `playwright` (with Chromium) — required to render and verify layout

## Notes

This skill fetches organization websites (via `web_fetch`) to pull real content/branding before writing copy, and may download logos/fonts over the network — see `networkExposure: outbound` in `plugin.json`.
