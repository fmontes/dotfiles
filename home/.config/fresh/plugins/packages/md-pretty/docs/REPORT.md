# md-pretty Plugin — Architecture & Design Report

## Overview

`md-pretty` is a Fresh terminal editor plugin that renders Markdown files as a styled, color-highlighted read-only preview panel. It opens automatically when a `.md` file is loaded and re-renders live as the user types.

---

## Architecture

### Plugin Entry Point

**File:** `plugins/md_pretty.ts`  
**Runtime:** TypeScript → OXC transpiler → QuickJS sandboxed VM  
**API surface:** Fresh Plugin API (`editor` global object)

---

## Component Breakdown

### 1. State Manager

```typescript
const state = {
  previewBufferId: number | null,   // ID of the virtual preview buffer
  sourceBufferId: number | null,    // ID of the source .md buffer
  debounceTimer: ...,               // setTimeout handle for re-render throttle
  autoOpen: boolean,                // Whether to auto-open on .md files
  wrapWidth: number,                // Column width for rendering (default 80)
}
```

Single shared state object. No external storage — state lives in the QuickJS VM for the session lifetime.

---

### 2. Markdown Parser (`parseLine` + `inlineRender`)

A line-by-line parser. Does **not** build an AST — processes each line independently with a `inCodeBlock` flag for fenced code blocks.

**Supported elements:**

| Element | Detection | Output |
|---|---|---|
| H1–H6 | `# ` prefix count | Decorated text with box chars |
| Horizontal rule | `/^[-*_]{3,}$/` | `─────────` |
| Code fence | ` ``` ` or `~~~` | `┌ lang ──┐` / `└────────┘` |
| Code body | Lines inside fence | Indented + yellow overlay |
| Blockquote | `> ` prefix | `▌ text` |
| Ordered/unordered list | `[-*+]` or `\d+\.` | `•`, `◦`, `▸`, `▹` by nesting level |
| Table row | `\|...\|` | `│ cell │` box format |
| Table separator | `/^\|[-: \|]+\|$/` | `├──┼──┤` |
| Paragraph | fallback | `  text` with inline rendering |

**Inline rendering** (`inlineRender`):
- `**bold**` → `❮bold❯`
- `*italic*` → `_italic_`
- `` `code` `` → `「code」`
- `[text](url)` → `text ↗`
- `![alt](url)` → `🖼  alt`

---

### 3. Render Engine (`renderMarkdown`)

Converts raw markdown string → array of rendered lines.

Adds a header banner and footer hint bar around the content. Returns `string[]` which is then:
1. Converted to `TextPropertyEntry[]` (each line gets `{ line_index: i }` metadata)
2. Passed to `editor.createVirtualBufferInSplit()` with `panel_id: "md-pretty"` for reuse

---

### 4. Overlay Coloring (`applyOverlays`)

After the virtual buffer is created/updated, overlays are applied per-line using `editor.addOverlay()`.

All overlays use the prefix `mdp:` for batch removal before each re-render.

**Color scheme:**

| Element | RGB |
|---|---|
| Banner / H1 | `100, 200, 255` (light blue) |
| H2 | `80, 220, 180` (teal) |
| H3 | `120, 200, 255` (sky blue) |
| H4–H6 | `160, 200, 240` (pale blue) |
| Rules / separators | `80, 80, 120` (dim purple) |
| Blockquote | `160, 160, 160` (gray) |
| Code fence border | `200, 160, 80` (amber) |
| Code body | `220, 200, 120` (yellow) |
| List items | `180, 220, 180` (green) |
| Tables | `180, 180, 220` (lavender) |
| Links | `100, 180, 255` (blue, underlined) |
| Footer | `100, 100, 140` (dim) |

---

### 5. Debounced Re-render

Re-renders are triggered by the `lines_changed` event. A 300ms debounce prevents re-rendering on every keystroke:

```
lines_changed → clearTimeout → setTimeout(300ms) → renderPreview()
```

Only fires if the changed buffer matches `state.sourceBufferId`.

---

### 6. Event Subscriptions

| Event | Handler | Purpose |
|---|---|---|
| `buffer_opened` | `md_pretty_on_open` | Auto-open preview for `.md` files |
| `lines_changed` | `md_pretty_on_change` | Trigger debounced re-render |
| `buffer_closed` | `md_pretty_on_close` | Clean up state when source closes |

---

### 7. Commands

| Command name | Handler | Context |
|---|---|---|
| `MD Pretty: Toggle Preview` | `md_pretty_toggle` | always visible |
| `MD Pretty: Refresh` | `md_pretty_refresh` | always visible |
| `MD Pretty: Set Wrap Width` | `md_pretty_set_width` | always visible |
| `MD Pretty: Toggle Auto-Open` | `md_pretty_toggle_auto` | always visible |
| `MD Pretty: Close` | `md_pretty_close` | `md-pretty-active` context only |

The `md-pretty-active` context is set via `editor.setContext()` when a preview is open, hiding the Close command when no preview exists.

---

## Data Flow Diagram

```
User opens file.md
        │
        ▼
