**file**: docs/requirements/requirement-shell-payload-online-install.md  
**Status**: Active (Version 1.3.0)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered)

## 1. Purpose

This requirement is the **project Single Source of Truth** for springboot-cli as a **Type O-P payload online installer**: a one-liner / empty argv installs or updates the CLI only, and `setup` installs the Spring Boot payload, with a strict command split between **ship-unit self-care** and **payload install/uninstall**.

**Not the same as** script-alone online install (Type O-S / online-install mold only). Portable mold: **LM-PAYLOAD-ONLINE-INSTALL** (path secondary when molds are available).

**Scope:** Product class O-P; a bare pipe is the CLI; command vocabulary (`setup`/`install`/`uninstall` vs `self-update`/`self-uninstall`); success/error message cases for both layers; ownership map.  
**Out of scope (cited):** Ship-unit download/checksum algorithms (`requirement-shell-automatic-checksum.md`, install primitives in self-management); Spring Boot pins/order detail (`requirement-domain-springboot-cli.md`); full flag catalog depth (`requirement-shell-cli-interface.md`); output function catalog (`requirement-shell-output-requirements.md`).

---

### 1.1 Human-facing

**In one sentence:** This file owns the **two layers** — installing the Spring Boot environment versus installing the `springboot-cli` program itself.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Operator who wants SDKMAN/Java/Maven/demo | `springboot-cli install` |
| The other role | Operator who only wants to update the CLI script | `springboot-cli self-update` |
| Not this file | Host package-manager installs of Java as product law | Do not wrap `apt install openjdk` as this product |

| Includes | Excludes |
|----------|----------|
| `setup` / `install` / `uninstall` = payload; a bare pipe must not reach the payload | `self-update` / `self-uninstall` (self-management file) |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/springboot-cli` | program file people install | `payload_install` / `payload_uninstall` |
| `springboot-cli help` | command | layer wording (payload vs this CLI) |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Payload only | Environment and demo; do not start the app. The CLI binary stays. | `springboot-cli install` |
| Remove demo | Deletes the managed project dir, not `~/.local/bin/springboot-cli`. | `springboot-cli uninstall --force` |

### Identity SSOT (this product — do not diverge)

| Field | Live value (ship unit `src/springboot-cli`) |
|-------|----------------------------------------|
| **APP_NAME** | `springboot-cli` |
| **VERSION** | `2.0.0` |
| **Product class** | **Type O-P — payload online installer** |
| **REPO_USER** / **REPO_NAME** | `cloudgen` / `springboot-cli` |
| **SCRIPT_URL** | composed GitHub raw default |
| **Dispatcher** | `app_main` |
| **Ship-unit SSOT** | `inst_perform_install` / `inst_maybe_install` / `inst_self_update` / `inst_self_uninstall` |
| **Payload SSOT** | `payload_install` / `payload_uninstall` + domain `setup_*` / `run_springboot_project` |

---

## 2. Core rules

### 2.1 Class

| Field | Value |
|-------|--------|
| **Type** | **O-P** (not O-S, not Type N) |
| **Purpose** | Reduce install steps: CLI + SDKMAN/Java/Maven/project (+ optional run) |
| **One-liner** | `curl -fsSL …/src/springboot-cli \| bash` must self-install the CLI **only**. Payload is `setup` |

### 2.2 Command split (normative)

| Command | Layer | Behavior |
|---------|-------|----------|
| *(empty argv)* | Ship unit or menu | Non-interactive, no line switch, no domain payload flag: ship-unit ensure (+ `self-update` when newer) then **exit**. **No** payload. Interactive TTY with no line switch and no domain payload flag: numbered menu (`requirement-shell-cli-default-interaction.md`), no auto payload. A line switch or domain payload flag with no verb stays the payload path |
| `setup` | **Payload** | Payload ensure only (`payload_install`: Alpine check → SDKMAN → Java → Maven → project). **No** ship-unit download. Does **not** start the app |
| `install` | **Payload** | Alias of `setup` |
| `uninstall` | **Payload** | Remove managed **project payload** (`PROJECT_DIR`) only; confirm unless `--force`. **MUST NOT** remove CLI binary. |
| `self-update` | **Ship unit** | Channel upgrade of CLI binary |
| `self-upgrade` | **Ship unit** | Alias of `self-update` |
| `self-uninstall` | **Ship unit** | Remove managed CLI binary only |
| `version-check` | Ship unit | Local vs remote VERSION |
| `version` / `about` / `status` / `help` | Meta | Diagnostics / usage |
| `run` | Payload + run | Domain setup + build/run |
| `reinstall` | Ship + payload | Force ship-unit reinstall then payload ensure (with preserve/`--no-run` as flagged) |

### 2.3 Empty argv (ship unit only)

1. Bootstrap **MUST** always call `app_main "$@"` (no basename gate).  
2. Not installed, no line switch, no domain payload flag → ship-unit install; on success **exit**. **MUST NOT** enter the payload. Human mode names `setup`.  
3. Installed + non-interactive, no line switch, no domain payload flag → apply ship-unit upgrade policy (`inst_self_update` / already-latest OK) then **exit**. **MUST NOT** enter the payload.  
4. Installed + interactive empty argv, no line switch, no domain payload flag → numbered menu. **MUST NOT** auto-run the payload. A second such run is the menu again. A line switch or domain payload flag with no verb still payload-ensures, including on a TTY.  
5. Failures non-zero and **loud** (INC-20260720-001).

### 2.4 Message coverage (must implement)

| Case | Exit | Message path |
|------|------|--------------|
| Ship install OK | 0 | `out_success` path |
| Ship install fail | ≠0 | `out_error` / JSON error code |
| Payload `install` OK | 0 | `out_success` + project_dir |
| Payload `install` fail | ≠0 | which step failed |
| Payload `uninstall` OK | 0 | `out_success` |
| Payload `uninstall` need confirm | ≠0 | `confirm_required` |
| `self-uninstall` need confirm | ≠0 | `confirm_required` |
| `self-update` already latest | 0 | `out_success` |
| Combined empty argv silent | **forbidden** | — |

### 2.5 Implementation Notes

| Item | Value |
|------|--------|
| **Handlers** | `setup` and `install` → `payload_install`; `uninstall` → `payload_uninstall`; `self-update`/`self-upgrade` → `inst_self_update`; `self-uninstall` → `inst_self_uninstall` |
| **Empty argv** | Non-interactive, no line switch, no domain payload flag: ship ensure then exit. Interactive TTY with no line switch: menu (peer) |
| **Payload pins** | `requirement-domain-springboot-cli.md` |
| **Tests** | `tests/test_install_lifecycle.sh`, `test_domain.sh`, `test_cli.sh`, **`test_online_curl_install.sh`** (TP-CURL — real `curl \| bash` against local channel; silent-class ban) — must detect binary-only first pipe, silent 0-byte abort, and missing subcommands |

#### Invocation samples (this topic-owner)

```bash
springboot-cli setup
springboot-cli uninstall --force
springboot-cli run
```

## Under command line for normal user only

When the program detects Termux, Git Bash, Windows Command Prompt, or the same class (this login only; no root switch):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or a **dedicated system user** |
| Payload `install` / `uninstall` run as this login | Wrap `apt`/`dnf` to install Java; write `/etc`; recommend `sudo curl \| sh` on that class |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or cmd was detected |

Detect (typical): Termux — `PREFIX` contains `com.termux`. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*`. Windows cmd — `OS` is `Windows_NT` after excluding Git Bash, Cygwin, and WSL.

