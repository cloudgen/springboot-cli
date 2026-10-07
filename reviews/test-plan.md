# Test plan — springboot-cli

Maps **TP-*** coverage to automated or documented checks.  
**Suite entry:** `./tests/run.sh`  
**Ship unit:** `src/springboot-cli`  
**Product VERSION:** 2.0.0  
**Domain pins:** default Spring Boot **3.3.5** · Java **21** (`21.0.10-tem` Temurin); opt-in Spring Boot **2.7.18** · Java **8** (`8.0.472-amzn`); Maven **3.9.14**  
**Last plan update:** 2026-10-07 (cache-folder storage, TTY menu, menu language)  
**Last suite run:** see latest `reports/`

Status: **have** = automated today · **todo** = needed · **optional** · **manual** · **n/a** · **skip** (environment)

---

## Baseline coverage

| Area | Status | Evidence |
|------|--------|----------|
| Syntax `bash -n` + companion first-field match | have | TP-CLI-01 · TP-CSUM-05 |
| version / help / about human + JSON | have | TP-CLI-02..04 · TP-CLI-05 storage fields |
| Help lists payload vs ship-unit verbs; no CHECKSUM row | have | TP-CLI-03 · TP-CSUM-05 |
| Unknown command fail-closed (+ JSON) | have | TP-CLI-06 |
| Quiet / set -u HOME / storage isolation | have | TP-CLI-07 · TP-CLI-11 · TP-CLI-05 |
| Bare pipe installs or updates the CLI and does not enter the payload | have | TP-LC-01 · TP-DOM-03 · TP-CURL-02 |
| TTY numbered menu and menu language | have | TP-MENU-01..05 · TP-LANG-01 |
| Payload install / uninstall isolation | have | TP-LC-02..03 · TP-DOM-04 · TP-DOM-09 |
| Ship-unit self-update / self-uninstall / version-check | have | TP-LC-04..07 |
| Refuse silent downgrade | have | TP-LC-08 |
| Bad channel loud fail | have | TP-LC-09 |
| Shape A companion + Shape B CHECKSUM pin | have | TP-CSUM-02..04 |
| Domain pins (default Boot 3.3.5 port 8080, opt-in Boot 2.7.18 port 8081), prefix/base roots, preserve, reset, status/reinstall, SDKMAN bash and Java swap | have | TP-DOM-01..12 |
| Silent-failure class (`assert_not_silent`) on pipes | have | TP-CURL-02..08 · TP-U-04 |
| Optional public online channel | optional | TP-CURL-09 (`RUN_ONLINE_CURL_TESTS=1`) |
| Modular prefix hygiene as primary TP | have | TP-MOD-01 · TP-MOD-02 |
| TTY consume (no live `[ -t` in `prompt_*`) | have | TP-U-06 |
| Type 1 elev / TTY privilege traps | n/a | Product does not claim Type 1 elev law |

---

## TP rows

### TP-CLI (CLI surface)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-CLI-01 | `bash -n` + companion digest matches ship unit | `tests/test_cli.sh` | cli-interface · automatic-checksum | **have** |
| TP-CLI-02 | `version` human + `--json` fields | test_cli | cli-interface · output | **have** |
| TP-CLI-03 | `help` lists version-check, self-*, install/uninstall, domain flags, `--debug` / `--force-user` / `--force-root`, Environment `SCRIPT_URL`, Boot pin; layer wording | test_cli | cli-interface · payload-online-install · domain | **have** |
| TP-CLI-04 | `help --json` / `about --json` success types; about no CHECKSUM | test_cli | output · automatic-checksum | **have** |
| TP-CLI-05 | about cache fields (`cache_used`, `cache_preferred`, `cache_fallback`, `cache_fallback_2`, `persistence_storage`, `effective_storage`) + isolated HOME | test_cli | cli-storage | **have** |
| TP-CLI-06 | unknown command fail-closed human + JSON | test_cli | cli-interface · output | **have** |
| TP-CLI-07 | quiet suppresses non-error noise on version path | test_cli | output | **have** |
| TP-CLI-08 | unknown option (`--*`) fail-closed, not silently ignored | test_cli | cli-interface | **have** |
| TP-CLI-09 | zero-arg / Type O related CLI gates (suite labels) | test_cli | zero-arguments | **have** |
| TP-CLI-11 | `env -u HOME` / defensive env still serves version | test_cli | self-management · defensive | **have** |
| TP-CLI-12 | Host cache chains, silent skip of preferred, leaf mode 0700, persistence is not the install bin | test_cli | cli-storage | **have** |

