# What to review — springboot3

**Living checklist** (review plan). Product: **springboot3** bash Type O-P payload online installer + Spring Boot **3.3.5** domain.  
**Class:** software-development · domain SSOT present · **online Type O-P** install.  
**Always load first:** `reviews/lessons.md`

**Last plan update:** 2026-09-06 (README + REQ human-readability; coverage; coding-style REQ; TP-U-06)

---

## Pre-flight

| # | Check | Notes |
|---|--------|--------|
| P1 | Read `docs/requirements/index.md` | class + 11 shell REQs + domain (`requirement-domain-springboot3`) |
| P2 | Confirm ship unit `src/springboot-cli` + companion `.sha256` | `VERSION` / `APP_NAME` / `SCRIPT_URL` SSOT |
| P3 | Load `reviews/lessons.md` and re-check every open L-* | Mandatory |
| P4 | Run suite | `./tests/run.sh` — record PASS/FAIL/SKIP |
| P5 | Confirm product class still **Type O-P** | Combined ensure; not Type O-S binary-only; not Type N help-default |
| P6 | Confirm Type 1 elev / sudoers product law still **absent** | CL-SHELL-TTY-PRIVILEGE-TRAPS **N/A** unless elev law is added |
| P7 | Confirm command layer split | `install`/`uninstall` = payload · `self-update`/`self-uninstall` = CLI only |
| P8 | Confirm domain lines | Default `3.3.5` / `21.0.10-tem` / Java 21. Opt-in `--springboot2` is `2.7.18` / `8.0.472-amzn` / Java 1.8. Do not add Boot 4 or edit either pin set as cleanup |
| P9 | Confirm bootstrap direction honesty | Architecture from **springboot2** A→B; do not reverse-copy B onto A |

---

## Product law surfaces

| Surface | Path | Review focus |
|---------|------|--------------|
| Class | `requirement-class-software-dev.md` | Residual stack; own-or-point peers |
| Domain | `requirement-domain-springboot3.md` | Line switch (default Boot 3.3.5 / Java 21, opt-in Boot 2.7.18 / Java 8), pipeline, preserve/reset, help↔dispatcher |
| CLI interface | `requirement-shell-cli-interface.md` | Commands, flags, dispatch, modes |
| Zero-arguments | `requirement-shell-cli-zero-arguments.md` | Non-interactive Type O-P combined ensure. TTY with no line switch is the menu peer |
| Default interaction | `requirement-shell-cli-default-interaction.md` | Dual-mode matrix and Boot-line menu. Handlers are in the ship unit |
| Menu language | `requirement-shell-cli-language.md` | Thirteen codes, language leaf, help/about copy. Handlers are in the ship unit |
| Payload online install | `requirement-shell-payload-online-install.md` | Layer split; first pipe not binary-only |
| Self-management | `requirement-shell-self-management.md` | `version-check`, `self-update`, `self-uninstall`, about |
| Automatic checksum | `requirement-shell-automatic-checksum.md` | Shape A companion primary; CHECKSUM not help |
| Output | `requirement-shell-output-requirements.md` | `out_*` SSOT; JSON purity |
| Storage | `requirement-shell-cli-storage.md` | Cache folder per login and process; persistence under `~/.local/springboot3` |
| Idempotency | `requirement-shell-idempotency.md` | Re-run safety |
| Interactive vs noninteractive | `requirement-shell-interactive-vs-noninteractive.md` | TTY vs pipe; confirm gates |
| Modular design | `requirement-shell-modular-function-design.md` | Prefix families; no template authority in source |
| Script coding | `requirement-shell-script-coding.md` | Specialize-in home; own-or-point; no `$()` of `read` |
| Human-facing | every `requirement-*.md` §1.1 | Voice pack; **project nature** not **project class** |
| Command line for normal user only | related shell + domain REQs | Named section; Type 1/2 unused on Termux/Git Bash/cmd |
| Operator-readable error | blocking `out_die` / `out_error` | Plain what-happened + next step (`CL-OPERATOR-READABLE-ERROR`) |

