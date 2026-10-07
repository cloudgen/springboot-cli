# Report: help/dispatcher follow-up — springboot3 2.3.5

**Date:** 2026-09-06
**Mode:** implement leftover P1s from 2.3.4 coverage audit
**Status:** closed this turn

## Summary

Closed the remaining help ↔ dispatcher and test-plan honesty gaps: `--debug` is parsed and listed; `--force-user` / `--force-root` are advertised; help has an Environment block for `SCRIPT_URL` / `REPO_*` without `CHECKSUM`; unknown options fail closed; TP-U-04 is labeled; checksum DTV no longer claims TP-CSUM-01; dual-mention invocation samples are on CLI + topic-owners; idempotency matrix distinguishes payload `install` from ship-unit place.

## Issues

### Issue 1 -- Severity: bug
- File: springboot3 (app_main / app_help)
- Description: `--debug` required in CLI law but not parsed or listed; `--force-user`/`--force-root` routed but unadvertised; unknown `--*` swallowed; help had no Environment/`SCRIPT_URL`.
- Suggestion: Parse `--debug`; list force-user/root; Environment block; `out_die` on unknown options.
- Test: TP-CLI-03 · TP-CLI-08
- Status: closed

### Issue 2 -- Severity: suggestion
- File: tests/test_online_curl_install.sh
- Description: TP-U-04 planned **have** without a labeled assertion (covered as TP-CURL-04).
- Suggestion: Label the same pipe case TP-U-04.
- Test: TP-U-04
- Status: closed

### Issue 3 -- Severity: nit
- File: docs/requirements/requirement-shell-automatic-checksum.md
- Description: DTV claimed TP-CSUM-01–05; product has no TP-CSUM-01 row.
- Suggestion: List TP-CSUM-02..05 only.
- Status: closed
