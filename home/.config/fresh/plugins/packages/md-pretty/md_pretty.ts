/// <reference path="types/fresh.d.ts" />

// ─── State ────────────────────────────────────────────────────────────────────

const state: {
  previewBufferId: number | null;
  sourceBufferId: number | null;
  debounceTimer: ReturnType<typeof setTimeout> | null;
  autoOpen: boolean;
  wrapWidth: number;
} = {
  previewBufferId: null,
  sourceBufferId: null,
  debounceTimer: null,
  autoOpen: true,
  wrapWidth: 80,
};

// ─── Markdown Parser ──────────────────────────────────────────────────────────

interface ParsedLine {
  raw: string;
  rendered: string;
  type:
    | "h1"
    | "h2"
    | "h3"
    | "h4"
    | "h5"
    | "h6"
    | "hr"
    | "blank"
    | "code_fence"
    | "code_body"
    | "blockquote"
    | "list_item"
    | "table_row"
    | "table_sep"
    | "paragraph";
  indent: number;
  lang?: string;
}

function parseLine(line: string, inCodeBlock: boolean, codeLang: string): ParsedLine {
  const trimmed = line.trimStart();
  const indent = line.length - trimmed.length;

  if (inCodeBlock) {
    if (trimmed.startsWith("```") || trimmed.startsWith("~~~")) {
      return { raw: line, rendered: "  " + "─".repeat(state.wrapWidth - 4) + "  ", type: "code_fence", indent: 0 };
    }
    return { raw: line, rendered: "  " + line, type: "code_body", indent: 2, lang: codeLang };
  }

  if (trimmed.startsWith("```") || trimmed.startsWith("~~~")) {
    const lang = trimmed.slice(3).trim() || trimmed.slice(3).trim() || "text";
    const label = lang ? ` ${lang} ` : "";
    const bar = "─".repeat(Math.max(0, state.wrapWidth - 4 - label.length));
    return { raw: line, rendered: `  ┌${label}${bar}┐`, type: "code_fence", indent: 0, lang };
  }

  if (trimmed.startsWith("# ")) {
    const text = trimmed.slice(2).trim();
    const pad = "═".repeat(Math.max(0, state.wrapWidth - text.length - 2));
    return { raw: line, rendered: `\n  ${text}  ${pad}\n`, type: "h1", indent };
  }
  if (trimmed.startsWith("## ")) {
    const text = trimmed.slice(3).trim();
    return { raw: line, rendered: `\n  ▶ ${text}\n  ${"─".repeat(text.length + 2)}`, type: "h2", indent };
  }
  if (trimmed.startsWith("### ")) {
    return { raw: line, rendered: `\n  ◆ ${trimmed.slice(4).trim()}`, type: "h3", indent };
  }
  if (trimmed.startsWith("#### ")) {
    return { raw: line, rendered: `  ◇ ${trimmed.slice(5).trim()}`, type: "h4", indent };
  }
  if (trimmed.startsWith("##### ")) {
    return { raw: line, rendered: `  · ${trimmed.slice(6).trim()}`, type: "h5", indent };
  }
  if (trimmed.startsWith("###### ")) {
    return { raw: line, rendered: `  · ${trimmed.slice(7).trim()}`, type: "h6", indent };
  }

  if (/^[-*_]{3,}$/.test(trimmed)) {
    return { raw: line, rendered: "  " + "─".repeat(state.wrapWidth - 4), type: "hr", indent: 0 };
  }

  if (trimmed.startsWith("> ")) {
    const content = inlineRender(trimmed.slice(2));
    return { raw: line, rendered: `  ▌ ${content}`, type: "blockquote", indent };
  }

  if (/^(\s*)([-*+]|\d+\.) /.test(line)) {
    const match = line.match(/^(\s*)([-*+]|\d+\.) (.*)/);
    if (match) {
      const lvl = Math.floor(match[1].length / 2);
      const bullet = /\d+\./.test(match[2]) ? match[2] : ["•", "◦", "▸", "▹"][Math.min(lvl, 3)];
      const content = inlineRender(match[3]);
      return { raw: line, rendered: `  ${"  ".repeat(lvl)}${bullet} ${content}`, type: "list_item", indent: lvl * 2 };
    }
  }

  if (trimmed.startsWith("|") && trimmed.endsWith("|")) {
    if (/^\|[-: |]+\|$/.test(trimmed)) {
      const cols = trimmed.split("|").filter((c) => c.trim()).length;
      const sep = "├" + Array(cols).fill("─".repeat(12)).join("┼") + "┤";
      return { raw: line, rendered: "  " + sep, type: "table_sep", indent: 0 };
    }
    const cells = trimmed
      .slice(1, -1)
      .split("|")
      .map((c) => ` ${inlineRender(c.trim()).padEnd(10)} `);
    return { raw: line, rendered: "  │" + cells.join("│") + "│", type: "table_row", indent: 0 };
  }

  if (trimmed === "") {
    return { raw: line, rendered: "", type: "blank", indent: 0 };
  }

  return { raw: line, rendered: "  " + inlineRender(trimmed), type: "paragraph", indent };
}

