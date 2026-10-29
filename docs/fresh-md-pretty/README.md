# md-pretty, as patched

Vendored from [sunnypdater/fresh-md-pretty](https://github.com/sunnypdater/fresh-md-pretty) at `fa4392c`. It does not run against Fresh 0.4.3 as published, so the working copy here carries seven changes. `upstream/` here holds the originals (`package.json`, `md_pretty.ts`) so the diff stays recoverable when a new release lands.

`03-symlinks.sh` links every file under `home/` into `~/`, so this package installs with the rest of the dotfiles and needs no separate step.

## The seven

| # | Was | Is |
|---|---|---|
| 1 | `fresh.plugins[]` array in the manifest | `fresh.entry`, a single string |
| 2 | entry at `plugins/md_pretty.ts` | entry at the package root |
| 3 | `removeOverlaysByPrefix(...)` | `clearAllOverlays()` |
| 4 | `getBufferContent(id)` | `await getBufferText(id, 0, getBufferLength(id))` |
| 5 | `defineMode("md-pretty-view", "special", [...])` | same without the `"special"` argument |
| 6 | `read_only`, `panel_id`, `result.buffer_id` | `readOnly`, `panelId`, `result.bufferId` |
| 7 | 12 `addOverlay` calls taking positional RGB ints | an options object, `{ fg: [r, g, b] }`, plus `underline: true` where the flag was set |

Items 3–7 are Fresh API drift: the plugin was written against an earlier plugin runtime. Items 1–2 are packaging — Fresh 0.4.3 reads a single `entry`, not a list of plugin objects.

## Upgrading

Diff a new upstream release against `upstream/`, re-apply whichever of the seven still apply, and replace both sides (the package lives in `home/.config/fresh/plugins/packages/md-pretty/`). Fresh runs as a **persistent daemon per workspace**, so nothing takes effect until those die: `pkill fresh` (`fresh --cmd daemon kill <name>` hangs rather than returning).
