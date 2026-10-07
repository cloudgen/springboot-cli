# Changelog

All notable changes to **springboot-cli** will be documented in this file.

This project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format.

---

## [Unreleased]

---

## [2.0.0] - 2026-10-07

### Breaking
- The installed command is `springboot-cli`. Release **1.0.1** installed `springboot3`. Run the one-liner again so `PATH` gets `springboot-cli`. A `self-update` started from the old `springboot3` binary writes the new script to the `springboot-cli` path and leaves the old filename in place.
- A pipe with no command installs or updates this CLI only. It does not install SDKMAN, Java, Maven, or the demo, and it does not start the app. Release **1.0.1** continued into the payload and started the app.
- The default Boot 3 demo folder is `~/springboot-springboot-cli`. Release **1.0.1** used `~/springboot-springboot3`. Boot 2 stays `~/springboot-springboot2`. Persistence is `~/.local/springboot-cli`.

### Changed
- `setup` installs SDKMAN, Java, Maven, and the demo and does not start the app. `install` is the same step. `run` builds and starts the demo.
- `--springboot3` and `--springboot2` stay the Boot line switches. They are not the command name.
- Domain law file is `docs/requirements/requirement-domain-springboot-cli.md`.

### Notes
- Product version **2.0.0**. `APP_NAME` is `springboot-cli`. `VERSION="2.0.0"`.
- Companion digest regenerated.
- Suite: PASS=335 FAIL=0 SKIP=1.

---

## [1.0.1] - 2026-10-07

### Changed
- The published ship unit is `src/springboot-cli`. The installed command stays `springboot3`.
- The install channel is `https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli`. The companion is `src/springboot-cli.sha256`.

### Notes
- Product version **1.0.1**. `APP_NAME` stays `springboot3`. Persistence stays `~/.local/springboot3`.
- Companion digest regenerated for this path move.
- Suite after the path move: PASS=314 FAIL=0 SKIP=1.

---

## [1.0.0] - 2026-10-07

### Added
- `--project-base` (alias `--base-path`) and `--prefix` so more than one project root can live on one machine. `--project-dir` still names one exact directory and wins.
- `--port` sets the TCP listen port. Boot 3 stays on **8080**. Boot 2 defaults to **8081** so the two default roots can listen together. `PORT`, `PROJECT_BASE`, and `PROJECT_PREFIX` match those switches.
- Numbered terminal menu for Boot 3.3.5, Boot 2.7.18, setup only, language (13 codes), and self-management. `menu` and `main` open the same tree. A pipe with no command runs combined ensure and does not wait for a key.
- Cache folder per login and per process, plus persistence under `~/.local/springboot-cli`. `about` reports the folder this run used.

### Changed
- First-commit product version baseline is **1.0.0**. The ship unit line is `VERSION="1.0.0"`.
- Spring Boot **3.3.5** stays the default line. Spring Boot **2.7.18** stays the opt-in line. On a terminal, `springboot-cli` with no command opens the numbered menu. A pipe with no command runs combined ensure.
- `STORAGE_DIR` is the first fallback path the program reports. It is not an operator override.
- Public repository is **cloudgen/springboot-cli**. The install channel is `https://raw.githubusercontent.com/cloudgen/springboot-cli/main/springboot-cli`. The program name stays `springboot-cli`.

### Notes
- First published baseline on `cloudgen/springboot-cli`. Headings below this version are workspace notes from before that repository.
- Companion digest regenerated for the version-line edit.
- Companion digest regenerated for the cache-folder and menu edit.
- Suite after the baseline: PASS=221 FAIL=0 SKIP=1.
- Suite after the root and port switches: PASS=253 FAIL=0 SKIP=1.
- Suite after cache folders and the menu: PASS=314 FAIL=0 SKIP=1.
- Companion digest regenerated for the public channel edit.
- Suite after the public channel retarget: PASS=314 FAIL=0 SKIP=1.

---

## [2.4.0] - 2026-10-07

### Added
- Payload line switch on the `springboot-cli` ship unit: `--springboot3` (default) and `--springboot2`.
- `--boot 2|3` (also `springboot2` / `springboot3`) and environment `BOOT_LINE` select the same lines. A flag wins over `BOOT_LINE`.
- Spring Boot **2.7.18** / Java **8** Amazon Corretto (`8.0.472-amzn`) profile, with default folder `~/springboot-springboot2` and artifact `hello-springboot2`.
- Spring Boot **3.3.5** / Java **21** Temurin (`21.0.10-tem`) remains the default, with default folder `~/springboot-springboot3` on that older command name.
- `about` reports `boot_line`, `springboot_ver`, and `java_id`.
- Unknown or missing `--boot` values fail closed.
- **TP-DOM-10** covers both generated projects, separate default folders, about JSON, and the unknown-line failure.

