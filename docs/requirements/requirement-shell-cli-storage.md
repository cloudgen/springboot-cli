**file**: docs/requirements/requirement-shell-cli-storage.md  
**Status**: Active (Version 1.2.0)  
**Area**: shell  
**Key**: `requirement-shell-cli-storage`  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **shell CLI storage** of springboot-cli. **Storage** means **two** classes:

| Class | Role | Survives reboot |
|-------|------|-----------------|
| **Cache folder** | Volatile scratch / temps / install staging | No (shm/tmp) or maybe (home fallback) |
| **Persistence storage** | Durable per-user app data for this login | Yes (under this login’s `$HOME`) |

It owns path **shapes**, central resolvers, `app_main` wire, and about diagnostics for both classes.

The preferred cache is **not** a ram-drive **project** tree (`/dev/shm/<project>` or `/dev/shm/<project>-<login>`). It lives under `/dev/shm/cache/` (Linux) or `/tmp/cache/` (Git Bash and Mac). The leaf is **per login and per process** so two logins never share one cache directory.

**Out of scope (cited, not re-owned):** Binary install paths (`USER_BIN` / `GLOBAL_BIN`); Spring Boot project tree (`PROJECT_DIR` — domain requirement); companion checksum; PATH shell-rc. The menu language leaf lives inside persistence storage and the words are owned by `requirement-shell-cli-language`.

### 1.1 Human-facing

**In one sentence:** Scratch for this run lives in a cache folder named for this login and this process. Durable data for this login lives under persistence storage. The Spring Boot project folder is neither of those.

| You | Another role | Not this |
|-----|--------------|----------|
| Let the CLI pick the cache folder and persistence storage | A second login gets a different volatile leaf | The Spring Boot project directory; `~/.local/bin` (the program file) |

**Includes:** cache resolver, persistence resolver, about fields. **Excludes:** install binary placement; domain `PROJECT_DIR`.

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Inspect storage | about shows Cache folder used, preferred, 1st fallback, 2nd fallback when that host has one, and Persistence storage. A skipped tier prints nothing | `springboot-cli about` / `springboot-cli --json about` |

### Identity SSOT (this product — do not diverge)

| Field | Live value (ship unit `src/springboot-cli`) |
|-------|----------------------------------------|
| **APP_NAME** | `springboot-cli` |
| **VERSION** | `2.0.0` |
| **REPO_USER** / **REPO_NAME** | `cloudgen` / `springboot-cli` |
| **SCRIPT_URL** | `https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli` |
| **Shebang / runtime** | `#!/bin/bash` |
| **Dispatcher** | `app_main` (A naming) |
| **Output SSOT** | `out_text` / `out_json` / `out_json_error` (+ wrappers) |
| **Cache resolver** | `util_resolve_storage` |
| **Persistence resolver** | `util_resolve_persistent_storage` |

Live scalars are owned by the ship unit Config block. On conflict with Config, use product identity protocol (ask; do not invent dual owners).

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Two storage classes (mandatory split)

Volatile leaf (shared parents `/dev/shm/cache` and `/tmp/cache`): `cache-${APP_NAME}-${login}-$$`.  
Home leaf (already per login): `cache-${APP_NAME}-$$`.  
`$$` is **this process id**. `${login}` is `id -un` as one path segment. **MUST NOT** hardcode either.

| Host | Preferred | 1st fallback | 2nd fallback |
|------|-----------|--------------|--------------|
| Linux (and Termux, and any host that is not Git Bash or Mac) | `/dev/shm/cache/cache-${APP_NAME}-${login}-$$` | `/tmp/cache/cache-${APP_NAME}-${login}-$$` | `${HOME}/.cache/cache-${APP_NAME}-$$` |
| Git Bash (`MSYSTEM`, or `uname -s` `MINGW*` / `MSYS*`) | `/tmp/cache/cache-${APP_NAME}-${login}-$$` | `${HOME}/AppData/Local/Temp/cache-${APP_NAME}-$$` | none |
| Mac (`uname -s` `Darwin`) | `/tmp/cache/cache-${APP_NAME}-${login}-$$` | `${HOME}/Library/Caches/cache-${APP_NAME}-$$` | `${HOME}/cache/cache-${APP_NAME}-$$` |

| Class | Helper |
|-------|--------|
| Cache folder (preferred) | `util_preferred_cache_dir` |
| Cache folder (1st fallback) | `util_fallback_cache_dir` |
| Cache folder (2nd fallback) | `util_fallback2_cache_dir` (empty on Git Bash) |
| Persistence storage | `util_persistent_storage_dir` → `${HOME}/.local/${APP_NAME}` |