**Note:** Number **10** unused in this product suite (not a fail — avoid inventing rows).

### TP-U (set -u / environment robustness)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-U-01 | Core paths under `set -u` (suite assertions) | test_cli / curl suite | modular · interactive | **have** |
| TP-U-03 | Additional nounset-safe path (suite) | test_cli | modular | **have** |
| TP-U-04 | Pipe / external source does not silent-abort under nounset | test_online_curl_install | interactive · zero-arguments · L-SILENT-01 | **have** |
| TP-U-05 | Related set -u defensive case | suite | modular | **have** |
| TP-U-06 | TTY measured outside functions; `prompt_*` consume `TTY` | test_cli | interactive · script-coding | **have** |

### TP-CSUM (automatic companion + pin)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-CSUM-02 | Force self-update shows companion link + PASS | test_install_lifecycle | automatic-checksum | **have** |
| TP-CSUM-03 | Bad `CHECKSUM` aborts; no binary left | test_install_lifecycle | automatic-checksum | **have** |
| TP-CSUM-04 | Good `CHECKSUM` installs | test_install_lifecycle | automatic-checksum | **have** |
| TP-CSUM-05 | Help/about must not list CHECKSUM as user command | test_cli | automatic-checksum · cli-interface | **have** |

### TP-LC (install lifecycle / Type O-P)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-LC-01 | Empty argv first ensure: CLI only, no demo; `setup` creates the demo and does not start it | test_install_lifecycle | zero-arguments · payload-online-install · L-OP-01 | **have** |
| TP-LC-02 | Payload `install` creates project; CLI remains | test_install_lifecycle | payload-online-install · domain | **have** |
| TP-LC-03 | Payload `uninstall` refuse without force; `--force` removes project only | test_install_lifecycle | payload-online-install · interactive · L-PAYLOAD-01 | **have** |
| TP-LC-04 | about + version-check after install | test_install_lifecycle | self-management | **have** |
| TP-LC-05 | self-update already-latest + self-upgrade alias | test_install_lifecycle | self-management · idempotency | **have** |
| TP-LC-06 | self-update `--force` with companion path | test_install_lifecycle | self-management · checksum | **have** |
| TP-LC-07 | self-uninstall refuse without force | test_install_lifecycle | self-management · interactive | **have** |
| TP-LC-08 | Refuse silent downgrade | test_install_lifecycle | self-management · L-DOWNGRADE-01 | **have** |
| TP-LC-09 | Bad channel non-zero + visible error; no binary | test_install_lifecycle | self-management · interactive | **have** |

### TP-CURL (online one-liner / silent class)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-CURL-01 | Local channel GET body + companion first field | test_online_curl_install | automatic-checksum · online | **have** |
| TP-CURL-02 | First `curl \| bash` not silent; binary placed | test_online_curl_install | zero-arguments · payload · L-SILENT-01 · L-OP-01 | **have** |
| TP-CURL-03 | Second pipe not help-only silent path | test_online_curl_install | zero-arguments · idempotency | **have** |
| TP-CURL-04 | bashrc + sdkman-init under set -u via pipe not silent | test_online_curl_install | interactive · L-SILENT-01 | **have** |
| TP-CURL-05 | Bad URL / bad SCRIPT_URL loud | test_online_curl_install | interactive · self-management | **have** |
| TP-CURL-06 | `curl \| sh` states requires bash | test_online_curl_install | interactive · domain Alpine/bash | **have** |
| TP-CURL-07 | `bash -s -- version` via pipe | test_online_curl_install | cli-interface | **have** |
| TP-CURL-08 | Refuse install / silent-class related gate | test_online_curl_install | interactive · self-management | **have** |
| TP-CURL-09 | Optional real public channel | test_online_curl_install | online | **optional** (`RUN_ONLINE_CURL_TESTS=1`) |

