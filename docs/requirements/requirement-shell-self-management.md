**file**: docs/requirements/requirement-shell-self-management.md  
**Status**: Active (Version 1.0.0)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **CLI self-management** of the springboot3 bash shell tool: inspecting, upgrading, and removing its own installed binary (and related install artifacts) safely—especially for tools installed via one-command online install (`curl | sh`)—without requiring a separate package-manager workflow for routine updates.

It defines lifecycle capabilities and safety rules for this shell project’s self-management commands.

**Scope:** Lifecycle capabilities and safety rules for **ship-unit** commands only: `version-check`, `self-update` / `self-upgrade`, `self-uninstall`, and `about` (plus reuse of ship-unit install primitives).  
**Out of scope (cited, not re-owned):** Payload `install` / `uninstall` / domain setup (`requirement-shell-payload-online-install.md`, `requirement-domain-springboot3.md`); full CLI dispatcher catalog (`requirement-shell-cli-interface.md`); pure re-run matrix (`requirement-shell-idempotency.md`); Type 1/2 ops.

**Must not confuse with:** Payload `install`/`uninstall` (environment/project), OS package managers, or domain start/stop.

---

### 1.1 Human-facing

**In one sentence:** This file owns **updating and removing the CLI program** (`springboot3` on your PATH), not the Spring Boot demo folder.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Operator who installed the script | `springboot3 self-update` |
| The other role | Publisher who ships `src/springboot-cli` and `src/springboot-cli.sha256` | Companion digest next to the channel URL |
| Not this file | `uninstall` of the demo project | `springboot3 uninstall --force` |

| Includes | Excludes |
|----------|----------|
| `version-check`, `self-update` (refuse silent downgrade), `self-uninstall`, `about` | Maven/Java pins (domain file) |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/springboot-cli` | program file people install | `inst_self_update` / `inst_self_uninstall` / `ver_check` |
| `springboot3 about` | command | diagnostics for this CLI |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Compare versions | Local VERSION versus the channel file. A louder error beats a silent skip. | `springboot3 version-check` |
| Remove the CLI | Deletes the installed script. It does not delete your demo sources unless you also uninstall payload. | `springboot3 self-uninstall` |

### Identity SSOT (this product — do not diverge)

| Field | Live value (ship unit `src/springboot-cli`) |
|-------|----------------------------------------|
| **APP_NAME** | `springboot3` |
| **VERSION** | `1.0.1` |
| **REPO_USER** / **REPO_NAME** | `cloudgen` / `springboot-cli` |
| **SCRIPT_URL** | `https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli` |
| **Shebang / runtime** | `#!/bin/bash` (SDKMAN requires bash) |
| **Dispatcher** | `app_main` (A naming) |
| **Output SSOT** | `out_text` / `out_json` / `out_json_error` (+ wrappers `out_info`/`out_success`/`out_warn`/`out_error`/`out_die`) |
| **Install SSOT** | `inst_perform_install` / `inst_maybe_install` / `inst_is_installed` / `inst_get_version` |

Live scalars are owned by the ship unit Config block. Requirement **cores** stay portable; **Implementation Notes** must match the table above. On conflict with Config, use product identity protocol (ask; do not invent dual owners). Domain Spring Boot ops (`setup_sdkman`, `setup_java`, `setup_maven`, `setup_springboot_project`, `run_springboot_project`) are **in addition** to Type 0 lifecycle.

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Command surface (self-management)

User-facing names **MUST** be stable unless this requirement is explicitly revised:

| Command | Purpose | Typical flags |
|---------|---------|----------------|
| `version-check` | Compare **local CLI** version with **remote/latest** | `--quiet`, `--json` |
| `self-update` | Update the installed **CLI ship unit** to a newer trusted release | `--force` |
| `self-upgrade` | **Alias** of `self-update` (same handler) | `--force` |
| `self-uninstall` | Remove the managed **CLI binary** only; clean PATH when safe | `--force` |
| `about` | Diagnostics and version / install context | `--quiet`, `--json` |

**Not owned here:** `install` / `uninstall` (payload) — see `requirement-shell-payload-online-install.md`.

Shell implementation **SHOULD** keep install/lifecycle and dispatch callable as clear helpers. **This product** uses A names (`inst_perform_install`, `inst_self_update`, `app_main`, …) — product law (§3.1 option 1). Domain helpers (`setup_*` / `run_springboot_project`) are allowed for Spring Boot specialization.

