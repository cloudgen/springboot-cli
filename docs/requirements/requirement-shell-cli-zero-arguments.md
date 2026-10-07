**file**: docs/requirements/requirement-shell-cli-zero-arguments.md  
**Status**: Active (Version 1.4.1)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered)

> ### Payload installer law (read first — this product)
>
> springboot3 is a **payload installer (Type O-P)** (**Type O-P**): empty argv / `curl \| bash` **MUST** reduce install steps via **combined ensure** — ship-unit self-install (and non-interactive self-update when policy requires) **plus** payload (SDKMAN / Java / Maven / project / optional run).
>
> | Situation | Empty argv **MUST** mean |
> |-----------|---------------------------|
> | **Non-interactive** (no TTY, pipe, `--json`, `--quiet`), not installed | Ship-unit install-ensure **then continue into payload ensure** — **MUST NOT** exit after binary place alone |
> | **Non-interactive**, installed (local or global) | Ship-unit **auto-upgrade** when remote newer / policy; **then payload ensure** (`cmd=run`) — **not** help; **not** a binary-only “already installed” no-op |
> | **Interactive TTY**, no line switch, no domain payload flag | Numbered menu (`requirement-shell-cli-default-interaction.md`). **MUST NOT** auto-run the payload. A second such run is the menu again. |
> | **Line switch or domain payload flag**, no positional verb | Payload path for that line, including on a TTY. Not the menu. |
>
> Portable Type O-S “already installed → install no-op only” and “first pipe = binary only” are **superseded** by Type O-P and `requirement-domain-springboot3.md`. **MUST NOT** dump help for bare `springboot3`. **MUST NOT** silent-success one-liner with no message and no install.

## 1. Purpose

This requirement is the **project Single Source of Truth** for **zero-argument (empty argv) dispatcher behavior** of the springboot3 bash (`#!/bin/bash`) CLI, specialized as a **Type O-P payload installer** (combined self-install/self-update + domain payload ensure).

### 1.0 Product type (template dual-axis model)

| Field | Value for springboot3 |
|-------|------------------------|
| **Empty-argv type** | **Type O-P — Online payload installer** (not Type N; not Type O-S script-alone) |
| **Rationale** | Product advertises `curl … \| bash` to set up a full Spring Boot environment (CLI + SDKMAN/Java/Maven/project), not only place a script file |

Type N (non-online-install → empty argv = help) does **not** apply. Type O-S (binary-only ensure) does **not** apply.

It defines what happens when the tool is invoked with **no command and no flags**, including the classic one-liner:

```sh
curl -fsSL https://raw.githubusercontent.com/cloudgen/springboot-cli/main/springboot3 | bash
```

Empty argv detect cases:

| Case | Meaning | Empty-argv outcome (this product — Type O-P) |
|------|---------|-----------------------------------------------|
| **Not installed** | No managed binary at the resolved install path(s) | Non-interactive: ship-unit install **then payload ensure**. Interactive TTY with no line switch: numbered menu, no auto payload |
| **Installed (local)** | Managed binary at the user path (`USER_BIN` / `${HOME}/.local/bin/springboot3`) | Non-interactive: upgrade policy + **payload ensure**. Interactive TTY with no line switch: numbered menu again |
| **Installed (global)** | Managed binary at the global path (`GLOBAL_BIN` / `/usr/local/bin/springboot3`) | Same split as local for the global path |

**Scope:** Empty-argv routing, Type O-P combined ensure, detect cases (global / local / absent), force boundary, exit status, TTY / quiet / json, **loud one-liner outcomes**.  
**Out of scope (own requirements):** Full command catalog (`requirement-shell-cli-interface.md`); domain pipeline depth (`requirement-domain-springboot3.md`); download/checksum detail (`requirement-shell-automatic-checksum.md`); full self-update/uninstall lifecycle detail (`requirement-shell-self-management.md` — reused on empty argv for upgrade policy); output function catalog (`requirement-shell-output-requirements.md`); general idempotency matrix beyond empty-argv rows (`requirement-shell-idempotency.md`).

---

