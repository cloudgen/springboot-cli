# Lessons — springboot-cli

Durable failure modes. **Always re-check on product review.**

| ID | Mode | Prevention | Status |
|----|------|------------|--------|
| L-SILENT-01 | `curl \| bash` / empty argv under `set -u` aborts with **0-byte** stdout+stderr when sourcing `.bashrc` or `sdkman-init.sh` (unset `SDKMAN_*`) | `util_source_external_safe`; never discard product stderr on one-liner path; suite **`assert_not_silent`** · **TP-CURL-02..04** · **TP-U-04** | open watch |
| L-OP-01 | A bare pipe installs SDKMAN and starts the demo, or a bare pipe is silent | Empty argv / first pipe **MUST** place or update the CLI and stop. Payload is `setup` and **MUST NOT** start the app. **TP-LC-01** · **TP-CURL-02** · `requirement-shell-cli-zero-arguments` · `requirement-shell-payload-online-install` | open watch |
| L-PAYLOAD-01 | `uninstall` removes CLI or `self-uninstall` removes project (layer confusion) | Help + dispatcher: **payload** `install`/`uninstall` vs **ship-unit** `self-*`; **TP-LC-03** · **TP-DOM-09** · **TP-CLI-03** | open watch |
| L-CSUM-01 | Broken companion verify or companion digest not updated after ship-unit edit | Shape A companion path + Shape B `CHECKSUM` pin; regenerate `src/springboot-cli.sha256` after any ship-unit change; **TP-CSUM-02..05** · **TP-CLI-01** | open watch |
| L-DOWNGRADE-01 | Silent self-update to **older** remote without `--force` | Refuse downgrade with loud error; **TP-LC-08** | open watch |
| L-HOME-01 | `set -u` expands bare `${HOME}` before safe default | Defensive HOME/XDG defaults before path use; **TP-CLI-11** / storage isolation | open watch |
| L-PRESERVE-01 | Domain run wipes existing user project without `--reset`/`--force` | Preserve by default; regenerate only missing pieces; **TP-DOM-05** · **TP-DOM-06** | open watch |
| L-HELP-01 | Help advertises domain/ship commands not routed (or CHECKSUM as UX verb) | Help↔dispatcher alignment; CHECKSUM env not help row; **TP-CLI-03** · **TP-CSUM-05** · **TP-DOM-01** | open watch |
| L-PIN-01 | After bootstrap specialize, domain defaults still point at Boot **2.7.18** / Java 8 (bootstrap DNA) | Config defaults stay **3.3.5** / **21** Temurin. Boot 2.7.18 is opt-in via `--springboot2` only; **TP-DOM-02** · **TP-DOM-10** · `requirement-domain-springboot-cli` | **closed** 2026-08-10 (specialize retarget); switch added 2026-10-07 without changing the default |
| L-REVERSE-01 | Reverse-copy this specialized product onto bootstrap **springboot2** | Direction A→B only; H2 is harness-only; never overwrite A ship unit with B | open watch (process) |
| L-CLASS-01 | Software-dev workspace missing `requirement-class-software-dev.md` | Class law Active + registry row Area `class` | **closed** 2026-08-10 (specialize) |
| L-DOMAIN-NAME-01 | Domain SSOT basename not `requirement-domain-*` | Registered as `requirement-domain-springboot-cli.md` | **closed** 2026-08-10 |
| L-MOD-01 | Modular/prefix hygiene claimed without **TP-*** primary | **TP-MOD-01** / **TP-MOD-02** have in `tests/test_cli.sh` | **closed** 2026-08-10 (inherited suite) |
| L-REVIEWS-01 | Public `reviews/` missing after specialize | Bootstrap living plans + matrix + lessons | **closed** 2026-08-10 |
| L-TTY-01 | `prompt_*` / uninstall confirm re-test live `[ -t` inside functions (T1-SUBSHELL class) | Measure `[ -t` at script top; helpers consume `TTY`; **TP-U-06** · `requirement-shell-interactive-vs-noninteractive` | **closed** 2026-09-06 |
| L-CODING-01 | Software-dev missing coding-style related REQ (portable lessons arrive raw) | Active `requirement-shell-script-coding` + class residual pointer | **closed** 2026-09-06 |

**Intentionally out of scope for default lessons:** Type 1 sudoers elev tables, real public-network SDKMAN install as Core CI (stubbed under isolated `HOME`), a Spring Boot 4 line, or making Boot 2 the silent default. Boot 2.7.18 is an explicit switch (`--springboot2`).