Related Type 0 commands (`version`, `install`, `help`) are owned by `requirement-shell-cli-interface.md` but **MUST** stay consistent with this lifecycle model.

### 2.2 Self-update (normative)

| Requirement | Meaning |
|-------------|---------|
| Trusted source | Fetch only from the configured official channel (project Config / env — not ad hoc URLs in random helpers) |
| Semver compare | Prefer upgrade when remote is **newer**; **MUST NOT** downgrade without explicit force policy |
| Integrity | Checksum or digest verification before replace when downloading update artifacts |
| Atomic install | Download to temp → verify → atomic move/replace of the installed binary |
| Install type preserved | Per-user vs global/system-wide placement remains consistent with invoker privilege / install policy |
| Reuse install SSOT | Self-update **MUST** reuse the same install orchestrator primitives as first-time install (no second ad hoc download/replace path) |
| Output SSOT | All messages via centralized `out_*` |

### 2.3 Version check (normative)

| Requirement | Meaning |
|-------------|---------|
| Dual report | Human mode shows local and remote/latest |
| Semver | Same comparison helper family as update (e.g. pure POSIX `ver_gt`) |
| Fail loud | Unset/unreachable channel **MUST NOT** be reported as “already latest” |
| Machine mode | `--json` emits structured result via output SSOT |

### 2.4 Self-uninstall (normative)

| Requirement | Meaning |
|-------------|---------|
| Locate binary | Resolve path from install type / Config (`GLOBAL_BIN` / `USER_BIN` / privilege), not scattered absolute path literals in business logic |
| Remove binary | Delete only the managed CLI file(s) this tool owns |
| PATH cleanup | Edit shell config PATH entries **only if** the managed bin directory is empty after removal (or equivalent safe policy) |
| Confirmation | Interactive confirm unless `--force` / non-interactive policy applies |
| No over-delete | **MUST NOT** wipe unrelated user data or arbitrary home trees |
| Idempotent absence | Already uninstalled → success no-op (see idempotency requirement) |

### 2.5 About / diagnostics (normative)

| Requirement | Meaning |
|-------------|---------|
| Context | Version, install presence/paths, execution user, shell/TTY hints as designed |
| Modes | Respect `--quiet` / `--json` |
| Guidance | When not installed, may show recommended install one-liner using configured channel patterns (no secrets) |

### 2.6 Privilege model (default for self-management)

| Type | Self-management default |
|------|-------------------------|
| **Type 0 (invoker)** | **Yes** — `version-check`, `about`, `self-update`, `self-uninstall` for invoker-owned CLI install |
| **Type 1 / Type 2** | **Not required** for base CLI self-management; do not invent a system-user requirement solely for binary lifecycle |

Root may write global install path; non-root uses user path. Do not assume root for every self-management command.

### 2.7 Sacred safety rules

| Rule | Detail |
|------|--------|
| **No silent downgrade** | Without explicit force policy, refuse remote older than local |
| **No skip integrity** | Digest/checksum path required for downloaded update artifacts — automatic companion is default; strict pin secondary. Full automatic transparency law: `requirement-shell-automatic-checksum.md` |
| **No weak atomicity** | Avoid partial replaces that leave a broken binary |
| **No reckless PATH edit** | Only clean PATH when managed bin dir is empty / policy-safe |
| **No raw I/O** | Use output SSOT; quiet/json channel rules |
| **No secrets in tree** | Never embed tokens or credentials in update URLs in docs/code; Config/env only |
| **Idempotent where sensible** | Already-latest update and already-removed uninstall must not corrupt state |

### 2.8 Implementation Notes (this project)