### 1.1 Human-facing

**In one sentence:** This file owns **what a run with no arguments does** — a pipe installs the program and the Spring Boot demo, and a terminal with no extra switch opens the numbered menu.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Someone pasting the one-liner, or typing the name on a terminal | `curl … \| bash` or `springboot3` |
| The other role | CI using explicit `install` / `--no-run` | `springboot3 --no-run` |
| Not this file | A help-default program that never installs | Empty arguments must not dump help |

| Includes | Excludes |
|----------|----------|
| Pipe: place the CLI if needed, then ensure SDKMAN/Java/Maven/demo. Terminal with no line switch: the numbered menu | Removing the CLI (`self-uninstall`); the menu’s row text (peer file) |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./springboot3` | program file people install | empty-argv path in `app_main` |
| One-liner | `curl -fsSL …/springboot3 \| bash` | first combined ensure |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| First pipe | Empty arguments must not stop after copying the script. The demo environment is part of that pipe. | `curl … \| bash` |
| Terminal, no switch | The numbered menu opens. The demo does not start until a row is chosen. | `springboot3` |
| Setup only | Skip build/run after the environment is ready. | `springboot3 --no-run` |

### Identity SSOT (this product — do not diverge)

| Field | Live value (ship unit `./springboot3`) |
|-------|----------------------------------------|
| **APP_NAME** | `springboot3` |
| **VERSION** | `1.0.0` |
| **REPO_USER** / **REPO_NAME** | `cloudgen` / `springboot-cli` |
| **SCRIPT_URL** | `https://raw.githubusercontent.com/cloudgen/springboot-cli/main/springboot3` |
| **Shebang / runtime** | `#!/bin/bash` (SDKMAN requires bash) |
| **Dispatcher** | `app_main` (A naming) |
| **Output SSOT** | `out_text` / `out_json` / `out_json_error` (+ wrappers `out_info`/`out_success`/`out_warn`/`out_error`/`out_die`) |
| **Install SSOT** | `inst_perform_install` / `inst_maybe_install` / `inst_is_installed` / `inst_get_version` |

Live scalars are owned by the ship unit Config block. Requirement **cores** stay portable; **Implementation Notes** must match the table above. On conflict with Config, use product identity protocol (ask; do not invent dual owners). Domain Spring Boot ops (`setup_sdkman`, `setup_java`, `setup_maven`, `setup_springboot_project`, `run_springboot_project`) are **in addition** to Type 0 lifecycle.

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Definitions (portable + project)

| Term | Definition for springboot3 |
|------|----------------------------|
| **Type O-P** | Payload installer (Type O-P): non-interactive empty argv = combined ship-unit + payload ensure (this product). Interactive TTY empty argv with no line switch is the numbered menu. |
| **Type O-S** | Script-alone online tool — **out of scope** as product class (binary-only). |
| **Type N** | Non-online-install empty-argv type: empty argv = help — **out of scope** for springboot3. |
| **Empty argv / zero-arg** | `$# -eq 0` at entry to `app_main` (no command tokens; classic `curl \| sh` with no trailing args). |
| **Ship-unit install-ensure** | Converge to “managed `springboot3` binary present” (install / upgrade / force replace). |
| **Payload ensure** | Domain pipeline: SDKMAN / Java / Maven / project + optional `run_springboot_project` (`requirement-domain-springboot3.md`). |
| **Combined ensure** | Ship-unit layer then payload layer without requiring a second user command. |
| **Not installed** | `inst_is_installed` returns false (`inst_get_version` → `not installed`). |
| **Installed (local)** | Executable at `${USER_BIN}/springboot3` (default `USER_BIN=${HOME}/.local/bin`) observed by install-detect SSOT. |
| **Installed (global)** | Executable at `${GLOBAL_BIN}/springboot3` (default `GLOBAL_BIN=/usr/local/bin`) observed by install-detect SSOT. |
| **Force / reinstall** | `FORCE_REINSTALL=1` from `--force` / `reinstall` (and related wiring in `app_main`). Required only for deliberate replace, not for ensure. |

