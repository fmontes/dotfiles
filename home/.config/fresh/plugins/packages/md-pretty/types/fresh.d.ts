/// <reference no-default-lib="true"/>

interface TextPropertyEntry {
  text: string;
  properties: Record<string, unknown>;
}

interface CreateVirtualBufferOptions {
  name: string;
  mode: string;
  read_only: boolean;
  entries: TextPropertyEntry[];
  ratio?: number;
  panel_id?: string;
}

interface CreateVirtualBufferResult {
  buffer_id: number;
  split_id?: number | null;
}

interface SpawnResult {
  stdout: string;
  stderr: string;
  exit_code: number;
}

interface BufferInfo {
  id: number;
  path: string;
  modified: boolean;
  length: number;
  splits: number[];
}

interface CursorInfo {
  position: number;
  selection: { start: number; end: number } | null;
}

interface ViewportInfo {
  top_byte: number;
  left_column: number;
  width: number;
  height: number;
}

interface FileStat {
  exists: boolean;
  is_file: boolean;
  is_dir: boolean;
  size: number;
  readonly: boolean;
}

interface DirEntry {
  name: string;
  is_file: boolean;
  is_dir: boolean;
}

interface PromptSuggestion {
  text: string;
  description?: string | null;
  value?: string | null;
  disabled?: boolean | null;
  keybinding?: string | null;
}

declare const editor: {
  // Buffer operations
  getActiveBufferId(): number;
  getBufferPath(bufferId: number): string;
  getBufferContent(bufferId: number): string;
  getBufferInfo(bufferId: number): BufferInfo | null;
  insertAtCursor(text: string): void;
  insertAt(bufferId: number, offset: number, text: string): void;
  deleteRange(bufferId: number, start: number, end: number): void;
  replaceBuffer(bufferId: number, content: string): void;

  // Cursor & selection
  getCursorPosition(): number;
  getCursorInfo(bufferId: number): CursorInfo;
  setCursorPosition(bufferId: number, offset: number): void;
  getViewportInfo(bufferId: number): ViewportInfo;

  // Commands & status
  registerCommand(name: string, description: string, handler: string, context?: string): void;
  registerHandler(name: string, handler: (...args: unknown[]) => unknown): void;
  setStatus(message: string): void;
  debug(message: string): void;

  // Events
  on(event: string, handler: string): void;

  // Overlays
  addOverlay(
    bufferId: number,
    id: string,
    start: number,
    end: number,
    r: number,
    g: number,
    b: number,
    underline: boolean
  ): void;
  removeOverlay(bufferId: number, id: string): void;
  removeOverlaysByPrefix(bufferId: number, prefix: string): void;

  // Virtual buffers
  createVirtualBufferInSplit(options: CreateVirtualBufferOptions): Promise<CreateVirtualBufferResult>;
  getTextPropertiesAtCursor(bufferId: number): Array<Record<string, unknown>>;

  // Modes & context
  defineMode(name: string, parent: string, keybindings: [string, string][], bufferLocal?: boolean): void;
  setContext(name: string, active: boolean): void;

  // File system
  readFile(path: string): Promise<string>;
  writeFile(path: string, content: string): Promise<void>;
  fileExists(path: string): boolean;
  fileStat(path: string): Promise<FileStat>;
  readDir(path: string): Promise<DirEntry[]>;
  getPluginDir(): string;

  // Process
  spawnProcess(command: string, args: string[], cwd?: string | null): Promise<SpawnResult>;

  // UI
  openFile(path: string, line: number, column: number): void;
  closeBuffer(bufferId: number): void;
  prompt(message: string, suggestions?: PromptSuggestion[]): Promise<string | null>;

  // Theme
  overrideThemeColors(colors: Record<string, string>): void;
  applyTheme(name: string): void;

  // Plugin API
  exportPluginApi(name: string, api: unknown): void;
  getPluginApi<T = unknown>(name: string): T | null;

  // JSONC
  parseJsonc(text: string): unknown;
};