| Item | Value for springboot3 |
|------|------------------------|
| **Product / binary** | `springboot3` (`APP_NAME`) |
| **Implementation file** | `src/springboot-cli` |
| **Dispatcher** | `app_main` routes `version-check` → `ver_check`; `self-update` → `inst_self_update`; `self-uninstall` → `inst_self_uninstall`; `about` → `app_about` |
| **Install orchestrator SSOT** | `inst_perform_install` (download → `util_verify_download_integrity` → place binary) |
| **Version compare** | `ver_gt`; local version via `inst_get_version` |
| **Install presence** | `inst_is_installed` |
| **Paths** | `GLOBAL_BIN` default `/usr/local/bin`; `USER_BIN` default `${HOME}/.local/bin` |
| **Repository identity** | `REPO_USER` default `Wilgat`; `REPO_NAME` default `springboot3` |
| **Release channel** | `SCRIPT_URL` with `:=` default composed from `REPO_*` and repo-relative path `src/springboot-cli` (override via env). `APP_NAME` stays the installed command name. |
| **Strict digest pin** | Runtime `CHECKSUM` → Shape B path inside `util_verify_download_integrity` (**not** in help/about) |
| **Companion digest** | Default `${SCRIPT_URL}.sha256` via `util_verify_download_integrity` — `requirement-shell-automatic-checksum.md` |
| **Force reinstall** | CLI `--force` → `FORCE=1` **and** `FORCE_REINSTALL=1` in `app_main` |
| **Uninstall** | `inst_self_uninstall` (bin resolve via `util_get_install_bin_path`; confirm / `confirm_required`; remove; optional PATH cleanup) |
| **PATH ensure** | `path_add_shell` / `path_in_path` on user install |
| **Privilege** | Type 0 only for self-management surface; no dedicated system user |
| **Version SSOT** | `VERSION` default `1.0.1` in script config block (`VERSION="1.0.1"`) |

#### Normative acceptance behaviors (this project)

1. **`version-check`:** Fetch remote `VERSION` from `SCRIPT_URL`; report local vs remote; JSON fields include local/remote and latest-status semantics; fail if channel missing/unreachable.  
2. **`self-update`:**  
   - Fail if remote version cannot be fetched.  
   - If local equals remote and force off → success no-op (“already latest”).  
   - If remote is **older** than local and force off → **refuse** (no silent downgrade).  
   - If remote is newer (or force policy allows reinstall) → set reinstall and call `inst_perform_install` with integrity + atomic replace.  
3. **`self-uninstall`:** Resolve binary; confirm when interactive and force off; remove only that binary; clean PATH only if `~/.local/bin` empty (non-root); never delete unrelated trees.  
4. **`about`:** Human diagnostics + JSON about object; no secrets; **no `CHECKSUM` name/value**.  
5. **Shared install path:** Self-update **must not** introduce a parallel curl-to-final-path overwrite outside `inst_perform_install*`.

#### Invocation samples (this topic-owner)

```bash
springboot3 version
springboot3 version-check
springboot3 self-update
springboot3 self-upgrade
springboot3 self-uninstall
springboot3 about
```

#### Compliance notes (implementation status) — re-read disk 2026-07-15

| Item | Status |
|------|--------|
| Downgrade gate via `ver_gt` (refuse unless force) | **Implemented** — newer-local refuses without force; `--force` sets `FORCE_REINSTALL` for deliberate path |
| CLI `--force` → `FORCE=1` **and** `FORCE_REINSTALL=1` | **Implemented** — `app_main` flag parse |
| Uninstall JSON without force | **Implemented** — `confirm_required` + non-zero; binary remains |
| Uninstall `--force` removes binary | **Implemented** — suite regression |
| Integrity on install/self-update download | **Implemented** — `util_verify_download_integrity` |
| `SCRIPT_URL` default channel URL | **Implemented** — product default + env override (`:=`) |
| Residual | Downgrade JSON uses success “newer local” wording (not always `downgrade_blocked` code) — live contract; optional A-parity later |