### 2.2 Single meaning of empty argv (Type O-P combined ensure)

1. When **argv is empty**, the run is **non-interactive** (no TTY, pipe, `--quiet`, or `--json`), and the tool is **not installed**, `app_main` **MUST** run **ship-unit install** then **payload ensure** — **MUST NOT** route to `app_help`, and **MUST NOT** exit after binary place alone.  
2. When **argv is empty** and the run is **non-interactive** and the tool is **installed**, `app_main` **MUST** apply **ship-unit auto-upgrade** when remote is newer or force policy requires (reuse `inst_self_update` / `inst_perform_install` primitives); then **payload ensure**. **MUST NOT** dump help or treat a binary-only no-op as full success.  
2a. When **argv is empty** and the run is an **interactive TTY** with no line switch and no domain payload flag, `app_main` **MUST** open the numbered menu in `requirement-shell-cli-default-interaction.md` and **MUST NOT** auto-run the payload. A second such run is the menu again.  
2b. A line switch or a domain payload flag with no positional verb **MUST** run that payload path, including on a TTY. That invocation is not the menu. The silent Config default `BOOT_LINE` of `3` is not a line switch.  
3. Explicit `springboot3 help` remains the only full-usage path for help text.  
4. Bootstrap **MUST** always call `app_main "$@"` so pipe one-liners reach this contract (no `${0##*/}` product-name gate).  
5. Empty argv **MUST NOT** require the user to pass `install` or a second invocation merely to get SDKMAN/Java/Maven after first pipe.  
6. Outcomes **MUST** be loud: visible progress/success via `out_*` or non-zero failure — **silent exit 0 with no install is forbidden** (INC-20260720-001).

### 2.3 Normative case matrix (Type O-P)

| Case | Detect condition (project) | Empty argv, force off (this product) | Empty argv / deliberate install force |
|------|----------------------------|--------------------------------------|---------------------------------------|
| **A. Not installed** | `inst_is_installed` false | Non-interactive: ship-unit install (§2.4) **then payload ensure**. Interactive TTY, no line switch, no domain payload flag: numbered menu | Non-interactive: same + force placement as designed. A domain payload flag still selects the payload path |
| **B. Installed — local** | User binary present via detect SSOT | Non-interactive: upgrade policy + **payload ensure** — **no help**. Interactive TTY, no line switch, no domain payload flag: numbered menu again | `self-update` / `reinstall` / `--force` for deliberate binary replace |
| **C. Installed — global** | Global binary present via detect SSOT | Same split as B for the global path | Same as B |

**Portable Type O-S “already-installed = install no-op”** is seed pattern for script-alone CLIs only. **This product is Type O-P.** Do not claim binary-only no-op or first-pipe-binary-only as Implemented for springboot3 empty argv.

**Already-installed rules (Cases B and C, empty argv, force off) — Type O-P:**

1. **MUST NOT** dump full help.  
2. **Non-interactive:** **MUST** enter the domain/payload pipeline (default `run`) per `requirement-domain-springboot3.md`. **Interactive TTY** with no line switch and no domain payload flag: **MUST** open the numbered menu and **MUST NOT** enter that pipeline until a leaf chooses it.  
3. Non-interactive: **MUST** attempt ship-unit upgrade when version-check says remote is newer (or document temporary Gap until implemented).  
4. Detect **MUST** treat either global or local managed binary as installed when that is how `inst_is_installed` / `inst_get_version` resolve paths.  
5. Exit status and messaging for domain run follow domain + output requirements (build/run may long-run / exec; `--no-run` may exit 0 after setup).

### 2.4 Case A — not installed (modes) — ship unit then payload

| Mode | Required empty-argv behavior |
|------|------------------------------|
| **Interactive** (TTY stdin+stdout, not quiet/json), no line switch, no domain payload flag | Open the numbered menu. Do not auto-place and do not auto-run the payload |
| **Non-interactive** (non-TTY / `curl \| sh`) | Auto ship-unit install + **payload ensure** without hang |
| **Quiet or JSON** | Ship-unit install + payload ensure without prompts; JSON purity for structured paths |
| **Failure** (network, checksum, I/O, payload) | Non-zero exit; no fake success; no help-only output; **no silent no-op** |

