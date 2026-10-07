# Reviews — springboot-cli

Public product review surface (peer of `tests/`). Git-tracked.

| File | Role |
|------|------|
| `what-to-review.md` | Living review plan / checklist |
| `test-plan.md` | TP-* status map (have / todo / optional / n/a) |
| `requirement-test-matrix.md` | Requirement → TP families |
| `lessons.md` | Durable failure modes to re-check |
| `index.md` | Report index |
| `reports/` | Dated review run reports |

**Product:** springboot-cli (bash Type O-P payload online installer + Spring Boot line switch: default 3.3.5, opt-in 2.7.18)  
**Ship unit:** `src/springboot-cli` · companion `src/springboot-cli.sha256`  
**Version SSOT:** `VERSION="2.0.0"` in ship unit Config  
**Channel:** `SCRIPT_URL` → `https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli`  
**Bootstrap lineage:** specialized from **springboot2** (A→B); architecture Type O-P inherited; domain pins retargeted  
**Install mode:** **Type O-P online** (`curl | bash` places the CLI only; `setup` is the payload) — not local-only  
**Type 1 elevation / sudoers product surface:** intentionally **absent** (global bin may use host `sudo` for path place; no Type 1 elev law tables)

**Always load first:** `reviews/lessons.md`  
**Suite entry:** `./tests/run.sh`  
**Last plan update:** 2026-09-06