### 2.9 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Block silent downgrade and unsafe uninstall; verify downloads.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Separate version-check, self-update, self-uninstall, and about.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): Per-user and global installs; temp + atomic replace survive partial failure.  
- **CIAO Principle 4/12 – Output & traceability** (https://github.com/cloudgen/ciao): Central Output SSOT (`out_*`); JSON/human modes.  
- **CIAO Principle 8 – Least privilege** (https://github.com/cloudgen/ciao): Type 0 invoker default for CLI lifecycle.  
- **CIAO Principle 9 – Safe temp files** (https://github.com/cloudgen/ciao): `mktemp`, cleanup on error.  
- **CIAO Principle 18 – Over-protect** (https://github.com/cloudgen/ciao): Digest, atomicity, PATH empty-dir check are sacred.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Never trust network bytes without verification path; never silent downgrade.  
- **Intentional:** One orchestrator for install and update; clear command separation.  
- **Anti-fragile:** Works for root global and user local; idempotent no-ops when already good.  
- **Over-protect:** Do not simplify away checksum layers, atomic move, or safe PATH cleanup.  
- **SSOT:** Channel via `SCRIPT_URL`/Config; install via `inst_perform_install*`; output via Output SSOT.  
- **Idempotency:** Align with `requirement-shell-idempotency.md` for already-latest / already-uninstalled.  
- **Respect old working logic:** Preserve Protection Zones on install and self-management helpers.

---

## Under command line for normal user only

When the program detects Termux, Git Bash, Windows Command Prompt, or the same class (this login only; no root switch):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or a **dedicated system user** |
| `self-update` / `self-uninstall` target this login’s bin | Recommend `sudo curl \| sh`; write `/etc`; `useradd` |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or cmd was detected |

Detect (typical): Termux — `PREFIX` contains `com.termux`. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*`. Windows cmd — `OS` is `Windows_NT` after excluding Git Bash, Cygwin, and WSL.

**This requirement:** self-care of the CLI stays this-login; do not escalate to replace `/usr/local/bin` on that class.

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Remove or weaken checksum/digest verification on self-update downloads.  
2. Bypass semantic version comparison to allow silent downgrades without force.  
3. Replace atomic install with in-place curl overwrite of the live binary.  
4. Remove the empty-directory (or equivalent safe) PATH cleanup guard on uninstall.  
5. Over-delete user data or non-owned paths during uninstall.  
6. Change standard self-management command names without updating this requirement and help together.  
7. Use raw user-facing `echo`/`printf` instead of the centralized output system.  
8. Hard-code project secrets or private tokens into update URLs in the tree.  
9. Require a dedicated system user solely for Type 0 CLI self-update without a specialized architecture requirement.  
10. Invent a second update implementation path that bypasses `inst_perform_install*`.

**Self-management is critical for long-term maintainability of one-command shell CLIs. Violating this rule is a critical regression.**

---

## 5. Definition of done (shell self-management)

Work claiming self-management support for springboot3 is **not done** if any of the following fail:

1. User-facing lifecycle commands exist and are routed (`version-check`, `self-update`, `self-uninstall`, `about`).  
2. Update path verifies integrity (pinned and/or companion digest policy) and uses atomic replace via install SSOT.  
3. Downgrade is blocked without explicit force policy.  
4. Uninstall does not over-delete and cleans PATH only when safe.  
5. Version-check reports local and remote (or fails loud if channel missing).  
6. All messages go through output SSOT; `--json` stays machine-oriented when claimed.  
7. Project channel/path facts live in Config/env / Implementation Notes—not scattered hardcodes.  
8. Idempotent already-latest / already-uninstalled behaviors hold.  
9. Implementation changes cite `requirement-shell-self-management`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-shell-cli-interface.md` | Command surface, flags, dispatcher |
| `docs/requirements/requirement-shell-idempotency.md` | Re-run safety for ensure ops |
| `docs/requirements/requirement-shell-output-requirements.md` | Lifecycle messaging / quiet / JSON |
| `docs/requirements/requirement-shell-modular-function-design.md` | Live function families (`out_*`, lifecycle, util) |
| `docs/requirements/requirement-shell-automatic-checksum.md` | Companion / pin integrity on install path |
| `docs/requirements/index.md` | Registry SSOT |
| `src/springboot-cli` | Implementation under test |

---

**Last Updated**: 2026-09-06  
**Owner**: springboot3 project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO Principles 1, 2, 3, 8, 9, 18 (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).

### Live function inventory (ship unit — A naming)

**Product law inventory** (live `src/springboot-cli` — §3.1 option 1 (A naming); live `out_*`/`inst_*`/`app_*` (A naming)):

| Area | Live names |
|------|------------|
| Output | `out_text`, `out_json`, `out_json_error`, `out_info`, `out_success`, `out_warn`, `out_error`, `out_die`, `out_plain`, `out_plain`, `out_msg_n` |
| Install / lifecycle | `inst_perform_install`, `inst_maybe_install`, `inst_is_installed`, `inst_get_version`, `util_get_install_bin_path`, `inst_self_update`, `inst_self_uninstall`, `ver_check`, `ver_gt` |
| Dispatch | `app_main`, `app_help`, `app_about` |
| Domain | `setup_sdkman`, `setup_java`, `setup_maven`, `setup_springboot_project`, `run_springboot_project`, `check_alpine_requirements` |
| PATH | `path_add_shell`, `path_in_path`, per-shell helpers as present |

Compliance claiming seed-prefix inventory as Implemented is **false** until rename or notes mark **target vs live**.

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-LC-04–08** | `tests/test_install_lifecycle.sh` | have |
| **TP-CLI-11** | `tests/test_cli.sh` | have |

**Suite map:** `tests/README.md` (TP labels in suite files).