### TP-DOM (Spring Boot domain)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-DOM-01 | Help lists domain flags + install/uninstall/status/reinstall | test_domain | domain · cli-interface | **have** |
| TP-DOM-02 | Help states Spring Boot pin (**3.3.5**) | test_domain | domain | **have** |
| TP-DOM-03 | Empty-argv ensure installs binary (domain path) | test_domain | domain · zero-arguments | **have** |
| TP-DOM-04 | Payload install / `--no-run --project-dir` scaffolds pom + main + properties | test_domain | domain | **have** |
| TP-DOM-05 | Preserve existing project marker without force | test_domain | domain · L-PRESERVE-01 | **have** |
| TP-DOM-06 | `--reset` regenerates / wipes marker | test_domain | domain | **have** |
| TP-DOM-07 | JSON `--no-run` success fields | test_domain | domain · output | **have** |
| TP-DOM-08 | `status` / `reinstall` routed | test_domain | domain · cli-interface | **have** |
| TP-DOM-09 | Payload uninstall isolates project; CLI remains | test_domain | domain · payload · L-PAYLOAD-01 | **have** |
| TP-DOM-10 | `--springboot2` / `--boot 2` scaffolds Boot 2.7.18; default line stays 3.3.5; folders stay apart; unknown line fails | test_domain | domain | **have** |
| TP-DOM-11 | `--prefix`, `--project-base` / `--base-path`, and `--port` keep two roots and two TCP ports; `--project-dir` wins; bad port and bad prefix fail | test_domain | domain | **have** |
| TP-DOM-12 | Shebang is `#!/bin/bash`; SDKMAN tree is `${HOME}/.sdkman`; Java swap commands are `sdk use java` and `sdk default java` | test_domain | domain | **have** |

### TP-MENU (TTY menu and menu language)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-MENU-01 | Interactive zero-command, with or without `--debug`, opens the menu and does not self-install or start the payload | test_cli | default-interaction | **have** |
| TP-MENU-02 | A pipe with no command installs or updates the CLI only and does not read | test_cli | default-interaction · zero-arguments | **have** |
| TP-MENU-03 | An invalid choice reprints that layer via `out_error` and does not `out_die` | test_cli | default-interaction | **have** |
| TP-MENU-04 | `menu` with no TTY dies and does not read | test_cli | default-interaction · cli-interface | **have** |
| TP-MENU-05 | `--springboot2` with no verb still runs line 2 on a TTY | test_domain | default-interaction · domain | **have** |
| TP-LANG-01 | Language file round-trip: `de` is mode 0600, next human help heading is `Verwendung:`, and `0` on the language board does not write the file | test_cli | language | **have** |

### TP-MOD (modular / prefix hygiene)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-MOD-01 | Prefix families `out_*`/`inst_*`/`app_*`/`util_*` helpers present on ship unit | `tests/test_cli.sh` | modular-function-design | **have** |
| TP-MOD-02 | Ship unit must not cite `template-*` / `skill-*` as behavioral authority | `tests/test_cli.sh` | modular §2.3.1 | **have** |

### Intentionally n/a

| TP family | Reason |
|-----------|--------|
| TP-ELEV / TTY privilege traps | No Type 1 elev law claimed |
| Local-only install pair as sole mode | Product is Type O-P online |
| Real SDKMAN/Java public network as Core | Domain suite stubs under isolated HOME |
| Spring Boot 4 pin | Out of scope. Boot **2.7.18** is the opt-in line and is **have** as TP-DOM-10 |

---

## Rules

1. Closing a **bug** finding updates the matching TP toward **have** (and preferably adds an assertion).  
2. Do not mark TP **have** without a suite assertion (or honest skip/n/a with environment reason).  
3. Do not reintroduce Type 1 elev TP as Core without product-mode change.  
4. Optional TP-CURL-09 must not block Core CI green.  
5. Domain TP-DOM-02 must track live `SPRINGBOOT_VER` from ship unit Config (via `helpers.sh`), not a frozen foreign pin.  