**Intentionally absent (do not “restore” without owner order):** Type 1 sudoers elev allowlists, local-only install pair without online channel, a Spring Boot 4 line, making Boot 2 the default, reverse-copy of this product onto bootstrap springboot2.

---

## High-risk paths (ship unit)

| Path / symbol | Risk | Lesson |
|--------------|------|--------|
| `util_source_external_safe` / SDKMAN source | Silent nounset abort on pipe | L-SILENT-01 |
| `app_main` empty argv / Type O-P | Binary-only first install | L-OP-01 |
| `payload_install` / `payload_uninstall` | Wrong layer vs `inst_*` self-* | L-PAYLOAD-01 |
| `inst_perform_install_*checksum*` | Integrity false pass / false fail | L-CSUM-01 |
| `inst_self_update` / `ver_gt` | Silent downgrade | L-DOWNGRADE-01 |
| HOME / `util_resolve_storage` | `set -u` path explosion | L-HOME-01 |
| `setup_springboot_project` | Wipe user project | L-PRESERVE-01 |
| `app_help` | Advertised but unrouted; CHECKSUM UX leak | L-HELP-01 |
| Config domain pins (`SPRINGBOOT_VER` / `JAVA_ID`) | Accidental Boot 2.x DNA after specialize | L-PIN-01 |
| `check_alpine_requirements` / `setup_sdkman` | Alpine/bash fail closed | domain law |
| Global bin / `sudo` path place | Not elev law tables — do not invent Type 1 TP as Core | Type 1 N/A |

---

## Type 1 elevation — review plan gate

| Gate | Status |
|------|--------|
| Product claims Type 1 / sudoers elev tables | **No** |
| CL-SHELL-TTY-PRIVILEGE-TRAPS | **N/A** |
| Elevation TP dual rows (negative fail + interactive probe) | **n/a** |

---

## Tests surface

| Check | Path |
|-------|------|
| Suite entry | `./tests/run.sh` |
| CLI | `tests/test_cli.sh` |
| Install lifecycle | `tests/test_install_lifecycle.sh` |
| Online curl / silent class | `tests/test_online_curl_install.sh` |
| Domain | `tests/test_domain.sh` |
| TP map | `reviews/test-plan.md` |
| RTM | `reviews/requirement-test-matrix.md` |

**Last suite run (agent host):** 2026-09-06 help/dispatcher follow-up — **PASS=191 FAIL=0 SKIP=1**

---

## Product user docs (when reviewing release readiness)

| Check | Path |
|-------|------|
| README install / Type O-P honesty | `README.md` |
| Changelog vs `VERSION` | `CHANGELOG.md` vs `1.0.1` |
| SECURITY integrity / contact | `SECURITY.md` |
| Companion digest present | `src/springboot-cli.sha256` |
| Requirements registry honesty | `docs/requirements/index.md` |
| Harness (local, often unversioned) | H2 from RAM genesis present; not product law |

---

## Explicit non-goals for default review

- Real public SDKMAN/Java network install as Core CI (stubs under isolated `HOME` are intentional)  
- Type 1 host package elevation / sudoers fragment product surface  
- Full genesis harness tree completeness as a product-ship gate (H2 is agent OS, not release criteria)  
- Reverse-copy domain pins or ship unit onto bootstrap **springboot2**  
- Casual retarget of Boot/Java pins to 2.x or 4.x  

---

## Publish steps (after a review run)

1. Write `reviews/reports/YYYY-MM-DD-<scope>.md`  
2. Update `reviews/index.md`  
3. Merge new modes into `reviews/lessons.md`  
4. Update TP rows in `reviews/test-plan.md` when bugs close or new gaps found  
5. Do not leave the only copy of findings in session scratch  