Live chosen **cache** root: `util_resolve_storage` (stdout).  
Live **persistence** root: `util_resolve_persistent_storage` (stdout; create-before-return).

On Termux/Android, the chosen cache root (including `/tmp` and `/dev/shm`) **MAY** be **`noexec`**. Termux uses the **Linux** chain. Cache remains scratch **only**. **MUST NOT** exec a downloaded program from the cache folder.

**Silent fallback.** Choosing a later tier **MUST NOT** print a warning or an error. **MUST NOT** say that a fallback happened. An error is allowed only when **every** tier for this host failed to be created.

**MUST NOT** mix these with:

| Forbidden as this product’s storage | Why |
|-------------------------------------|-----|
| `${HOME}/.local/bin` / `USER_BIN` | Install binary dir |
| `${HOME}/springboot-${APP_NAME}` / `PROJECT_DIR` | Spring Boot project tree (domain law) |
| `/dev/shm/${APP_NAME}` or `/dev/shm/${APP_NAME}-${USERNAME}` | Looks like a ram-drive project folder |
| `XDG_CACHE_HOME` or an operator `STORAGE_DIR` override | Replaces the chain with a shared or guessed root |

`STORAGE_DIR` in `app_main` **is** the 1st fallback path this host would use. It is **not** an environment override of the chain.

### 2.2 Single cache resolver SSOT

1. **MUST** keep **one** authoritative cache-resolve helper: **`util_resolve_storage`**.  
2. New code that needs a product scratch/cache **root** **MUST** call `util_resolve_storage` (or `util_mktemp` / `mktemp` under a path it returned).  
3. Resolver **MUST** print the chosen directory path on **stdout** for `$(util_resolve_storage)` capture.  
4. User-visible failure about cache **MUST** use Output SSOT.

Preferred and fallback **path shapes** **MUST** be `util_preferred_cache_dir`, `util_fallback_cache_dir`, and `util_fallback2_cache_dir`.

### 2.3 Live cache resolve priority

Walk this host’s chain in order. First directory that can be created **and** is writable wins. The chain is the table in §2.1. **MUST NOT** replace that chain with one shared `cache-${APP_NAME}` leaf or with `XDG_CACHE_HOME`.

**Parent:** for `/dev/shm/cache` and `/tmp/cache` the resolver **MUST** create that parent (prefer mode **1777** when creating) so each login can add its own `cache-${APP_NAME}-${login}-$$` leaf. The **leaf** **MUST** be mode **0700**.

**Create before return:** for the **chosen** leaf, the resolver **MUST** create it, confirm it is **writable**, then print the path. If create/write fails → try the next tier **with no message**. If none work → **MUST** fail closed. **MUST NOT** return a path without creating it.

**MUST NOT** use these as cache:

| Forbidden cache path | Why |
|----------------------|-----|
| `/dev/shm/${APP_NAME}` | Looks like a ram-drive project folder |
| `/dev/shm/${APP_NAME}-${USERNAME}` | Same confusion. Login belongs in the leaf **under** `cache/`, as `cache-${APP_NAME}-${login}-$$` |
| `/dev/shm` or `/tmp` as a dump | No app-named cache leaf |
| Persistence storage | Durable data is not scratch |

### 2.4 Cache isolation

1. Cache leaves **MUST** include **`cache-${APP_NAME}`** (app identity).  
2. Volatile leaves (`/dev/shm/cache` and `/tmp/cache`) **MUST** be `cache-${APP_NAME}-${login}-$$`. Home leaves **MUST** be `cache-${APP_NAME}-$$` (no login segment). Isolation is the login segment plus this process id, not one shared directory that the second login falls out of.  
3. **MUST NOT** use a single shared world-writable directory for all logins or all apps.  
4. Live product **MUST** export `TMPDIR=${EFFECTIVE_STORAGE_DIR}` so `mktemp` inherits the isolated **cache** root.  
5. New scratch files **MUST** be created via **`util_mktemp`** (or `mktemp` under a path `util_resolve_storage` returned).  
6. The **cache directory** name includes `$$` (this process). Scratch **files** inside it **MUST NOT** use a predictable `$$` file name (forbidden: `/tmp/${APP_NAME}.$$`, `${EFFECTIVE_STORAGE_DIR}/${APP_NAME}.$$`).

**Complete `util_mktemp` sample:**

