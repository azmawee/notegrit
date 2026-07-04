#!/usr/bin/env python3
"""
NoteGrit icon generator - "Amber + Pencil" design (16px native, minimal size).

Design rationale:
  The previous "Gritty Pad" (white paper + spiral binding) read as a generic
  Windows Notepad stock icon at 16px — its silhouette and grit detail were
  indistinguishable from stock at small sizes. This redesign uses a saturated
  amber rounded square (pops on any taskbar) crossed by a bold dark pencil
  diagonal: a distinctive silhouette that stays readable at 16px.

Output (in e:\\notegrit\\):
  notegrit.ico         - single 16px icon, PNG-compressed inside ICO wrapper
                         (~300-400 bytes; keeps notegrit.exe under 15KB)
  notegrit_preview.png - large 256px render for visual inspection only

The icon is drawn NATIVE at 16px (not downscaled from a master), because
downscaling erases the precise pixel placement that makes a tiny icon read.

Run:
  python make_icon.py

This script only writes icon files. It never touches notegrit.asm / .rsrc /
build.bat. To embed, the user updates the .rsrc directory themselves later.
"""

from PIL import Image, ImageDraw

# ---------------------------------------------------------------------------
# Palette - Amber + Pencil
# ---------------------------------------------------------------------------
AMBER       = (232, 116,  59, 255)   # #E8743B saturated background
AMBER_DARK  = (190,  85,  35, 255)   # subtle edge/depth
PENCIL      = ( 26,  26,  26, 255)   # #1A1A1A pencil body
PENCIL_HI   = (245, 245, 240, 255)   # wood/paint highlight
ERASER      = (255, 196, 175, 255)   # pink-amber eraser tip

ICON_PX = 16          # native icon resolution
PREVIEW_PX = 256      # large render for inspection


def render_icon(size):
    """
    Draw the Amber + Pencil icon at the given square size.

    Layout (described in 16px grid units, scaled to `size`):
      - Full rounded-square amber background.
      - A thick dark pencil crossing diagonally top-left -> bottom-right.
        * right end: sharpened wood tip (triangle)
        * left end: short eraser nub
      - One thin highlight stroke along the pencil for definition.
    """
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    s = size  # alias

    # --- background: amber rounded square, filling the canvas -------------
    # small radius so corners are slightly soft but silhouette stays bold
    radius = max(1, size // 6)
    d.rounded_rectangle((0, 0, s - 1, s - 1), radius=radius, fill=AMBER)
    # 1px darker bottom/right edge for a touch of depth (cheap, bold)
    d.rounded_rectangle((0, 0, s - 1, s - 1), radius=radius,
                        outline=AMBER_DARK, width=max(1, size // 32))

    # --- pencil: drawn as a rotated thick rectangle (the body) ------------
    # We approximate the diagonal by drawing the body as a filled polygon
    # so the tip/eraser geometry stays crisp at 16px.
    # Geometry is defined relative to canvas so it scales with `size`.
    u = size / 16.0  # one design unit

    # Pencil runs from upper-left to lower-right but is SHORTER than the
    # full diagonal so the amber square stays the dominant element.
    body_thick = 2.2 * u
    tip_len    = 1.6 * u
    eraser_len = 1.2 * u

    # centerline endpoints (in pixels) — pencil occupies the central ~60%
    cx1, cy1 = 4.5 * u, 4.5 * u    # upper-left of pencil
    cx2, cy2 = 11.5 * u, 11.5 * u  # lower-right of pencil

    # perpendicular unit vector for body thickness
    dx, dy = cx2 - cx1, cy2 - cy1
    L = (dx * dx + dy * dy) ** 0.5
    if L == 0:
        L = 1
    px, py = -dy / L, dx / L   # perpendicular
    hx, hy = body_thick / 2 * px, body_thick / 2 * py

    # pencil body corners (trapezoid), then tip triangle + eraser rect
    # body: from cx1 to cx2, offset by +/- perpendicular
    body = [
        (cx1 - hx, cy1 - hy),
        (cx2 - hx, cy2 - hy),
        (cx2 + hx, cy2 + hy),
        (cx1 + hx, cy1 + hy),
    ]
    d.polygon(body, fill=PENCIL)

    # tip: triangle at the (cx2) end, extending along the centerline direction
    ux, uy = dx / L, dy / L
    tip_base_c = (cx2 + ux * 0.2 * u, cy2 + uy * 0.2 * u)   # base center near cx2
    tip_apex = (cx2 + ux * tip_len, cy2 + uy * tip_len)
    tip = [
        (tip_base_c[0] - hx, tip_base_c[1] - hy),
        (tip_base_c[0] + hx, tip_base_c[1] + hy),
        (tip_apex[0], tip_apex[1]),
    ]
    d.polygon(tip, fill=PENCIL_HI)   # light wood tip

    # eraser: short rounded cap at the (cx1) end
    er_c = (cx1 - ux * eraser_len, cy1 - uy * eraser_len)
    er = [
        (cx1 - hx, cy1 - hy),
        (er_c[0] - hx * 0.8, er_c[1] - hy * 0.8),
        (er_c[0] + hx * 0.8, er_c[1] + hy * 0.8),
        (cx1 + hx, cy1 + hy),
    ]
    d.polygon(er, fill=ERASER)

    # highlight: thin light stroke along upper edge of pencil body
    hl_thick = max(1, size // 32)
    hl_offset = body_thick / 3
    d.line(
        (cx1 + px * hl_offset, cy1 + py * hl_offset,
         cx2 + px * hl_offset, cy2 + py * hl_offset),
        fill=PENCIL_HI, width=hl_thick,
    )

    return img


def main():
    # Native 16px icon — saved as ICO with a single resolution.
    icon_16 = render_icon(ICON_PX)
    icon_16.save("notegrit.ico", format="ICO", sizes=[(ICON_PX, ICON_PX)])

    # Large preview for inspection (NOT for embedding).
    preview = render_icon(PREVIEW_PX)
    preview.save("notegrit_preview.png")

    print("OK -> notegrit.ico (16px) + notegrit_preview.png (256px preview)")
    print("Embed note: single RT_ICON @ index 1; "
          "~300-400 bytes PNG-compressed -> exe stays < 15KB.")


if __name__ == "__main__":
    main()