function inlineRender(text: string): string {
  return text
    .replace(/\*\*(.+?)\*\*/g, "❮$1❯")
    .replace(/__(.+?)__/g, "❮$1❯")
    .replace(/\*(.+?)\*/g, "_$1_")
    .replace(/_(.+?)_/g, "_$1_")
    .replace(/`(.+?)`/g, "「$1」")
    .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1 ↗")
    .replace(/!\[([^\]]*)\]\([^)]+\)/g, "🖼  $1");
}

function renderMarkdown(content: string): string[] {
  const lines = content.split("\n");
  const output: string[] = [];
  let inCode = false;
  let codeLang = "";

  output.push("");
  output.push("  " + "═".repeat(state.wrapWidth - 4));
  output.push("  MARKDOWN PREVIEW");
  output.push("  " + "═".repeat(state.wrapWidth - 4));
  output.push("");

  for (const line of lines) {
    const parsed = parseLine(line, inCode, codeLang);

    if (parsed.type === "code_fence") {
      if (!inCode) {
        inCode = true;
        codeLang = parsed.lang ?? "text";
      } else {
        inCode = false;
        codeLang = "";
      }
    }

    for (const renderedLine of parsed.rendered.split("\n")) {
      output.push(renderedLine);
    }
  }

  output.push("");
  output.push("  " + "─".repeat(state.wrapWidth - 4));
  output.push("  [md-pretty] Press q to close  •  r to refresh");
  output.push("  " + "─".repeat(state.wrapWidth - 4));
  output.push("");

  return output;
}

// ─── Overlay Coloring ─────────────────────────────────────────────────────────

function applyOverlays(bufferId: number, lines: string[]): void {
  editor.clearAllOverlays(bufferId); // was removeOverlaysByPrefix, gone in fresh 0.4.3

  let offset = 0;
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const len = line.length + 1;

    if (line.includes("═") || line.includes("MARKDOWN PREVIEW")) {
      editor.addOverlay(bufferId, `mdp:banner:${i}`, offset, offset + len, { fg: [100, 200, 255] });
    } else if (/^\s+▶ /.test(line)) {
      editor.addOverlay(bufferId, `mdp:h2:${i}`, offset, offset + len, { fg: [80, 220, 180] });
    } else if (/^\s+◆ /.test(line)) {
      editor.addOverlay(bufferId, `mdp:h3:${i}`, offset, offset + len, { fg: [120, 200, 255] });
    } else if (/^\s+◇ /.test(line) || /^\s+· /.test(line)) {
      editor.addOverlay(bufferId, `mdp:h4:${i}`, offset, offset + len, { fg: [160, 200, 240] });
    } else if (/^\s+─+/.test(line) || /^\s+═+/.test(line)) {
      editor.addOverlay(bufferId, `mdp:rule:${i}`, offset, offset + len, { fg: [80, 80, 120] });
    } else if (/^\s+▌ /.test(line)) {
      editor.addOverlay(bufferId, `mdp:quote:${i}`, offset, offset + len, { fg: [160, 160, 160] });
    } else if (/^\s+┌/.test(line) || /^\s+└/.test(line)) {
      editor.addOverlay(bufferId, `mdp:code_border:${i}`, offset, offset + len, { fg: [200, 160, 80] });
    } else if (/^\s{2}  /.test(line) && line.trim() !== "") {
      editor.addOverlay(bufferId, `mdp:code_body:${i}`, offset, offset + len, { fg: [220, 200, 120] });
    } else if (/^\s+[•◦▸▹]/.test(line)) {
      editor.addOverlay(bufferId, `mdp:list:${i}`, offset, offset + len, { fg: [180, 220, 180] });
    } else if (/^\s+│/.test(line) || /^\s+├/.test(line)) {
      editor.addOverlay(bufferId, `mdp:table:${i}`, offset, offset + len, { fg: [180, 180, 220] });
    } else if (line.includes("↗")) {
      editor.addOverlay(bufferId, `mdp:link:${i}`, offset, offset + len, { fg: [100, 180, 255], underline: true });
    } else if (line.includes("[md-pretty]")) {
      editor.addOverlay(bufferId, `mdp:footer:${i}`, offset, offset + len, { fg: [100, 100, 140] });
    }

    offset += len;
  }
}

// ─── Render Engine ────────────────────────────────────────────────────────────

async function renderPreview(sourceBufferId: number): Promise<void> {
  const path = editor.getBufferPath(sourceBufferId);
  if (!path.endsWith(".md") && !path.endsWith(".markdown")) return;

  // getBufferContent is gone in fresh 0.4.3; getBufferText(id, start, end) replaces it.
  const content = await editor.getBufferText(sourceBufferId, 0, editor.getBufferLength(sourceBufferId));
  const lines = renderMarkdown(content);
  const text = lines.join("\n");

  const entries = lines.map((line, i) => ({
    text: line + "\n",
    properties: { line_index: i },
  }));

  editor.defineMode("md-pretty-view", [
    ["q", "md_pretty_close"],
    ["r", "md_pretty_refresh"],
  ], true);

  const result = await editor.createVirtualBufferInSplit({
    name: `  Preview: ${path.split("/").pop()}`,
    mode: "md-pretty-view",
    readOnly: true,
    entries,
    ratio: 0.45,
    panelId: "md-pretty",
  });

  state.previewBufferId = result.bufferId;
  state.sourceBufferId = sourceBufferId;

  applyOverlays(result.bufferId, lines);
  editor.setStatus("md-pretty: preview rendered");
}