**Placement privilege:**

| Invoker | Target |
|---------|--------|
| root (`id -u` 0), e.g. `curl … \| sudo bash` | `${GLOBAL_BIN}/springboot3` → `/usr/local/bin/springboot3` |
| non-root | `${USER_BIN}/springboot3` → `${HOME}/.local/bin/springboot3` |

### 2.5 Equivalence / non-equivalence

| Invocation | Contract (this product) |
|------------|-------------------------|
| Empty argv, not installed, non-interactive | Combined ensure (ship unit + payload) |
| Empty argv, installed, non-interactive | Upgrade policy + payload ensure — **not** binary-only no-op |
| Empty argv, interactive TTY, no line switch, no domain payload flag | Numbered menu. Not a payload run |
| Explicit `self-update` | Ship-unit upgrade lifecycle (may not run payload unless fallthrough designed) |
| `reinstall` | Force ship unit then domain pipeline (live) |
| `help` | Usage only — **not** empty-argv default |

### 2.6 Forbidden empty-argv outcomes

1. Dump full help when Case A/B/C should ensure.  
2. Silent success when Case A should install (no message, no binary).  
3. Exit after ship-unit install without payload ensure (Type O-S collapse).  
4. Treat Case B/C empty argv as binary-only success no-op while claiming Type O-P compliance.  
5. Require `--force` solely because detect says installed (for normal re-run / domain use).  
6. Blind re-download every empty-argv run without force (unless upgrade policy requires).  
7. Basename-gate main so `curl \| sh` never hits the empty-argv branch.  
8. Detect only one of global/local incorrectly contrary to `inst_is_installed` family SSOT.

### 2.7 Implementation Notes (this project)

| Item | Value for springboot3 |
|------|------------------------|
| **Empty-argv type** | **Type O-P — Payload installer** (combined ensure; not Type N; not Type O-S) |
| **Product / binary** | `springboot3` (`APP_NAME`) |
| **Ship unit** | Repo root `./springboot3` |
| **Dispatcher** | `app_main` — empty-argv block **before** flag/command parse default help |
| **Ship-unit ensure** | `inst_perform_install` / `inst_maybe_install` / `inst_self_update` (upgrade policy) |
| **Payload ensure** | Domain pipeline after ship unit: `setup_sdkman` → `setup_java` → `setup_maven` → `setup_springboot_project` → optional `run_springboot_project` |
| **Detect SSOT** | `inst_is_installed` ← `inst_get_version` |
| **Global path** | `GLOBAL_BIN` default `/usr/local/bin` |
| **Local path** | `USER_BIN` default `${HOME}/.local/bin` |
| **Force wiring** | `--force` → `FORCE=1` and `FORCE_REINSTALL=1` in `app_main` |
| **Output SSOT** | `out_success` / `out_info` / `out_json` / errors via `out_*` |
| **Channel** | `SCRIPT_URL` (compose from `REPO_USER` / `REPO_NAME` / `APP_NAME`) for download path inside install |
| **Live status** | Non-interactive Type O-P combined ensure is implemented in `app_main`. **Gap:** a TTY empty argv still falls through to the payload. The numbered menu is required by `requirement-shell-cli-default-interaction.md` and is not in the ship unit yet. |
| **Tests** | `tests/test_cli.sh`; `tests/test_install_lifecycle.sh`; `tests/test_online_curl_install.sh`; map `tests/README.md` |

#### Dispatcher algorithm (normative sketch — Type O-P target)

```text
app_main:
  if [ $# -eq 0 ]; then
    if interactive TTY and not quiet and not json:
      open numbered menu (requirement-shell-cli-default-interaction)
      return
    if not inst_is_installed:
      ship-unit install (inst_maybe_install / inst_perform_install per mode)
      on failure → exit non-zero
      # MUST NOT exit here on success — fall through to payload
    else
      if upgrade needed:
        ship-unit self-update / force policy
    fi
    # payload ensure (domain default run) — non-interactive only
    cmd=run → domain pipeline
  fi
  # else parse flags/commands…
  # line switch or domain payload flag and no positional verb → payload path, not the menu
  # menu/main on a TTY → same tree; menu/main with no TTY → out_die
```

