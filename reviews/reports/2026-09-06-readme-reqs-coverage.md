# Report: README + requirements human-readability and coverage — springboot-cli 2.3.4

**Date:** 2026-09-06
**Mode:** review + implement (authorized)
**Status:** closed this turn (watch lessons remain)

## Summary

Reviewed product README and registered requirements for human readability (voice pack, jargon ban, **project nature**), then coverage of requirements vs tests vs checklists. Implemented: README section order + voice pack; full §1.1 on every REQ; **Under command line for normal user only** on related shell/domain files; coding-style related REQ; domain artifact samples; TTY consume in `prompt_*` / install-uninstall confirms; TP-U-06; version **2.3.4**.

Class gate: software-development, Active `requirement-class-software-dev`. Registry ↔ disk match after adding `requirement-shell-script-coding.md`. Bootstrap direction A→B (springboot2 → springboot-cli) unchanged. Type 1 elev N/A. Dest/actor residual remains **considered — none**.

## Issues

### Issue 1 -- Severity: bug
- File: README.md
- Description: Product README used emoji H2s, missing required headings (`Examples`, `Last Update`, `Related Projects`), H1 without short-description, no voice pack, Type O-P lead in Features.
- Suggestion: Rewrite to write-readme §4 order + human-intro voice pack.
- Lesson: —
- Test: README install integrity table kept (automatic SHA-256).
- Status: closed

### Issue 2 -- Severity: bug
- File: docs/requirements/requirement-*.md
- Description: §1.1 existed as a collapsed 3-column table; missing Surfaces; missing **In one sentence** label; no **Under command line for normal user only** on related shell REQs. Interactive REQ still taught live `[ -t` inside `prompt_*`.
- Suggestion: Full voice pack; named normal-user-only section; no-retest-tty law + ship-unit consume `TTY`.
- Lesson: L-TTY-01
- Test: TP-U-06
- Status: closed

### Issue 3 -- Severity: bug
- File: docs/requirements/index.md
- Description: Software-dev missing coding-style related REQ (portable lessons arrived raw).
- Suggestion: Register `requirement-shell-script-coding.md`; class residual own-or-point.
- Lesson: L-CODING-01
- Test: TP-MOD / TP-U
- Status: closed

### Issue 4 -- Severity: suggestion
- File: docs/requirements/requirement-domain-springboot-cli.md
- Description: Demo artifacts named without complete sample bodies (coverage Step 3c).
- Suggestion: Add filename grammar + sample `pom.xml` / main class / `application.properties`.
- Lesson: L-PRESERVE-01 (related)
- Test: TP-DOM-04
- Status: closed

### Issue 5 -- Severity: nit
- File: springboot-cli:app_version
- Description: Stale `: "${VERSION:=2.3.1}"` inside `app_version` (harmless after Config assign, dishonest).
- Suggestion: Align to current VERSION.
- Lesson: —
- Test: TP-CLI-02
- Status: closed

## Coverage verdict

| Claim | Verdict |
|-------|---------|
| C-full-product (Type O-P + domain) | **Sufficient with Gaps** — residual: real public SDKMAN/Java network as Core CI still stubbed (intentional); optional TP-CURL-09 |
| Human-readable law | Pass (every registered REQ has §1.1 voice pack) |
| Command line for normal user only | Pass (named section on related files; output-only N/A) |
| Coding-style related REQ | Pass (`requirement-shell-script-coding`) |
| Dual mention (routed verbs) | Pass — CLI-interface names all verbs; topic owners: payload, self-management, domain, zero-args, checksum (CHECKSUM not a verb) |
| TP map | Pass after TP-U-06 |
| Checklists | Product living plan = `reviews/what-to-review.md` (updated). `docs/checklists/` is genesis harness (gitignored Pattern A) — not product-ship gate |
| Operator-readable error | Pass for this turn — unknown-command / confirm_required / checksum_mismatch remain human + next step; no new jargon-only `out_die` |
| Type 1 elev / LPU / dest fences | N/A (considered — none) |

## Tests

See suite output recorded in `reviews/index.md` after `./tests/run.sh`.

## Follow-ups (not this turn)

- Optional TP-CURL-09 real public channel (`RUN_ONLINE_CURL_TESTS=1`)
- Residual JSON error stdout vs stderr wording (index sufficiency note)
- Do not reverse-copy onto bootstrap springboot2 (L-REVERSE-01)
