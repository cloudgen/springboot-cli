# Report: cache folder — springboot-cli 2.3.6

**Date:** 2026-09-27  
**Suite:** PASS=224 FAIL=0 SKIP=1

Cache leaves are per login and per process, aligned with sibling grok-cli storage law 1.4.0 and the cache-folder rules. Linux preferred path is `/dev/shm/cache/cache-${APP_NAME}-${login}-$$`, then `/tmp/cache/...`, then `${HOME}/.cache/cache-${APP_NAME}-$$`. Git Bash and Mac use their own chains. A skipped tier is silent. `about` prints the used folder, the fallbacks this host has, and persistence `${HOME}/.local/${APP_NAME}`.

Law: `requirement-shell-cli-storage` 1.1.0. Tests: **TP-CLI-05**, **TP-CLI-12**.