```sh
util_mktemp() {
    : "${APP_NAME:=springboot-cli}"
    : "${EFFECTIVE_STORAGE_DIR:=}"
    _suffix="${1:-tmp}"
    _dollar='$'
    case "${_suffix}" in
        *"${_dollar}${_dollar}"*)
            out_die "util_mktemp: refuse predictable \$\$ name template"
            ;;
    esac
    if [ -z "${EFFECTIVE_STORAGE_DIR}" ]; then
        EFFECTIVE_STORAGE_DIR=$(util_resolve_storage)
        export EFFECTIVE_STORAGE_DIR
    fi
    mktemp "${EFFECTIVE_STORAGE_DIR}/${APP_NAME}.${_suffix}.XXXXXX" \
        || mktemp
}
```

**Forbidden:**

```sh
# MUST NOT
tmp="/tmp/${APP_NAME}.$$"
tmp="${EFFECTIVE_STORAGE_DIR}/${APP_NAME}.$$"
```

### 2.5 Persistence storage

1. Persistence **MUST** be **`${HOME}/.local/${APP_NAME}`** (this login’s home + app name). No login suffix and no `$$`.  
2. Helper **`util_persistent_storage_dir`** **MUST** print that path. **`util_resolve_persistent_storage`** **MUST** `mkdir -p` it, confirm it is writable, then print it (fail closed). When this process creates that directory, mode **0700**.  
3. **MUST NOT** use `${HOME}/.local/bin` as persistence (that is `USER_BIN`).  
4. **MUST NOT** use `PROJECT_DIR` as persistence.  
5. **MUST NOT** store scratch/temps in persistence when a cache root is available.  
6. Persistence **MUST** be under the invoking login’s `$HOME` (per-user). **MUST** include `${APP_NAME}`.  
7. The menu language leaf is `${HOME}/.local/${APP_NAME}/language` inside this directory. Wiping the cache **MUST NOT** be specified as deleting that leaf. The words and the file mode are `requirement-shell-cli-language`.

### 2.6 Wire and diagnostics

| Surface | Requirement |
|---------|-------------|
| `app_main` | Resolve once early (after shell config source): `EFFECTIVE_STORAGE_DIR=$(util_resolve_storage)`; `STORAGE_DIR=$(util_fallback_cache_dir)`; `PERSISTENT_STORAGE_DIR=$(util_resolve_persistent_storage)`; export `EFFECTIVE_STORAGE_DIR`, `STORAGE_DIR`, `PERSISTENT_STORAGE_DIR`, `TMPDIR` (`TMPDIR` = cache root) |
| `app_about` human | **MUST** print the cache-folder-used label, then the live directory; **`Cache folder (preferred):`** then this host’s preferred path; **`Cache folder (1st fallback):`** then the 1st fallback; **`Cache folder (2nd fallback):`** only when this host has a 2nd fallback; **`Persistence storage:`** then `${HOME}/.local/${APP_NAME}`. The used label in English is **`Cache folder used:`**. When `APP_LANG` is not English, that one label follows the cache-folder label in `requirement-shell-cli-language`. The preferred, 1st, 2nd, and persistence labels stay the English forms in this version. Lines go through `out_info` (`[INFO]`). **MUST NOT** label cache lines **Storage (effective)** or **Storage (fallback)** or **Cache fall.** **MUST NOT** warn or error when the used directory is a fallback |
| `app_about` JSON | **MUST** include `cache_used`, `cache_preferred`, `cache_fallback` (1st), `cache_fallback_2` (2nd, empty string when the host has none), `persistence_storage`, and the live chosen cache root as `effective_storage` (same value as `cache_used`; `storage_dir` = 1st fallback). **MUST** keep `boot_line`, `project_base`, `prefix`, and `port`. **MUST NOT** include `CHECKSUM` |

Linux `about` lines (placeholders, not a fixed process id). `Cache folder used` is the tier that was created. When the preferred tier is the one used, the used line and the preferred line are the same path. When a fallback is used, the used line is that fallback path and the preferred line still shows the preferred path.

```
[INFO] Cache folder used: /dev/shm/cache/cache-${APP_NAME}-${login}-$$
[INFO] Cache folder (preferred): /dev/shm/cache/cache-${APP_NAME}-${login}-$$
[INFO] Cache folder (1st fallback): /tmp/cache/cache-${APP_NAME}-${login}-$$
[INFO] Cache folder (2nd fallback): ${HOME}/.cache/cache-${APP_NAME}-$$
[INFO] Persistence storage: ${HOME}/.local/${APP_NAME}
```

Git Bash omits the 2nd fallback line. Mac prints preferred under `/tmp/cache/`, 1st fallback under `${HOME}/Library/Caches/`, and 2nd fallback under `${HOME}/cache/`.

### 2.7 Implementation Notes (this project)