#### Message contract (human)

- Ship-unit progress/success and payload progress via `out_*`  
- Failures loud and non-zero  
- **MUST NOT** print the full `app_help` usage body on empty-argv ensure path  
- **MUST NOT** complete with zero output when install was expected

### 2.8 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): One-liner must not be silent or look like success when nothing installed.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Non-interactive empty argv means **combined ensure**. Interactive empty argv with no line switch means the numbered menu.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): Dual install paths + `curl \| bash` + full environment converge.  
- **CIAO Principle 5 – Single point of entry** (https://github.com/cloudgen/ciao): `app_main` owns empty-argv before help default.  
- **CIAO Principle 14 – Interactive vs non-interactive** (https://github.com/cloudgen/ciao): Auto under pipe; upgrade policy non-interactive.  
- **CIAO Principle 18 – Over-protect** (https://github.com/cloudgen/ciao): Protection Rule against help-fallback and O-P→O-S collapse.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Real failures non-zero and loud; healthy re-runs clear text.  
- **Intentional:** Help is never the empty-argv default; payload is part of first pipe.  
- **Anti-fragile:** Global and local detect; second one-liner upgrades + re-ensures environment.  
- **Over-protect:** Do not simplify empty-argv to help or binary-only exit.  
- **SSOT:** `inst_*` for ship unit; domain helpers for payload; `out_*` for messages.  
- **Idempotent ensure:** Payload and ship unit detect-then-ensure.

---

## Under command line for normal user only

When the program detects Termux, Git Bash, Windows Command Prompt, or the same class (this login only; no root switch):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or a **dedicated system user** |
| Empty arguments still combined-ensure into this login’s bin and payload | Recommend `sudo curl \| sh` as the empty-argv path on that class |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or cmd was detected |

Detect (typical): Termux — `PREFIX` contains `com.termux`. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*`. Windows cmd — `OS` is `Windows_NT` after excluding Git Bash, Cygwin, and WSL.

**This requirement:** empty arguments must not become a root install on that class.

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Route empty argv to `app_help` when ensure should run.  
2. Collapse Type O-P to Type O-S (exit after binary place; skip payload).  
3. Require `--force` for a healthy already-installed empty-argv re-run solely because the binary exists.  
4. Handle only Case A and leave B/C as accidental help fallthrough.  
5. Break dual-path detect so local or global installs are misclassified.  
6. Blindly reinstall ship unit every empty-argv run without force/upgrade policy.  
7. Exit 0 with **no message** and **no install** for a claimed one-liner (silent success).  
8. Reintroduce a basename-only gate that skips `app_main` under `curl \| bash`.  
9. Bypass `out_*` for empty-argv user messages.  
10. Document “already installed → help” or pure binary no-op as full empty-argv success for this product.

**Violating this rule is a critical zero-arg / payload-installer / online-install regression.**

---

## 5. Definition of done

This requirement is satisfied when all of the following hold:

1. Empty argv + not installed + non-interactive → ship-unit install **and** payload ensure (quiet / json / pipe auto, no hang). Interactive TTY with no line switch opens the menu and does not auto-run the payload.  
2. Empty argv + local/global install + force off + non-interactive → payload ensure; not help; upgrade policy when applicable. The same installed state on an interactive TTY with no line switch is the menu again.  
3. Empty argv + install/payload failure → non-zero exit with visible error.  
4. One-liner never silent-success with no binary.  
5. `--force` / `reinstall` only for deliberate replace; not required for normal ensure.  
6. `help` works when invoked explicitly.  
7. Tests cover pipe smoke (not silent), Case A failure, Case B/C not-help.  
8. **TP-CURL Core** cases green via `tests/test_online_curl_install.sh` (local channel; silent = 0-byte out+err forbidden): first pipe, second pipe, bashrc+sdkman pipe, bad channel loud, `curl \| sh` bash gate, `bash -s -- version`, refuse install. Optional online gate `RUN_ONLINE_CURL_TESTS=1` (TP-CURL-09).  
9. Changes cite `requirement-shell-cli-zero-arguments` and term `payload-installer`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-shell-payload-online-install.md` | Product Type O-P class law (install/uninstall vs self-*) |
| `docs/requirements/requirement-shell-cli-interface.md` | Full command surface; empty-argv row must match this SSOT |
| `docs/requirements/requirement-shell-idempotency.md` | Ensure re-run / force boundary |
| `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | TTY vs pipe for Case A |
| `docs/requirements/requirement-shell-self-management.md` | self-update primitives reused on empty argv upgrade |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_*` / JSON purity |
| `docs/requirements/requirement-shell-automatic-checksum.md` | Integrity on install download path |
| `docs/requirements/requirement-domain-springboot3.md` | Payload pipeline |
| Repo root `./springboot3` | Implementation (`app_main`, `inst_*`, domain helpers) |
| `tests/README.md` | TP-CURP-* map |
| `tests/test_cli.sh`, `tests/test_install_lifecycle.sh`, `tests/test_online_curl_install.sh` | Regression coverage |

---

## 7. Revision history

| Date | Change | Author / agent |
|------|--------|----------------|
| 2026-07-14 | Initial Active v1.0.0: empty argv = install-ensure for not-installed / local / global; forbid help fallthrough | Grok (owner request) |
| 2026-07-14 | v1.1.0: Classify product as Type O (online-install) under dual-type empty-argv template model | Grok |
| 2026-07-15 | v1.2.0: Promote hybrid supersession banner to top; soft-supersede portable Cases B/C force-off as domain run; cite domain requirement | Grok (authorized 1–3) |
| 2026-07-20 | v1.3.0: **Type O-P payload installer** law; combined ensure; first pipe must not exit binary-only; non-interactive upgrade; loud one-liner; live Gap honesty | Grok (owner request) |
| 2026-10-07 | v1.4.0: Dual-mode matrix. Non-interactive empty argv stays combined ensure. Interactive TTY with no line switch opens the numbered menu and does not auto-run the payload. Live ship unit still payload-ensures on a TTY (gap). | Grok (owner confirm) |
| 2026-10-07 | v1.4.1: The TTY gap is closed. `./springboot3` opens the numbered menu on an interactive empty argv and keeps combined ensure on a pipe. | Grok (owner request) |

### Empty argv specialization (springboot3 — Type O-P payload installer)

Normative summary lives in the **Payload installer law** banner at the top of this file and in §2.2–2.3. Condensed matrix:

| Situation | Required behavior for **this** product |
|-----------|----------------------------------------|
| **Not installed** + empty argv, non-interactive | Ship-unit install **then payload ensure** |
| **Installed** + empty argv, non-interactive | Ship-unit upgrade policy + **domain default `cmd=run`** |
| **Interactive TTY** + empty argv, no line switch, no domain payload flag | Numbered menu in `./springboot3`. Not a payload run |
| **Installed** + explicit lifecycle cmds | `version`, `version-check`, `self-update`, `self-uninstall`, `about`, `help` as dispatched |
| **Flags** | `--project-dir`, `--no-run`, `--force`, `--force-user`, `--force-root`, `--json`, `--quiet` |

Portable Type O-S matrices are **not** full product law for springboot3.

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-09** | `tests/test_cli.sh` | have |
| **TP-LC-01** | `tests/test_install_lifecycle.sh` | have |
| **TP-CURL-01–08** | `tests/test_online_curl_install.sh` | have |
| **TP-CURL-09** | `tests/test_online_curl_install.sh` | optional |
| **TP-U-*** | `tests/test_cli.sh` + curl suite | have |
| **TP-DOM-*** (Type O-P) | `tests/test_domain.sh` | have |
| **TP-MENU-02** | `tests/test_cli.sh` | have |

**Suite map:** `tests/README.md` (TP labels in suite files).


