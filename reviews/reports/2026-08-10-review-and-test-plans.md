# Report: review-and-test-plans — springboot3 2.3.2

**Date:** 2026-08-10  
**Mode:** product-review publish (living plans + TP map) after bootstrap specialize + H2  
**Status:** clean for plan bootstrap; open watch lessons retained  

## Summary

Created the public **`reviews/`** surface for **springboot3** (peer of `tests/`), specialized from the springboot2 plan shape but retargeted to this product:

| Field | Live value |
|-------|------------|
| APP_NAME | `springboot3` |
| VERSION | `2.3.1` |
| Domain | Spring Boot **3.3.5** · Java **21** (`21.0.10-tem` Temurin) |
| Domain SSOT | `requirement-domain-springboot3.md` |
| Bootstrap A | springboot2 (A→B only; not reverse-copied) |
| Install class | Type O-P online |
| Type 1 elev | **N/A** |

Suite on this host after specialize + H2 harness pull:

**PASS=174 FAIL=0 SKIP=1** (`./tests/run.sh`; TP-CURL-09 optional online skipped)

## Work done

1. **`reviews/what-to-review.md`** — pre-flight, law surfaces, high-risk paths, Type 1 N/A, non-goals  
2. **`reviews/test-plan.md`** — full TP-CLI / U / CSUM / LC / CURL / DOM / MOD status map (**have** where suite asserts)  
3. **`reviews/requirement-test-matrix.md`** — all 12 Active REQs → TP families  
4. **`reviews/lessons.md`** — watch modes + closed specialize/reviews lessons  
5. **`reviews/README.md`**, **`index.md`**, this report  
6. **`tests/README.md`** — pointed at `reviews/` maps; corrected Type O-P / bootstrap lineage wording  

## Issues

### Issue 1 — Severity: nit (closed by this report)

- File: (missing) `reviews/`  
- Description: After specialize from springboot2, public review/test-plan surface was absent while `tests/README.md` already cited `reviews/*`.  
- Suggestion: Bootstrap living plans from suite + REQs (done).  
- Lesson: L-REVIEWS-01  
- Test: TP map now complete (no new suite assertion required for plan publish)  
- Status: **closed**

No open **bug** findings from this plan bootstrap. Prior architecture lessons remain **open watch** (re-check each product review).

## Lessons re-check (this run)

| ID | Result |
|----|--------|
| L-SILENT-01 | Suite still gates silent pipes — **watch** |
| L-OP-01 | TP-LC-01 / TP-CURL-02 green — **watch** |
| L-PAYLOAD-01 | TP-LC-03 / TP-DOM-09 green — **watch** |
| L-CSUM-01 | Companion present; TP-CLI-01 green — **watch** (regen after any ship edit) |
| L-DOWNGRADE-01 | TP-LC-08 green — **watch** |
| L-HOME-01 | TP-CLI-11 green — **watch** |
| L-PRESERVE-01 | TP-DOM-05/06 green — **watch** |
| L-HELP-01 | TP-CLI-03 / TP-DOM-01 green — **watch** |
| L-PIN-01 | Config 3.3.5 / Java 21; TP-DOM-02 green — **closed** |
| L-REVERSE-01 | A springboot2 intact this session — **watch** (process) |
| L-REVIEWS-01 | `reviews/` published — **closed** |

## Test-plan deltas

| TP family | Change |
|-----------|--------|
| All Core TP rows in suite | Documented as **have** for springboot3 |
| TP-DOM-02 | Explicit Boot **3.3.5** (not 2.7.18) |
| TP-ELEV | **n/a** (no Type 1 claim) |
| TP-CURL-09 | **optional** unchanged |

## Verdict

**Pass** — review plan and test plan published and aligned with live suite/REQs.  
Watch lessons remain intentional permanent re-checks, not blockers.

## Artifacts

| Path | Role |
|------|------|
| `reviews/what-to-review.md` | Living review checklist |
| `reviews/test-plan.md` | TP status map |
| `reviews/requirement-test-matrix.md` | REQ → TP |
| `reviews/lessons.md` | Durable modes |
| `reviews/index.md` | Report index |
| `tests/README.md` | Suite map → reviews |
