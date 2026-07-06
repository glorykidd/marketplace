"""
Layout sanity-checker for display slides.

Usage:
    python3 check_layout.py /path/to/slide.html "sel1,sel2,sel3"

Prints each selector's bounding box (in CSS px, at 1920x1080 viewport) so you can
confirm blocks don't overlap and there's a sensible gap before the footer, BEFORE
you spend time on a full-resolution screenshot render.

Requires playwright (sync API) to already be installed in the environment.
"""
import sys
from playwright.sync_api import sync_playwright


def check(html_path, selectors):
    with sync_playwright() as p:
        b = p.chromium.launch()
        page = b.new_page(viewport={"width": 1920, "height": 1080})
        page.goto(f"file://{html_path}")
        page.wait_for_timeout(300)

        boxes = {}
        for sel in selectors:
            els = page.query_selector_all(sel)
            if not els:
                print(f"  [!] no match for selector: {sel}")
                continue
            for i, el in enumerate(els):
                bb = el.bounding_box()
                label = sel if len(els) == 1 else f"{sel}[{i}]"
                boxes[label] = bb
                print(f"{label:30s} {bb}")

        b.close()
        return boxes


def check_line_wrap(html_path, selector):
    """Report actual rendered line rects for a text element (catches false
    single-line assumptions on block elements that silently wrapped)."""
    with sync_playwright() as p:
        b = p.chromium.launch()
        page = b.new_page(viewport={"width": 1920, "height": 1080})
        page.goto(f"file://{html_path}")
        page.wait_for_timeout(300)
        rects = page.evaluate(
            """(sel) => {
                const el = document.querySelector(sel);
                if (!el) return null;
                const range = document.createRange();
                range.selectNodeContents(el);
                return Array.from(range.getClientRects()).map(r => (
                    {top: r.top, left: r.left, right: r.right, width: r.width}
                ));
            }""",
            selector,
        )
        b.close()
        print(f"line rects for {selector}: {rects}")
        return rects


if __name__ == "__main__":
    html_path = sys.argv[1]
    selectors = sys.argv[2].split(",") if len(sys.argv) > 2 else [
        ".header", ".hero", ".cards", ".footer"
    ]
    check(html_path, selectors)