| Item | Live value |
|------|------------|
| **Product / binary** | `springboot-cli` |
| **Cache resolver** | `util_resolve_storage` in `src/springboot-cli` |
| **Linux preferred** | `/dev/shm/cache/cache-${APP_NAME}-${login}-$$` |
| **Linux 1st / 2nd** | `/tmp/cache/cache-${APP_NAME}-${login}-$$` then `${HOME}/.cache/cache-${APP_NAME}-$$` |
| **Git Bash** | `/tmp/cache/cache-${APP_NAME}-${login}-$$` then `${HOME}/AppData/Local/Temp/cache-${APP_NAME}-$$` |
| **Mac** | `/tmp/cache/cache-${APP_NAME}-${login}-$$` then `${HOME}/Library/Caches/cache-${APP_NAME}-$$` then `${HOME}/cache/cache-${APP_NAME}-$$` |
| **Persistence** | `${HOME}/.local/springboot-cli` |
| **Persistence resolver** | `util_resolve_persistent_storage` |
| **Scratch files** | `util_mktemp` (and `mktemp` under the resolved cache root / `TMPDIR`) |
| **Call sites** | `app_main`, `app_about`, install staging via `TMPDIR` |
| **Not used for** | Install `~/.local/bin`; domain `PROJECT_DIR`; the language leaf (inside persistence, not the cache) |
| **Test hooks** | `SPRINGBOOT3_CACHE_HOST=linux\|gitbash\|mac` and `SPRINGBOOT3_CACHE_SKIP=preferred` (suite only; not operator config) |
| **Tests** | `tests/test_cli.sh` — **TP-CLI-05** labels and fields; **TP-CLI-12** host chains, silent skip, mode 0700, persistence |

#### Definition of done (storage)

1. §2.1 chain, **create-before-return**, silent tier miss, and isolation hold in `util_resolve_storage`.  
2. No parallel ad-hoc product scratch roots.  
3. Fail closed only when every tier for this host failed (no `mkdir … \|\| true` on the chosen root; no warning on a skipped tier).  
4. Main resolves once per run; exports effective root, 1st fallback, persistence, and `TMPDIR`; about exposes the cache lines; regression tests cover the chains.  
5. Registered in `docs/requirements/index.md`.

### 2.8 Why This Requirement Exists (CIAO)

- **Caution:** Multi-user isolation without looking like a project tree on tmpfs; durable data is not mixed with the install bin or the Boot project.  
- **Intentional:** Storage = cache folder **and** persistence storage; about says both.  
- **Anti-fragile:** Missing `/dev/shm` still works, and the miss is silent.  
- **Over-protect:** Forbid a shared `/dev/shm/${APP_NAME}-${USERNAME}` leaf and predictable `$$` scratch **file** names.

## Under command line for normal user only

When the product may run on Termux, Git Bash, Windows cmd, or the same class: **admin privilege** and **dedicated system user privilege** stay unused on detect; no in-tool sudo / apt / dedicated system user; no `sudo curl | sh` recommend; Git Bash and Windows cmd do not invoke Termux `pkg`.

**This requirement:** cache and persistence stay under this login. **MUST NOT** chown via `sudo` or write `/var` as dest. Username isolation uses `id -un` at runtime. On Termux the chosen cache folder is scratch only (it may be `noexec`).

## 3. Design Principles (CIAO / CIAO-Lite)

- Volatile cache first, user cache last for scratch.  
- Persistence is under `$HOME/.local/${APP_NAME}`, not under `bin` and not the Boot project.  
- Isolation before convenience.  
- Create fail-closed in the resolvers only after every tier failed.  
- Cache path family is distinct from ram-drive **project** folders.

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Restore `/dev/shm/${APP_NAME}` or `/dev/shm/${APP_NAME}-${USERNAME}` as the preferred cache.  
2. Label about cache lines **Storage (effective)** / **Storage (fallback)** / **Cache fall.** The English labels are **Cache folder used**, **Cache folder (preferred)**, **Cache folder (1st fallback)**, **Cache folder (2nd fallback)** when that host has one.  
3. Drop persistence storage from this requirement or from `about`.  
4. Use `${HOME}/.local/bin` or `PROJECT_DIR` as persistence.  
5. Replace the cache fallback chain with a shared world-writable dump, with one `cache-${APP_NAME}` leaf shared by every login, or with `XDG_CACHE_HOME` / an operator `STORAGE_DIR` override.  
6. Scatter hard-coded `/tmp/springboot-cli` roots outside the cache resolver.  
7. Leave the resolvers dead with no call sites while claiming storage is product law.  
8. Echo a tier path without creating it (the chosen tier).  
9. Use predictable `$$` scratch **file** names instead of `util_mktemp` / `mktemp` XXXXXX. The cache **directory** itself includes `$$`.  
10. Warn or error only because a higher cache tier was skipped.  
11. Drop `${login}` or `$$` from a volatile cache leaf, or put the login back on `/dev/shm/${APP_NAME}-${login}` outside `cache/`.  
12. Exec a downloaded program from the cache folder, `/tmp`, or `/dev/shm` on Termux.  
13. Strip the **Under command line for normal user only** section, or enable admin privilege / a dedicated system user on Termux / Git Bash / Windows cmd.  
14. Put `${login}` on a home-tier leaf (`${HOME}/.cache`, Library/Caches, AppData, `${HOME}/cache`). Home is already that login.  
15. Store the menu language leaf in the cache root.

