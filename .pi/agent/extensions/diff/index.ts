/**
 * Git Diff Viewer Extension
 *
 * /diff           – pick a changed file, view its diff
 * /diff <file>    – jump straight to that file's diff
 *
 * Two sequential overlays:
 *   1. File picker  – select a file (Esc closes)
 *   2. Diff viewer  – scroll the diff (Esc goes back to picker)
 *
 * Pipe-based tools (overlay):      delta, diff-so-fancy, bat, plain
 * Interactive tools (full-screen): tig, lazygit, vimdiff, nvim, …
 *
 * pi --diff-tool delta    # overlay with delta
 * pi --diff-tool tig      # full-screen tig
 * pi --diff-tool auto     # auto-detect (default)
 */

import { execSync, spawnSync } from "node:child_process";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import {
  matchesKey,
  Key,
  truncateToWidth,
  visibleWidth,
  type SelectItem,
  SelectList,
} from "@mariozechner/pi-tui";

const INTERACTIVE_TOOLS = new Set([
  "tig", "lazygit", "gitui", "vimdiff", "nvim", "vim", "vi",
]);

const VIEWPORT = 18;

/** Run a shell command synchronously. Returns stdout or stderr. Never throws. */
function sh(cmd: string, cwd: string): string {
  const r = spawnSync("sh", ["-c", cmd], { cwd, encoding: "utf8" });
  return r.stdout || r.stderr || "";
}

