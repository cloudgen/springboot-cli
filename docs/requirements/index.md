# Requirements index

**Product:** springboot3 — bash (`#!/bin/bash`) Type 0 self-install / self-maintenance CLI plus a Spring Boot line switch (default 3.3.5, opt-in 2.7.18)  
**Identity SSOT:** ship unit `src/springboot-cli` Project Constants — `APP_NAME="springboot3"`, `VERSION="1.0.1"`, `REPO_USER="cloudgen"`, `REPO_NAME="springboot-cli"`, `SCRIPT_REL="src/springboot-cli"`, `SCRIPT_URL` composed from `REPO_USER`, `REPO_NAME`, and `SCRIPT_REL`. Requirements **must not** invent a different product name, channel, or version.  
**Workspace state:** Specialized product law — identity SSOT retargeted; Implementation Notes use **live** `src/springboot-cli` helpers; class law Active (`requirement-class-software-dev`); domain law registered (`requirement-domain-springboot3`).  
**Live Implementation honesty:** Product naming SSOT = A prefixes (`out_*`, `inst_*`, `app_main`) on live ship unit (§3.1 option 1). Non-interactive empty argv = Type O-P combined ensure (domain **run**). Interactive TTY with no line switch and no domain payload flag = numbered menu in `src/springboot-cli` (`requirement-shell-cli-default-interaction`). A pipe with no command stays combined ensure. Automatic checksum Shape A when companion present. JSON success/error types = `out_success` / `out_error`.
**Sufficiency note:** Class + domain + storage + integrity law registered; help↔dispatcher / force / hybrid empty-argv / Shape A+B checksum / cache-folder storage / TTY menu / menu language are in the ship unit. Suite after that work: PASS=314 FAIL=0 SKIP=1 (TP-MENU-01..05 and TP-LANG-01 **have**; TP-CLI-05 and TP-CLI-12 **have**). Storage: per-login per-process cache chain, persistence `${HOME}/.local/springboot3`, `EFFECTIVE_STORAGE_DIR` + `TMPDIR` in main, about cache fields. The menu language leaf is inside persistence, not the cache. Residual: optional downgrade JSON code wording; JSON error on stdout vs stderr.  
**Updated:** 2026-10-07 (public repository cloudgen/springboot-cli; cache-folder storage Active 1.2.0; TTY menu and 13 languages; ship unit `src/springboot-cli`; VERSION 1.0.1)

| ID / key | Title | Area | Status | Path | Updated |
|----------|-------|------|--------|------|---------|
| requirement-class-software-dev | Software-development class law + residual stack (bash Type O-P + menu/language pointers) | class | Active | `requirement-class-software-dev.md` | 2026-10-07 |
| requirement-shell-automatic-checksum | Automatic companion-digest integrity (transparent link/value/result; CHECKSUM not help/about) | shell | Active | `requirement-shell-automatic-checksum.md` | 2026-07-15 |
| requirement-shell-cli-interface | Shell CLI interface (commands, flags, dispatch, modes, `menu`/`main`) | shell | Active | `requirement-shell-cli-interface.md` | 2026-10-07 |
| requirement-shell-cli-storage | Shell CLI storage (cache folder per login and process; persistence under ~/.local/springboot3) | shell | Active | `requirement-shell-cli-storage.md` | 2026-10-07 |
| requirement-shell-cli-zero-arguments | Empty argv Type O-P combined ensure on non-interactive runs; TTY menu is the peer file | shell | Active | `requirement-shell-cli-zero-arguments.md` | 2026-10-07 |
| requirement-shell-idempotency | Shell idempotency / re-run safety for ensure-style ops | shell | Active | `requirement-shell-idempotency.md` | 2026-10-07 |
| requirement-shell-interactive-vs-noninteractive | Interactive vs non-interactive / `curl\|bash` behavior | shell | Active | `requirement-shell-interactive-vs-noninteractive.md` | 2026-10-07 |
| requirement-shell-modular-function-design | Single-file modular function design (prefixes, zones) | shell | Active | `requirement-shell-modular-function-design.md` | 2026-07-15 |
| requirement-shell-script-coding | Shell coding-style related REQ (specialize-in home; without it, portable lessons arrive raw) | shell | Active | `requirement-shell-script-coding.md` | 2026-09-06 |
| requirement-shell-output-requirements | Central `out_*` output SSOT (stdout/stderr, modes) | shell | Active | `requirement-shell-output-requirements.md` | 2026-07-15 |
| requirement-shell-payload-online-install | Type O-P payload online installer (combined ensure; install/uninstall vs self-*) | shell | Active | `requirement-shell-payload-online-install.md` | 2026-10-07 |
| requirement-shell-self-management | Ship-unit self-management (`self-update`, `self-uninstall`, version-check, about) | shell | Active | `requirement-shell-self-management.md` | 2026-07-20 |
| requirement-domain-springboot3 | Spring Boot payload content (line switch: default Boot 3.3.5 / Java 21, opt-in Boot 2.7.18 / Java 8, project preserve, build/run) | domain | Active | `requirement-domain-springboot3.md` | 2026-10-07 |
| requirement-shell-cli-default-interaction | TTY numbered menu (Boot 3, Boot 2, setup only, language, self-management) and the dual-mode matrix | shell | Active | `requirement-shell-cli-default-interaction.md` | 2026-10-07 |
| requirement-shell-cli-language | Menu language: 13 codes, language leaf, human help/about copy | shell | Active | `requirement-shell-cli-language.md` | 2026-10-07 |

**Rules for agents:**

1. Treat rows above as the **live product-law inventory** for springboot3. Product identity (`APP_NAME` and friends) is owned by `src/springboot-cli` — re-read disk; do not reintroduce names from seed/other projects.  
2. **Do not invent** additional `requirement-*.md` paths — verify on disk and add a registry row in the same change when creating one.  
3. Product source comments cite **only** these live requirement files (or future registered ones) — never `template-*` / `skill-*` as behavioral authority.  
4. This versioned surface lists **requirement rows only** — do not dump templates / skills / terminologies / incidents path inventories here (git-surface; INC-20260712-005).  
5. Keep Status and Path in sync with each file’s header when status changes.  
6. **Registry discipline (summary only):** invent no paths; same-change file+row; empty registry valid at genesis; this file stays **requirement rows only** (no harness tree dumps).

When adding a requirement: append a row, create the file under `docs/requirements/`, keep Status in sync with the file header.
