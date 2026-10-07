**file**: docs/requirements/requirement-shell-script-coding.md
**Status**: Active (Version 1.0.0)
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **specialize-in home** for portable shell coding lessons on springboot-cli. **Without this file, agents bring those lessons raw** and treat coding skills as product law.

It owns residual coding rules for the single-file bash ship unit `src/springboot-cli` that are **not** already owned by peer requirements (output, prefixes, TTY, storage, prompts).

**Scope:** shebang/runtime, `set -u`, no raw `echo` for user messages, Protection Zone comments, `util_source_external_safe`, no `$()` of `read` helpers, own-or-point to peers.  
**Out of scope (cited, not re-owned):** `out_*` catalog (`requirement-shell-output-requirements.md`); prefix families (`requirement-shell-modular-function-design.md`); TTY measure-outside-functions (`requirement-shell-interactive-vs-noninteractive.md`); storage roots (`requirement-shell-cli-storage.md`); command catalog (`requirement-shell-cli-interface.md`).

---

### 1.1 Human-facing

**In one sentence:** This file is where **how the script is written** becomes product law so agents do not copy portable workshop lessons straight into `src/springboot-cli`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Implementer editing `src/springboot-cli` | Keep `set -u`; go through `out_*` |
| The other role | Reviewer checking coding vs peers | Prefixes stay on the modular file |
| Not this file | A second copy of output / TTY / storage tables | Point; do not dump peer bodies |

| Includes | Excludes |
|----------|----------|
| Shebang bash, nounset, Protection Zones, safe source, no `$()` of `read` | Full `out_*` catalog, dest sudoers, Type 1 elevation |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/springboot-cli` | program file people install | coding of helpers |
| `tests/test_cli.sh` | suite | TP-MOD / TP-U |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Edit a helper | Follow this file plus the peer it points at. Do not invent a parallel printer. | Edit `src/springboot-cli`; prove with `./tests/run.sh` |
| Add a confirm | Call `prompt_yes_no` in the current shell. Do not capture it with `$()`. | `springboot-cli uninstall` (TTY) |

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Specialize-in intention (mandatory)

1. **MUST** treat this file as the software-development **coding-style related REQ** for bash.  
2. **MUST** state: without this REQ, portable learned lessons arrive **raw**.  
3. **MUST NOT** tell agents to follow a coding skill as product law.  
4. **MUST** own-or-point: do not duplicate full peer bodies.

### 2.2 Own-or-point

| Slice | Owner | This file |
|-------|-------|-----------|
| Human/JSON printers | `requirement-shell-output-requirements` | Point |
| Prefix families / Protection Zone layout | `requirement-shell-modular-function-design` | Point |
| TTY measure outside functions; helpers consume `TTY` | `requirement-shell-interactive-vs-noninteractive` | Point; residual: no `$()` of `read` helpers |
| Scratch roots / `TMPDIR` | `requirement-shell-cli-storage` | Point |
| In-tool sudo wrap | **intentionally absent** | This product does not wrap `sudo` as a helper family |

### 2.3 Residual coding rules (this product)

1. Shebang **MUST** remain `#!/bin/bash` while SDKMAN requires bash. Why `/bin/sh` cannot run SDKMAN, the login tree `${HOME}/.sdkman`, and the `sdk use` / `sdk default` Java swap are owned by `requirement-domain-springboot-cli.md` §2.5.  
2. **MUST** keep `set -u`. **MUST NOT** add global `set -e`.  
3. User-facing messages **MUST** go through `out_*`. Raw `echo`/`printf` for product UI is forbidden (output peer).  
4. **MUST NOT** capture `prompt_ask` / `prompt_yes_no` / any `read` helper with `$()` or backticks. Call in the current shell.  
5. External rc / SDKMAN init **MUST** go through `util_source_external_safe` (nounset-safe).  
6. **MUST** keep CIAO Protection Zone / `!!! DO NOT MODIFY OR SIMPLIFY !!!` comments on prompt and output helpers. Simplifying those bodies is a regression.  
7. **MUST NOT** cite `template-*` / `skill-*` as behavioral authority in product source (modular peer §2.3.1).  
8. New helpers **MUST** use an existing prefix family (`out_*` / `inst_*` / `app_*` / `util_*` / `ver_*` / `path_*` / `payload_*` / domain `setup_*`) — modular peer.

### 2.4 Implementation Notes (this project)

| Item | Value |
|------|--------|
| **Ship unit** | `src/springboot-cli` (`#!/bin/bash`) |
| **VERSION SSOT** | `VERSION="2.0.0"` |
| **Nounset** | `set -u` at script top |
| **TTY SSOT** | Script top `[ -t 0 ] && [ -t 1 ] && TTY=1` after `: "${TTY:=0}"`; `prompt_*` consume `TTY` |
| **Safe source** | `util_source_external_safe` |
| **Tests** | TP-MOD-01/02 · TP-U-01/03/04/05/06 in `tests/test_cli.sh` / `tests/test_online_curl_install.sh` |

### 2.5 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 2 – Intentional**: Coding lessons have a specialize-in home.  
- **CIAO Principle 1 – Caution**: Nounset + no `$()` of `read` prevent silent empty and hang.  
- **CIAO Principle 4 / 20**: Protection Zones on prompt/output must not be “cleaned up.”

## Under command line for normal user only

When the program detects Termux, Git Bash, Windows Command Prompt, or the same class (this login only; no root switch):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or a **dedicated system user** |
| Helpers run as this login | Add a `sudo` wrap family; wrap `apt`/`dnf`; write `/etc`; recommend `sudo curl \| sh` on that class |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or cmd was detected |

Detect (typical): Termux — `PREFIX` contains `com.termux`. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*`. Windows cmd — `OS` is `Windows_NT` after excluding Git Bash, Cygwin, and WSL.

**This requirement:** coding of helpers stays this-login; do not add elevation wrappers on that class.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Assume nounset, missing HOME, and piped stdin.  
- **Intentional:** Own-or-point; this file is not a second output catalog.  
- **Anti-fragile:** Survive Git Bash / Alpine bash / `curl \| bash`.  
- **Over-protect:** Do not strip Protection Zones or this specialize-in file.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Delete this file and tell agents to follow a coding skill as product law.  
2. Dump full output / TTY / storage / prefix tables here (own-or-point).  
3. Capture `prompt_*` with `$()`.  
4. Drop `set -u` or add global `set -e`.  
5. Strip Protection Zone comments from prompt/output helpers.  
6. Strip the **Under command line for normal user only** section, or enable Type 1/2 helpers on that class.

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry SSOT |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_*` |
| `docs/requirements/requirement-shell-modular-function-design.md` | Prefixes |
| `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | TTY / prompts |
| `docs/requirements/requirement-shell-cli-storage.md` | Scratch roots |
| `src/springboot-cli` | Implementation under test |
| `tests/test_cli.sh` | TP-MOD / TP-U |

**Last Updated**: 2026-09-06  
**Owner**: springboot-cli project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO (https://github.com/cloudgen/ciao); CIAO-Lite.

## Design-time verification

| TP-ID | Suite | Status |
|-------|-------|--------|
| TP-MOD-01 | `tests/test_cli.sh` | have |
| TP-MOD-02 | `tests/test_cli.sh` | have |
| TP-U-01 / TP-U-03 / TP-U-05 | `tests/test_cli.sh` | have |
| TP-U-04 | `tests/test_online_curl_install.sh` | have |
| TP-U-06 | `tests/test_cli.sh` | have (TTY consume / no live `[ -t` in `prompt_*`) |