buffer_opened event
        │
        ▼
md_pretty_on_open()
  └─ path ends with .md?
        │ yes
        ▼
renderPreview(bufferId)
  ├─ getBufferContent()
  ├─ renderMarkdown() → string[]
  ├─ build TextPropertyEntry[]
  ├─ createVirtualBufferInSplit()  ──→  preview panel opens
  └─ applyOverlays()              ──→  colors applied

User types in source buffer
        │
        ▼
lines_changed event
        │
        ▼
md_pretty_on_change()
  └─ scheduleRerender() [300ms debounce]
        │
        ▼
renderPreview() [same panel_id → updates in place]
  ├─ removeOverlaysByPrefix("mdp:")
  ├─ re-render content
  └─ applyOverlays()
```

---

## Fresh API Methods Used

| Method | Purpose |
|---|---|
| `editor.getActiveBufferId()` | Get current buffer |
| `editor.getBufferPath(id)` | Check if `.md` file |
| `editor.getBufferContent(id)` | Read markdown source |
| `editor.createVirtualBufferInSplit()` | Create/update preview panel |
| `editor.addOverlay()` | Apply color decorations |
| `editor.removeOverlaysByPrefix()` | Clear old overlays before re-render |
| `editor.defineMode()` | Register `q`/`r` keybindings in preview |
| `editor.closeBuffer()` | Close preview panel |
| `editor.setContext()` | Show/hide context-sensitive commands |
| `editor.setStatus()` | Status bar feedback |
| `editor.prompt()` | Width input dialog |
| `editor.on()` | Subscribe to events |
| `editor.registerCommand()` | Register palette commands |

---

## Design Decisions

### Why line-by-line parsing instead of a full AST?

The QuickJS sandbox has no npm access. A full markdown parser would need to be bundled. Line-by-line parsing covers 95% of real-world markdown with ~100 lines of code and zero dependencies.

### Why virtual buffer instead of modifying the source?

The source `.md` file must remain unmodified. Virtual buffers are read-only by design and don't affect the file on disk.

### Why `panel_id: "md-pretty"` for reuse?

Without `panel_id`, every re-render would open a new split. The panel ID ensures Fresh reuses the existing split, updating content in place.

### Why 300ms debounce?

Fast enough to feel live, slow enough to avoid re-rendering on every character. Matches the feel of VS Code's markdown preview.

### Why overlays instead of ANSI escape codes?

Fresh's virtual buffers render in the TUI — ANSI codes would appear as literal characters. Overlays are the correct API for color decoration.

---

## Limitations

- No image rendering (shows `🖼  alt` placeholder)
- No HTML block rendering (shown as plain text)
- No nested blockquotes
- Table alignment is approximate (fixed 10-char cell width)
- Re-render replaces entire virtual buffer content (no diff/patch)

---

## Future Improvements

- Configurable color scheme via `config.json`
- Scroll sync between source and preview
- Export rendered text to file
- Support for `[[wiki-links]]`
- Configurable auto-open file patterns