export default function (pi: ExtensionAPI) {

  // ── Tool detection ──────────────────────────────────────────────────────

  let _detected: string | null = null;

  function which(bin: string): boolean {
    try { execSync(`which ${bin}`, { stdio: "pipe" }); return true; } catch { return false; }
  }

  function autoDetect(): string {
    if (_detected) return _detected;
    _detected = ["delta", "diff-so-fancy", "bat"].find(which) ?? "plain";
    return _detected;
  }

  function getTool(): string {
    const f = pi.getFlag("--diff-tool") as string | undefined;
    return f && f !== "auto" ? f : autoDetect();
  }

  function isInteractive(tool: string): boolean {
    return INTERACTIVE_TOOLS.has(tool.trim().split(/\s+/)[0]!);
  }

  // ── Git helpers ─────────────────────────────────────────────────────────

  interface FileEntry { file: string; status: string; }

  function getGitRoot(cwd: string): string {
    return sh("git rev-parse --show-toplevel", cwd).trim() || cwd;
  }

  function getChangedFiles(gitRoot: string): FileEntry[] {
    const out = sh("git status --porcelain --untracked-files=all", gitRoot);
    if (!out.trim()) return [];
    return out.split("\n").filter(Boolean).map(line => {
      const xy   = line.slice(0, 2);
      let   file = line.slice(3);
      if (file.startsWith('"') && file.endsWith('"')) file = file.slice(1, -1);
      if (file.includes(" -> ")) file = file.split(" -> ").pop()!;
      file = file.trim();
      let status = "modified";
      if (xy.trim() === "??")    status = "untracked";
      else if (xy.includes("A")) status = "added";
      else if (xy.includes("D")) status = "deleted";
      else if (xy.includes("R")) status = "renamed";
      else if (xy.includes("U")) status = "unmerged";
      return { file, status };
    }).filter(e => Boolean(e.file));
  }

  function getDiffLines(entry: FileEntry, tool: string, gitRoot: string): string[] {
    const f = entry.file;
    let rawDiff: string;
    if (entry.status === "untracked") {
      rawDiff = `git diff --color=always --no-index -- /dev/null "${f}"; true`;
    } else {
      rawDiff = `git diff --color=always HEAD -- "${f}" 2>/dev/null`
              + ` || git diff --cached --color=always -- "${f}"`;
    }
    const withFmt: Record<string, string> = {
      "delta":         `(${rawDiff}) | DELTA_FEATURES="" delta`,
      "diff-so-fancy": `(${rawDiff}) | diff-so-fancy`,
      "bat":           `(${rawDiff}) | bat --diff --color=always --paging=never`,
    };
    const out = sh(withFmt[tool] ?? rawDiff, gitRoot);
    return out ? out.split("\n") : ["(no diff output)"];
  }

  // ── Overlay 1: file picker ──────────────────────────────────────────────

  function showPicker(
    entries: FileEntry[],
    tool: string,
    theme: ReturnType<Parameters<Parameters<typeof pi.registerCommand>[1]["handler"]>[1]["ui"]["custom"]> extends never ? any : any,
  ) {
    // Theme is captured in the factory closure — typed via the callback parameter below
    return (tui: any, th: any, _kb: any, done: (v: number | null) => void) => {
      const items: SelectItem[] = entries.map(e => ({
        value: e.file, label: e.file, description: e.status,
      }));

      const picker = new SelectList(items, Math.min(entries.length, 14), {
        selectedPrefix: (t: string) => th.fg("accent", t),
        selectedText:   (t: string) => th.fg("accent", t),
        description:    (t: string) => th.fg("muted", t),
        scrollInfo:     (t: string) => th.fg("dim", t),
        noMatch:        (t: string) => th.fg("warning", t),
      });

      picker.onSelect = (item: SelectItem) => {
        const idx = entries.findIndex(e => e.file === item.value);
        done(idx >= 0 ? idx : null);
      };
      picker.onCancel = () => done(null);

      const ac = (s: string) => th.fg("accent", s);
      const dm = (s: string) => th.fg("dim", s);

      function hline(w: number, title = ""): string {
        if (!title) return ac("─".repeat(w));
        const t   = ` ${title} `;
        const rem = Math.max(0, w - visibleWidth(t) - 2);
        return ac("─".repeat(Math.floor(rem / 2)) + t + "─".repeat(Math.ceil(rem / 2)));
      }

      return {
        render(w: number): string[] {
          const n = entries.length;
          return [
            hline(w, `Changed Files · ${tool}`),
            truncateToWidth(dm(` ${n} file${n === 1 ? "" : "s"} — type to filter`), w),
            dm("─".repeat(w)),
            ...picker.render(w),
            dm("─".repeat(w)),
            truncateToWidth(dm("[↑↓] navigate  [enter] view diff  [esc] close"), w),
            hline(w),
          ];
        },
        invalidate() { picker.invalidate(); },
        handleInput(data: string) {
          picker.handleInput(data);
          tui.requestRender();
        },
      };
    };
  }

  // ── Overlay 2: diff viewer ──────────────────────────────────────────────

  function showDiff(
    entries: FileEntry[],
    startIdx: number,
    tool: string,
    gitRoot: string,
  ) {
    // diffLines is computed BEFORE the factory is called, so it exists
    // on the very first render — no async loading, no state switching.
    return (tui: any, th: any, _kb: any, done: (back: boolean) => void) => {
      let fileIdx   = startIdx;
      let diffLines = getDiffLines(entries[fileIdx]!, tool, gitRoot);
      let scroll    = 0;

      const ac = (s: string) => th.fg("accent", s);
      const dm = (s: string) => th.fg("dim", s);

      function hline(w: number, title = ""): string {
        if (!title) return ac("─".repeat(w));
        const t   = ` ${title} `;
        const rem = Math.max(0, w - visibleWidth(t) - 2);
        return ac("─".repeat(Math.floor(rem / 2)) + t + "─".repeat(Math.ceil(rem / 2)));
      }

      function goTo(idx: number) {
        fileIdx   = idx;
        diffLines = getDiffLines(entries[fileIdx]!, tool, gitRoot);
        scroll    = 0;
        tui.requestRender();
      }

      return {
        render(w: number): string[] {
          const file  = entries[fileIdx]!.file;
          const total = entries.length;
          const prev  = fileIdx > 0             ? ac("◀ ") : dm("  ");
          const next  = fileIdx < total - 1     ? ac(" ▶") : dm("  ");

          const slice = diffLines.slice(scroll, scroll + VIEWPORT);
          const rows: string[] = [];
          for (let i = 0; i < VIEWPORT; i++) {
            rows.push(truncateToWidth(slice[i] ?? "", w));
          }

          const end  = Math.min(scroll + VIEWPORT, diffLines.length);
          const info = diffLines.length ? dm(` ${scroll + 1}–${end}/${diffLines.length}`) : "";

          return [
            hline(w, "Git Diff"),
            truncateToWidth(`${prev}${fileIdx + 1}/${total}: ${ac(file)}${next}`, w),
            dm("─".repeat(w)),
            ...rows,
            dm("─".repeat(Math.max(0, w - visibleWidth(info)))) + info,
            truncateToWidth(dm("[j/k] scroll  [^d/^u] page  [g/G] top/bot  [←/→] file  [esc] back  [q] quit"), w),
            hline(w),
          ];
        },
        invalidate() {},
        handleInput(data: string) {
          if (matchesKey(data, "q"))               { done(false); return; }
          if (matchesKey(data, Key.escape))        { done(true);  return; }

          const max = Math.max(0, diffLines.length - VIEWPORT);
          if      (matchesKey(data, "j") || matchesKey(data, Key.down))  scroll = Math.min(scroll + 1, max);
          else if (matchesKey(data, "k") || matchesKey(data, Key.up))    scroll = Math.max(scroll - 1, 0);
          else if (matchesKey(data, Key.ctrl("d")))                      scroll = Math.min(scroll + Math.floor(VIEWPORT / 2), max);
          else if (matchesKey(data, Key.ctrl("u")))                      scroll = Math.max(scroll - Math.floor(VIEWPORT / 2), 0);
          else if (matchesKey(data, "g"))                                scroll = 0;
          else if (matchesKey(data, "G"))                                scroll = max;
          else if (matchesKey(data, Key.left)  || matchesKey(data, "[")) { if (fileIdx > 0)                goTo(fileIdx - 1); return; }
          else if (matchesKey(data, Key.right) || matchesKey(data, "]")) { if (fileIdx < entries.length-1) goTo(fileIdx + 1); return; }
          else return;

          tui.requestRender();
        },
      };
    };
  }

  // ── Flag & command ──────────────────────────────────────────────────────

  pi.registerFlag("diff-tool", {
    description: "Diff tool: auto | delta | diff-so-fancy | bat | plain | tig | lazygit | …",
    type: "string",
    default: "auto",
  });

  pi.registerCommand("diff", {
    description: "Pick a changed file and view its diff",
    handler: async (args, ctx) => {

      const gitRoot = getGitRoot(ctx.cwd);
      const entries = getChangedFiles(gitRoot);

      if (!entries.length) { ctx.ui.notify("No changed files", "info"); return; }

      const tool = getTool();

      // ── Interactive full-screen tools ─────────────────────────────────
      if (isInteractive(tool)) {
        await ctx.ui.custom<void>((tui, _t, _kb, done) => {
          tui.stop();
          process.stdout.write("\x1b[2J\x1b[H");
          spawnSync(process.env.SHELL ?? "/bin/sh", ["-c", tool], {
            stdio: "inherit", cwd: gitRoot,
          });
          tui.start();
          tui.requestRender(true);
          done();
          return { render: () => [], invalidate: () => {} };
        });
        return;
      }

      const overlayOpts = { overlay: true, overlayOptions: { width: "90%" as const, anchor: "center" as const } };

      // If a file arg was passed, skip the picker and go straight to the diff.
      const argIdx = args
        ? entries.findIndex(e => e.file === args.trim() || e.file.endsWith(args.trim()))
        : -1;

      let startIdx = argIdx >= 0 ? argIdx : -1;

      // ── Main loop: picker → diff → back to picker ─────────────────────
      while (true) {

        // Show file picker if we don't have a file to start with
        if (startIdx < 0) {
          const picked = await ctx.ui.custom<number | null>(showPicker(entries, tool, null), overlayOpts);
          if (picked === null) return; // user closed
          startIdx = picked;
        }

        // Show diff viewer. Returns true = "go back to picker", false/null = quit.
        const back = await ctx.ui.custom<boolean>(showDiff(entries, startIdx, tool, gitRoot), overlayOpts);
        if (!back) return;

        // User pressed Esc in diff → loop back to picker
        startIdx = -1;
      }
    },
  });
}