### Changed
- Version bump **2.3.5 → 2.4.0**.
- Help, README, and domain law list both lines. Empty arguments still set up Boot 3.3.5.

### Notes
- Maven pin unchanged: **3.9.14**.
- Companion digest regenerated.
- Suite: PASS=221 FAIL=0 SKIP=1.
- The two lines do not share a default project folder. `--project-dir` still overrides either default.

---

## [2.3.5] - 2026-09-06

### Added
- `--debug` is parsed (`DEBUG=1`) and listed in help; extra diagnostics stay off stdout under `--json`.
- Help lists `--force-user` / `--force-root` and Environment `SCRIPT_URL` / `REPO_USER` / `REPO_NAME` (still no `CHECKSUM`).
- Unknown options fail closed (`out_die`), not silently ignored (**TP-CLI-08**).
- Dual-mention invocation samples on CLI + topic-owner requirements.
- **TP-U-04** labeled assertions on the bashrc/SDKMAN pipe case.

### Changed
- Version bump **2.3.4 → 2.3.5**.
- Empty-argv already-installed upgrade path consumes `TTY` (no live `[ -t` retest).
- Checksum DTV lists **TP-CSUM-02..05** only (no invented TP-CSUM-01).
- Idempotency matrix: payload `install` vs ship-unit place; empty argv is Type O-P combined ensure.

### Notes
- Domain pins unchanged: Spring Boot **3.3.5**, Java **21** (Temurin), Maven **3.9.14**.
- Companion digest regenerated.
- Suite: PASS=191 FAIL=0 SKIP=1.

---

## [2.3.4] - 2026-09-06

### Added
- Product README human-intro voice pack (one sentence, boxes, includes/excludes, practice) and required section order.
- Full **§1.1 Human-facing** voice pack on every registered requirement.
- Named section **Under command line for normal user only** on related shell/domain requirements (Termux / Git Bash / Windows cmd: normal user privilege only).
- Coding-style related REQ `requirement-shell-script-coding.md` (specialize-in home; without it, portable lessons arrive raw).
- Domain demo artifact samples (`pom.xml` / `HelloApplication.java` / `application.properties`).
- **TP-U-06**: TTY measured at script top; `prompt_*` consume `TTY` (no live `[ -t` retest).

### Changed
- Version bump **2.3.3 → 2.3.4**.
- `prompt_ask` / `prompt_yes_no` / install and uninstall confirms consume `TTY` instead of re-testing `[ -t` inside functions.
- Stale `app_version` default **2.3.1** aligned to current VERSION.
- README: Stars banner, CIAO philosophy link, Platform Compatibility includes Git Bash / cmd / Termux user-only notes; integrity table kept.
- Class residual points at coding-style REQ; dest/actor residual remains **considered — none**.

### Notes
- Domain pins unchanged: Spring Boot **3.3.5**, Java **21** (Temurin), Maven **3.9.14**.
- Companion digest regenerated.
- Suite: PASS=177 FAIL=0 SKIP=1.

---

## [2.3.3] - 2026-08-11

### Changed
- Software-dev housekeeping after harness-knowledge audit fix.
- Re-synced portable harness from RAM genesis (H2 NEW+UPDATE); product law/ship unit unchanged.
- `.gitignore` detect header retargeted to `./springboot-cli` (removed stale `./pomo`/`./countdown` detect text).
- Version bump **2.3.2 → 2.3.3**; companion digest regenerated.

### Notes
- Domain pins unchanged: Spring Boot **3.3.5**, Java **21** (Temurin), Maven **3.9.14**.
- Suite: PASS=174 FAIL=0 SKIP=1.
- Local harness (skills/terms/templates) remains Pattern A gitignored; requirements tracked.

---

## [2.3.2] - 2026-08-10

### Added
- Public **`reviews/`** surface: `what-to-review`, `test-plan`, `requirement-test-matrix`, `lessons`, dated reports.
- Product law under **`docs/requirements/`** (class + Type O-P shell + domain `requirement-domain-springboot-cli`).
- CI workflow, tests suite, companion **`springboot-cli.sha256`**, and **SECURITY.md** aligned with current release.

### Changed
- Version bump **2.3.1 → 2.3.2** after specialize, H2 harness pull, and review/test-plan publish.
- README Type O-P usage/features and version badge.

### Notes
- Domain pins unchanged: Spring Boot **3.3.5**, Java **21** (Temurin), Maven **3.9.14**.
- Local harness trees under `docs/` (skills/terms/templates) remain Pattern A gitignored; requirements are tracked.