**Violating this rule is a critical cache isolation / honesty regression.**

---

## 5. Acceptance criteria

| ID | Criterion |
|----|-----------|
| AC-1 | Exactly one authoritative cache resolver creates and returns the cache root |
| AC-2 | Linux preferred leaf is `/dev/shm/cache/cache-${APP_NAME}-${login}-$$` when that directory is usable. Git Bash and Mac preferred leaf is `/tmp/cache/cache-${APP_NAME}-${login}-$$` |
| AC-3 | `app_main` sets `EFFECTIVE_STORAGE_DIR` / `TMPDIR` / `PERSISTENT_STORAGE_DIR` early |
| AC-4 | `about` human prints Cache folder used, preferred, 1st fallback, 2nd fallback when present, and Persistence storage; JSON has `cache_used` / `cache_preferred` / `cache_fallback` / `cache_fallback_2` / `persistence_storage` |
| AC-5 | Scratch files use `util_mktemp` / `mktemp` XXXXXX; the cache directory name may include `$$`; scratch file names must not |
| AC-6 | Live cache path is not `/dev/shm/${APP_NAME}` or `/dev/shm/${APP_NAME}-${USERNAME}` |
| AC-7 | Persistence path is `${HOME}/.local/${APP_NAME}` and the directory exists after resolve |
| AC-8 | Skipping a cache tier prints no warning and no error. Git Bash has no 2nd fallback. Mac 2nd fallback is `${HOME}/cache/cache-${APP_NAME}-$$` |
| AC-9 | Chosen cache leaf mode is `0700` |

---

## 6. Related requirements (peer keys only)

| Key | Relationship |
|-----|--------------|
| `requirement-shell-modular-function-design` | `util_*` family ownership |
| `requirement-shell-output-requirements` | Data-return stdout vs product UI |
| `requirement-shell-self-management` | Install staging (`util_mktemp` / `TMPDIR`) |
| `requirement-domain-springboot-cli` | Domain `PROJECT_DIR` (not this resolver) |
| `requirement-shell-cli-interface` | About fields, including `boot_line`, `prefix`, and `port` |
| `requirement-shell-cli-language` | Language leaf inside persistence; not the cache root |
| `docs/requirements/index.md` | Registry |

---

**Last Updated**: 2026-10-07  
**Owner**: springboot-cli project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO (https://github.com/cloudgen/ciao); CIAO-Lite.

## 7. Revision history

| Date | Status | Note |
|------|--------|------|
| 2026-07-15 | Active 1.0.0 | Live resolve chain `/dev/shm/${APP_NAME}-${USERNAME}` → `/tmp` → `STORAGE_DIR`; create-before-return |
| 2026-10-07 | Active 1.1.0 | Pointer: menu language leaf is not this cache |
| 2026-10-07 | Active 1.2.0 | Per-login per-process cache leaves. Linux shm → tmp → `${HOME}/.cache`. Git Bash tmp → AppData Local Temp. Mac tmp → Library/Caches → `${HOME}/cache`. Silent tier miss. `about` prints used / preferred / 1st / 2nd. Persistence `${HOME}/.local/${APP_NAME}`. `STORAGE_DIR` is the 1st fallback, not an environment override |

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-05** | `tests/test_cli.sh` | **have** — about JSON cache + persistence fields + human labels |
| **TP-CLI-12** | same | **have** — Linux preferred `/dev/shm/cache/cache-${APP_NAME}-${login}-$$`; 1st `/tmp/cache/...`; 2nd `${HOME}/.cache/cache-${APP_NAME}-$$`; Git Bash and Mac chains; silent skip of preferred; persistence `${HOME}/.local/${APP_NAME}`; live dir exists; leaf mode 0700; not `/dev/shm/${APP_NAME}-${login}` |

**Suite map:** `tests/README.md` (TP labels in suite files).