**This requirement:** payload ensure stays SDKMAN/this-login; it is not a host package install.

### 2.6 Protection Rule

**MUST NOT:**

1. Treat springboot-cli as Type O-S script-alone.  
2. Map `uninstall` → CLI removal or `self-uninstall` → project wipe as primary.  
3. Enter the payload from a non-interactive empty argv that has no line switch and no domain payload flag. The interactive TTY menu is the peer file.  
4. Silent one-liner success.  
5. Advertise `install`/`uninstall` in help without dispatcher routes.

---

## 3. Definition of done

1. Requirement registered in `docs/requirements/index.md`.  
2. Ship unit implements the command split. A bare pipe stops after the CLI.  
3. Help ↔ dispatcher aligned.  
4. Tests cover payload install/uninstall, self-*, the CLI-only pipe, and loud failures.  
5. Domain pins remain in `requirement-domain-springboot-cli.md`.  

## 4. Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-LC-01–03** | `tests/test_install_lifecycle.sh` | have |
| **TP-DOM-*** | `tests/test_domain.sh` | have |
| **TP-CURP-*** | `tests/test_online_curl_install.sh` | have |

**Suite map:** `tests/README.md` (TP labels in suite files).


## 5. Related

| Artifact | Role |
|----------|------|
| `requirement-shell-cli-zero-arguments.md` | Empty-argv detail |
| `requirement-shell-self-management.md` | self-* only |
| `requirement-domain-springboot-cli.md` | Payload content |
| `requirement-shell-cli-interface.md` | Full command table |
| `tests/README.md` | TP status map |
| `tests/test_online_curl_install.sh` | TP-CURL suite |
| `src/springboot-cli` | Implementation |

## 6. Revision history

| Date | Change |
|------|--------|
| 2026-10-07 | v1.4.0 A pipe with no command is CLI self-install only. `setup` (alias `install`) is the payload. It does not start the app |
| 2026-10-07 | v1.3.0 Dual-mode: interactive empty argv with no line switch is the numbered menu. Non-interactive empty argv stays combined ensure. `install` stays the payload. No `self-install` |
| 2026-07-24 | v1.2.0 Design-time verification TP map (git-surface clean) |
| 2026-07-24 | v1.1.0 DoD + tests: TP-CURL suite |
| 2026-07-20 | v1.0.0 Initial Type O-P product law; install/uninstall vs self-* |

**Suite map:** `tests/README.md` (TP labels in suite files).


