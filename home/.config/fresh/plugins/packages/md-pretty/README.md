# md-pretty — Fresh Editor Markdown Preview Plugin

A Fresh terminal editor plugin that renders `.md` files as a beautiful, color-highlighted preview panel — automatically on open, with live re-render as you type.

---

## Features

- Auto-opens a side-by-side preview when you open any `.md` or `.markdown` file
- Live re-render on every edit (debounced 300ms — no lag)
- Styled rendering: headings, code blocks, tables, blockquotes, lists, links, bold/italic
- Color overlays: each element type gets a distinct color (no theme modification)
- Panel reuse: re-renders update the same split, never opens duplicates
- Zero dependencies: pure TypeScript, Fresh plugin API only

---

## Installation

### Option 1 — Copy to plugins directory (recommended)

```bash
cp -r /home/infotech/project/fresh-md-pretty \
      ~/.config/fresh/plugins/packages/md-pretty
```

Then restart Fresh.

### Option 2 — Symlink (for development / live editing)

```bash
ln -s /home/infotech/project/fresh-md-pretty \
      ~/.config/fresh/plugins/packages/md-pretty
```

Restart Fresh. Changes to `plugins/md_pretty.ts` take effect after hot-reload (see below).

### Option 3 — Install from local git URL via command palette

1. Initialize a git repo in the plugin folder:
   ```bash
   cd /home/infotech/project/fresh-md-pretty
   git init && git add . && git commit -m "init"
   ```
2. In Fresh: `Ctrl+P` → `pkg: Install from URL`
3. Enter: `file:///home/infotech/project/fresh-md-pretty`
4. Restart Fresh.

### Option 4 — Hot-reload during development (no restart needed)

1. Open `plugins/md_pretty.ts` in Fresh
2. `Ctrl+P` → `Load Plugin from Buffer`
3. The plugin activates immediately in the current session

---

## Usage

### Auto-open (default behavior)

Just open any `.md` file — the preview panel appears automatically on the right side.

### Commands (via `Ctrl+P`)

| Command | Description |
|---|---|
| `MD Pretty: Toggle Preview` | Open or close the preview panel |
| `MD Pretty: Refresh` | Force re-render (useful after external file changes) |
| `MD Pretty: Set Wrap Width` | Change the column width (default: 80) |
| `MD Pretty: Toggle Auto-Open` | Enable/disable auto-open on `.md` files |
| `MD Pretty: Close` | Close the preview panel |

### Keybindings inside the preview panel

| Key | Action |
|---|---|
| `q` | Close the preview panel |
| `r` | Refresh / re-render |

---

## Rendering Reference

| Markdown | Preview rendering |
|---|---|
| `# Heading 1` | `═══ HEADING ═══` with cyan color |
| `## Heading 2` | `▶ Heading` with underline |
| `### Heading 3` | `◆ Heading` |
| `#### Heading 4` | `◇ Heading` |
| ` ```lang ` | `┌ lang ────────┐` code fence |
| `> blockquote` | `▌ text` dimmed |
| `- list item` | `• item` (nested: `◦`, `▸`, `▹`) |
| `\| table \|` | `│ cell │` with box borders |
| `**bold**` | `❮bold❯` |
| `` `code` `` | `「code」` |
| `[text](url)` | `text ↗` with blue underline |
| `---` | `────────────────` |

---

## Configuration

No config file required. All settings are runtime-adjustable via commands.

To disable auto-open permanently, add to `~/.config/fresh/init.ts`:

```typescript
// Disable md-pretty auto-open
const mdPretty = editor.getPluginApi("md-pretty");
// or simply use: MD Pretty: Toggle Auto-Open from command palette
```

---

## Directory Structure

```
fresh-md-pretty/
├── package.json          # Plugin manifest
├── README.md             # This file
├── plugins/
│   └── md_pretty.ts      # Plugin implementation
├── types/
│   └── fresh.d.ts        # Fresh API type declarations
└── docs/
    └── REPORT.md         # Architecture & design report
```

---

## Requirements

- Fresh editor `>= 0.2.9` (markdown compose mode era)
- No external tools or runtimes required