// ─── Debounced Re-render ──────────────────────────────────────────────────────

function scheduleRerender(): void {
  if (state.debounceTimer !== null) {
    clearTimeout(state.debounceTimer);
  }
  state.debounceTimer = setTimeout(() => {
    state.debounceTimer = null;
    if (state.sourceBufferId !== null) {
      renderPreview(state.sourceBufferId).catch(() => {
        editor.setStatus("md-pretty: render error");
      });
    }
  }, 300);
}

// ─── Event Handlers ───────────────────────────────────────────────────────────

globalThis.md_pretty_on_open = function (data: { buffer_id: number; path: string }): void {
  if (!state.autoOpen) return;
  if (!data.path.endsWith(".md") && !data.path.endsWith(".markdown")) return;
  renderPreview(data.buffer_id).catch(() => {
    editor.debug("md-pretty: failed to render on open");
  });
};

globalThis.md_pretty_on_change = function (data: { buffer_id: number }): void {
  if (data.buffer_id !== state.sourceBufferId) return;
  scheduleRerender();
};

globalThis.md_pretty_on_close = function (data: { buffer_id: number }): void {
  if (data.buffer_id === state.sourceBufferId) {
    state.sourceBufferId = null;
    state.previewBufferId = null;
    editor.setContext("md-pretty-active", false);
  }
};

// ─── Commands ─────────────────────────────────────────────────────────────────

globalThis.md_pretty_toggle = async function (): Promise<void> {
  const bufferId = editor.getActiveBufferId();
  const path = editor.getBufferPath(bufferId);

  if (!path.endsWith(".md") && !path.endsWith(".markdown")) {
    editor.setStatus("md-pretty: not a markdown file");
    return;
  }

  if (state.previewBufferId !== null && state.sourceBufferId === bufferId) {
    editor.closeBuffer(state.previewBufferId);
    state.previewBufferId = null;
    state.sourceBufferId = null;
    editor.setContext("md-pretty-active", false);
    editor.setStatus("md-pretty: preview closed");
  } else {
    await renderPreview(bufferId);
    editor.setContext("md-pretty-active", true);
  }
};

globalThis.md_pretty_refresh = async function (): Promise<void> {
  const bufferId = state.sourceBufferId ?? editor.getActiveBufferId();
  await renderPreview(bufferId);
};

globalThis.md_pretty_close = function (): void {
  if (state.previewBufferId !== null) {
    editor.closeBuffer(state.previewBufferId);
    state.previewBufferId = null;
    state.sourceBufferId = null;
    editor.setContext("md-pretty-active", false);
    editor.setStatus("md-pretty: preview closed");
  }
};

globalThis.md_pretty_set_width = async function (): Promise<void> {
  const input = await editor.prompt("Set preview wrap width (current: " + state.wrapWidth + "):", [
    { text: "60", value: "60" },
    { text: "80", value: "80" },
    { text: "100", value: "100" },
    { text: "120", value: "120" },
  ]);
  if (input) {
    const w = parseInt(input, 10);
    if (!isNaN(w) && w >= 40 && w <= 200) {
      state.wrapWidth = w;
      editor.setStatus(`md-pretty: wrap width set to ${w}`);
      scheduleRerender();
    }
  }
};

globalThis.md_pretty_toggle_auto = function (): void {
  state.autoOpen = !state.autoOpen;
  editor.setStatus(`md-pretty: auto-open ${state.autoOpen ? "enabled" : "disabled"}`);
};

// ─── Register Commands ────────────────────────────────────────────────────────

editor.registerCommand("MD Pretty: Toggle Preview", "Open or close the markdown preview panel", "md_pretty_toggle");
editor.registerCommand("MD Pretty: Refresh", "Force re-render the markdown preview", "md_pretty_refresh");
editor.registerCommand("MD Pretty: Set Wrap Width", "Set the preview column wrap width", "md_pretty_set_width");
editor.registerCommand("MD Pretty: Toggle Auto-Open", "Enable/disable auto-open on .md files", "md_pretty_toggle_auto");
editor.registerCommand("MD Pretty: Close", "Close the preview panel", "md_pretty_close", "md-pretty-active");

// ─── Event Subscriptions ──────────────────────────────────────────────────────

editor.on("buffer_opened", "md_pretty_on_open");
editor.on("lines_changed", "md_pretty_on_change");
editor.on("buffer_closed", "md_pretty_on_close");

// ─── Init ─────────────────────────────────────────────────────────────────────

editor.setStatus("md-pretty: loaded — open any .md file or use 'MD Pretty: Toggle Preview'");