---

## [2.3.1] - 2026-08-10

### Specialization (bootstrap springboot2 → springboot-cli)
- **Architecture inheritance:** rebuilt ship unit from bootstrap **springboot2** Type O-P (`out_*` / `inst_*` / `app_main`, payload `install`/`uninstall` vs CLI `self-*`).
- **Identity / channel retarget:** `APP_NAME=springboot-cli`, `REPO_NAME=springboot-cli`, `SCRIPT_URL` for Wilgat/springboot-cli.
- **Domain pins retained for this product line:** Spring Boot **3.3.5**, Java **21** (`21.0.10-tem` Temurin), Maven **3.9.14**.
- **Product law:** registered `docs/requirements/` including domain SSOT `requirement-domain-springboot-cli.md`.
- **Tests / CI:** ported Type 0 + domain suite; companion `springboot-cli.sha256` regenerated.
- **Anti-pollution:** bootstrap origin springboot2 was not overwritten.

### Notes
- Prior 2.0.0 ship unit archived under `.specialize-archive/` for reference only.
- Direction remains **A → B only** (springboot2 bootstrap → springboot-cli specialized product).

---

## [2.0.0] - 2026-04-14

### Major Changes
- **Bumped to version 2.0.0** — Major internal refactoring while strictly preserving the ultra-defensive CIAO coding style.
- Completely overhauled the output system:
  - Introduced `output_text()` as the **single source of truth** for all human-readable text.
  - Introduced `output_json()` as the **single source of truth** for all machine-readable JSON output.
  - Full compliance with `--quiet` / `-q` and `--json` flags across the entire script.
- Strengthened root vs non-root installation isolation with new `get_install_bin_path()` helper.
- Added robust self-update safety:
  - Pure POSIX `version_gt()` function for semantic version comparison.
  - Prevents accidental downgrades when a newer development version is already installed.
  - Proper JSON support for `self-update` (including already-latest and newer-local cases).
- Improved interactive prompts with centralized `prompt_yes_no()` that fully respects `--quiet` and `--json`.
- Enhanced multi-user and harsh-environment support:
  - Better per-user storage isolation via `resolve_storage()`.
  - Early sourcing of user shell configuration (`source_user_shell_config()`) for reliable SDKMAN/Java/Maven availability in non-login shells.
- Added atomic file writing with `write_file_atomic()` to prevent partial or corrupted configuration files.
- Updated help and about commands with cleaner, more consistent output and full JSON support.
- Added explicit single-source-of-truth enforcement reminders in key functions to protect against future simplification by AI assistants or maintainers.
- Improved defensive coding throughout:
  - Repeated safe variable defaults in more functions.
  - Better respect for `--quiet`, `--json`, `--force`, `--reset`, `--project-dir`, and `--no-run` flags.
- Made `show_spring_boot_help()` reusable across the springboot family with smart major-version EOL warning detection (shows warning only for 2.x).

### Bug Fixes
- Fixed missing or malformed JSON output for `self-update` and `version-check`.
- Eliminated all raw `printf`/`echo`/`cat` outside the official output functions (full single-source-of-truth compliance).
- Corrected Alpine Linux instructions and SDKMAN setup messages to route through the output system.
- Fixed debug hints in `build_and_run()` to respect `--quiet` and `--json`.
- Removed copy-paste artifacts (old Spring Boot 2.7.18 references in headers and defaults).
- Fixed version warning logic in help text (now intelligently detects major version).

### Other Improvements
- Updated function headers with clearer GENERAL PURPOSE descriptions and explicit mentions of supported flags.
- Better documentation and warnings to guide future maintainers and AI assistants.
- Maintained full backward compatibility for the one-command install:  
  `curl -fsSL https://raw.githubusercontent.com/Wilgat/springboot-cli/main/springboot-cli | bash`

### Notes
- Spring Boot **3.3.5** and Java **21 (Temurin)** remain **intentionally pinned**.
- This release focuses on reliability, maintainability, and robustness in harsh environments (containers, Alpine, Git Bash, multi-user systems, non-interactive shells) without sacrificing the project's defensive "verbose-on-purpose" philosophy.
- The help function is now shared/reusable with `springboot2` and `springboot4`.

---

## [1.6.0] - 2025 (Previous Stable)

- Initial mature version with solid CIAO defensive structure.
- Basic quiet/JSON support and installation logic.

---

## Unreleased

*(No changes yet)*

---

**GitHub**: https://github.com/cloudgen/springboot-cli

This changelog is maintained manually to ensure clarity and human readability.
