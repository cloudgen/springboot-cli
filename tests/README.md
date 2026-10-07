# Tests (springboot-cli)

POSIX `/bin/sh` CI suite for the Type O-P + domain ship unit `src/springboot-cli`.

Specialized from the **springboot2** bootstrap suite: same layout (runner, helpers, CLI, install lifecycle, online curl, domain) with product identity and Boot **3.3.5** / Java **21** pins.

## Run locally

```sh
./tests/run.sh
```

Requires: `sh`, `curl`, `python3` (local HTTP channel), `sha256sum`, `grep`.

No public network for core lifecycle: install tests serve the checkout over `127.0.0.1`. Domain `--no-run` uses stub `sdk`/`java`/`mvn` under isolated `HOME` (does not install real SDKMAN/Java).

## What is covered

| Suite | File | Focus |
|-------|------|--------|
| CLI surface | `test_cli.sh` | **TP-CLI-*** + **TP-U-*** / **TP-CSUM-05** / **TP-MOD-*** / **TP-MENU-01..04** / **TP-LANG-01**: syntax, companion, version/help/about, quiet/json, cache folder, unknown, zero-arg fail, set -u, modular prefixes, TTY menu, language leaf, TTY consume (TP-U-06) |
| Install lifecycle | `test_install_lifecycle.sh` | **TP-LC-*** + **TP-CSUM-***: pipe is CLI only, `setup` payload, install/uninstall, self-*, downgrade, checksum pin, bad channel |
| Online curl install | `test_online_curl_install.sh` | **TP-CURL-*** (+ **TP-U-04** pipe): local channel pipes; optional `RUN_ONLINE_CURL_TESTS=1` |
| Domain | `test_domain.sh` | **TP-DOM-*** plus **TP-MENU-05**: default Boot 3.3.5 pin, opt-in Boot 2.7.18 line switch (a TTY with `--springboot2` is not the menu), scaffold, preserve/reset, JSON, status/reinstall, payload uninstall isolation |

**Silent-failure class:** 0-byte stdout+stderr after one-liner = fail (`assert_not_silent`).  

**Product requirement ↔ test matrix:** `reviews/requirement-test-matrix.md`  
**Per-TP status map:** `reviews/test-plan.md` (includes primary requirement column)  
**Living review plan:** `reviews/what-to-review.md` · lessons: `reviews/lessons.md`

**Version note:** suites source `PRODUCT_VERSION` / `APP_NAME` / `SPRINGBOOT_VER` from `src/springboot-cli` via `helpers.sh`. Do not hardcode semver or foreign Boot pins in new tests.

### Optional online gate

```sh
RUN_ONLINE_CURL_TESTS=1 ./tests/run.sh
# or override channel:
RUN_ONLINE_CURL_TESTS=1 ONLINE_SCRIPT_URL='https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli' ./tests/run.sh
```

## Notes

| Item | Suite behavior |
|------|----------------|
| Companion `${APP_NAME}.sha256` | Asserted against ship unit (first field) |
| Shape A companion + Shape B `CHECKSUM` pin | Install path verifies; transparency messages asserted |
| Type O-P payload verbs | `install` / `uninstall` = payload; `self-*` = CLI only |
| Empty argv when not installed | Place the CLI and stop. `setup` installs the payload |

Product law naming: A prefixes `out_*`/`inst_*`/`app_*` (**§3.1 option 1**).

## Bootstrap specialize (A→B)

| Bootstrap A | Product B |
|-------------|-----------|
| `springboot2` Type O-P + Boot 2.7.18 suite | This directory — `APP_NAME=springboot-cli`, Boot **3.3.5** / Java **21**, hybrid empty argv, domain suite |

A’s tests alone do **not** prove B; always run `./tests/run.sh` in this repo.

## CI

Optional GitHub Actions: [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) runs `./tests/run.sh` on push/PR.

No secrets and no root.

## Last suite snapshot (agent host)

| Date | Result |
|------|--------|
| 2026-10-07 | **PASS=335 FAIL=0 SKIP=1** (2.0.0, command `springboot-cli`, CLI-only pipe) |
| 2026-10-07 | **PASS=320 FAIL=0 SKIP=1** (1.0.1, domain SDKMAN / TP-DOM-12) |
| 2026-10-07 | **PASS=314 FAIL=0 SKIP=1** (1.0.1, ship unit `src/springboot-cli`) |
| 2026-10-07 | **PASS=314 FAIL=0 SKIP=1** (1.0.0, cache folder + TTY menu) |
| 2026-10-07 | **PASS=253 FAIL=0 SKIP=1** (1.0.0, multi-root / multi-port) |
| 2026-10-07 | **PASS=221 FAIL=0 SKIP=1** (1.0.0) |
| 2026-10-07 | **PASS=221 FAIL=0 SKIP=1** (2.4.0) |
| 2026-09-06 | **PASS=191 FAIL=0 SKIP=1** (2.3.5) |
| 2026-09-06 | **PASS=177 FAIL=0 SKIP=1** (2.3.4) |
| 2026-08-11 | **PASS=174 FAIL=0 SKIP=1** |
| 2026-08-10 | **PASS=174 FAIL=0 SKIP=1** |
