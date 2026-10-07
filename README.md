# springboot3 - Spring Boot 3.3.5 or 2.7.18 in one command

![Version](https://img.shields.io/badge/Version-1.0.1-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)
[![Stars](https://img.shields.io/github/stars/cloudgen/springboot-cli?style=flat-square)](https://github.com/cloudgen/springboot-cli)
<img src="https://img.shields.io/badge/Java-21%20or%208-orange?style=flat-square&logo=openjdk" alt="Java 21 or 8">
<img src="https://img.shields.io/badge/Spring%20Boot-3.3.5%20or%202.7.18-brightgreen?style=flat-square&logo=springboot" alt="Spring Boot 3.3.5 or 2.7.18">
<img src="https://img.shields.io/badge/Maven-3.9.14-red?style=flat-square&logo=apachemaven" alt="Maven 3.9.14">

**In one sentence:** You run `springboot3` as yourself. A pipe places the program and sets up the default Spring Boot 3.3.5 demo (Java 21 Temurin). On a terminal with no command, a numbered menu offers Boot 3, Boot 2, setup only, language, and self-management. `--springboot2` sets up Spring Boot 2.7.18 on Java 8.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Install for yourself and run the demo without becoming root | `curl -fsSL …/src/springboot-cli \| bash` then `springboot3` |
| Optional root install | A Linux host with sudo may place the program under `/usr/local/bin` | `curl -fsSL …/src/springboot-cli \| sudo bash` |
| Not this | A Spring Boot 4 installer, or a signed-release claim | Boot 4 is out of scope. Boot 2 is an explicit switch, not the default |

| Includes | Excludes |
|----------|----------|
| One-liner install, a switch for Boot 2 or Boot 3, preserve existing demo files, `self-update` of this program | Changing the two pin sets as casual cleanup; host `apt` Java as product law |
| Automatic SHA-256 sidecar check (the program downloads the digest itself) | Requiring `CHECKSUM` for a normal install |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Install | Downloads this program, checks the companion digest, then ensures the demo environment. Does not hang waiting for a key. | `curl -fsSL https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli \| bash` |
| Open the menu | On a terminal, no command shows Boot 3, Boot 2, setup only, language, and self-management. Pick 1 to start Boot 3.3.5. | `springboot3` |
| Run from a script | A pipe or a non-interactive run with no command builds and starts the Boot 3.3.5 app. Re-runs keep your `pom.xml` unless you ask to reset. | `springboot3 </dev/null` |
| Run the Boot 2 demo | Same program, Java 8 and Spring Boot 2.7.18, in `~/springboot-springboot2`. | `springboot3 --springboot2` |
| Update this program | Replaces only the CLI script from the channel. Does not wipe the demo folder. | `springboot3 self-update` |

Published at [github.com/cloudgen/springboot-cli](https://github.com/cloudgen/springboot-cli) (aligned with [CIAO](https://github.com/cloudgen/ciao)). Official recommendation: [RECOMMENDATION.md](./RECOMMENDATION.md).

## Features

- One command installs the CLI and a Spring Boot environment (SDKMAN, Java, Maven, demo project)
- Line switch: **`--springboot3`** (default, Boot 3.3.5 / Java 21 Temurin) or **`--springboot2`** (Boot 2.7.18 / Java 8 Amazon Corretto)
- One-liner install (`curl | bash`) — places `springboot3` if needed, then ensures the default Boot 3 environment
- One-liner for Boot 2: `curl -fsSL https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli | bash -s -- --springboot2`
- User install (`~/.local/bin`) and optional system install (`/usr/local/bin`)
- Automatically installs SDKMAN! + the line's pinned Java + **Maven 3.9.14**
- Creates (or safely re-uses) a minimal "Hello World" project for the selected line
- Separate default folders: `~/springboot-springboot3` (port 8080) and `~/springboot-springboot2` (port 8081)
- **Project preservation by default** — re-runs keep your existing files (`pom.xml`, sources, properties)
- Self-management of this program: `self-update`, `version-check`, `self-uninstall`
- On a terminal, `springboot3` with no command opens a numbered menu (Boot 3, Boot 2, setup only, 13 languages, self-management). `menu` and `main` open the same tree
- Flags: `--springboot2`/`--springboot3`/`--boot`, `--force`/`--reset`, `--project-dir`, `--project-base`/`--base-path`, `--prefix`, `--port`, `--no-run`, `--quiet`, `--json`
- Multi-shell PATH setup (bash, zsh, fish)
- Defensive CIAO style with safe defaults and anti-simplification guards
- Single output path (`out_text` / `out_json`)
- Help text with an automatic end-of-life warning for legacy versions

## Quick Installation

**For a normal login:**
```bash
curl -fsSL https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli | bash
```

**System-wide on Linux with sudo** (not for Termux, Git Bash, or Windows cmd):
```bash
curl -fsSL https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli | sudo bash
```

After installation, run:
```bash
springboot3
```

On a terminal this opens the numbered menu. Pick **1** to start Spring Boot 3.3.5 at **http://localhost:8080**. A non-interactive run with no command starts that app directly.

### Install integrity (automatic SHA-256)

The program **downloads the companion digest itself**. You do **not** set `CHECKSUM` for a normal install.

| Fact | What happens |
|------|----------------|
| **Algorithm** | SHA-256 (`sha256sum` / equivalent helpers in the script) |
| **Companion** | `${SCRIPT_URL}.sha256` — in-repo file `src/springboot-cli.sha256` next to `src/springboot-cli` |
| **No pin required** | Automatic mode when `CHECKSUM` is unset |
| **Transparency (human mode)** | Prints the companion **link**, expected **value**, and **result** |
| **Match** | Install / self-update continues |
| **Mismatch** | Abort; downloaded bytes are not installed |
| **Missing sidecar** | **Warn and continue** (best-effort; not a signed-release claim) |

Optional `CHECKSUM=<hex>` is a **CI / out-of-band pin only**. It is not a help command and is not a stronger same-channel guarantee than the automatic sidecar.

## Usage

```bash
springboot3                          # terminal: numbered menu; pipe: Boot 3.3.5 ensure + run
springboot3 menu                     # same numbered menu (needs a terminal)
springboot3 --springboot3            # Same default line, explicit
springboot3 --springboot2            # Boot 2.7.18 / Java 8 in ~/springboot-springboot2
springboot3 --boot 2 --no-run        # Boot 2 setup only
springboot3 install                  # Payload only: SDKMAN/Java/Maven/project (no app run)
springboot3 install --springboot2    # Payload setup for the Boot 2 line
springboot3 install --springboot3    # Payload setup for the Boot 3 line
springboot3 uninstall --force        # Payload only: remove managed project dir (not the CLI)
springboot3 run                      # Payload ensure + build + run
springboot3 --reset                  # Full reset: delete and regenerate project files
springboot3 --no-run                 # Setup only (no build/run) — useful for CI/Docker
springboot3 --project-dir <path>     # Run against one exact project directory
springboot3 --prefix shop --port 8088 --no-run
springboot3 --project-base /srv/apps --prefix api --port 9090 --springboot2 --no-run
springboot3 version                  # Show current version
springboot3 version-check            # Compare with latest on GitHub
springboot3 self-update              # Update to latest version
springboot3 self-uninstall           # Remove this program from the system
springboot3 help                     # Show this help
springboot3 --debug version          # Extra diagnostics on stderr (not under --json)
springboot3 --force-user version     # Prefer ~/.local/bin for this CLI
```

### Key behaviors

- **Command layers:** `install` / `uninstall` change the **environment and demo project**. `self-update` / `self-uninstall` change **this CLI script only**.
- **Terminal with no command:** numbered menu for Boot 3, Boot 2, setup only, language, and self-management. A pipe, `--json`, or `--quiet` with no command ensures **Boot 3.3.5** and does not wait for a key.
- **One-liner / empty arguments on a pipe:** places the CLI if needed, then ensures the **Boot 3.3.5** environment (not binary-only).
- **Line switch:** `--springboot2` or `--boot 2` selects Spring Boot **2.7.18**, Java **8** (`8.0.472-amzn`), `~/springboot-springboot2`, and TCP port **8081**. `--springboot3` or `--boot 3` selects Spring Boot **3.3.5**, Java **21** (`21.0.10-tem`), `~/springboot-springboot3`, and TCP port **8080**. `BOOT_LINE` accepts the same tokens. A flag wins over `BOOT_LINE`. `--project-dir` wins over the line's default folder.
- **More than one copy on this machine:** `--prefix <name>` builds `~/springboot-springboot3-<name>` (or the Boot 2 folder with the same suffix). `--project-base <path>` (alias `--base-path`) chooses the parent directory. `--port <1-65535>` sets `server.port` for that copy. `PROJECT_BASE`, `PROJECT_PREFIX`, and `PORT` are the matching environment names. An explicit `--project-dir` is the whole path and does not gain the prefix.
- **One-liner with a line:** `curl -fsSL https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli | bash -s -- --springboot2` or `curl -fsSL … | BOOT_LINE=springboot2 bash`.
- **Normal run:** Preserves your existing project folder, `pom.xml`, Java source, and `application.properties`.
- **`--reset` / `--force`:** Completely wipes and regenerates the project for a clean slate.
- **`--force-user` / `--force-root`:** Choose user (`~/.local/bin`) vs system (`/usr/local/bin`) place for this CLI.
- **Channel env:** `SCRIPT_URL`, `REPO_USER`, `REPO_NAME` (see `springboot3 help`). `CHECKSUM` is not a help command.

## Examples

```bash
springboot3 about                  # diagnostics (SDKMAN / Java / Maven / project)
springboot3 --no-run               # ensure environment; do not build/run the demo
springboot3 about --json           # machine-readable diagnostics
```

## Platform Compatibility

| Platform | Status | Notes |
|----------|--------|-------|
| **Ubuntu / Debian** | Excellent | Default bash |
| **Rocky / RHEL** | Excellent | No issues |
| **macOS** | Good | Supports official SDKMAN! |
| **Alpine Linux** | Good | SDKMAN needs **bash**, not BusyBox ash. Install bash first: `apk add bash`, then `bash <(curl -fsSL https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli)` |
| **Git Bash (Windows)** | Good | User-only install. Do not use the sudo one-liner. Do not invoke Termux `pkg`. |
| **Windows cmd** | Same class as Git Bash | User-only. Do not use the sudo one-liner. |
| **Termux** | User-only | Normal login only. Do not recommend `sudo curl \| sh`. |

## Related Projects

This program is the **springboot3** ship unit. It can set up two lines:

- `--springboot3` (default) → Spring Boot **3.3.5** / Java **21** Temurin
- `--springboot2` → Spring Boot **2.7.18** / Java **8** Amazon Corretto

Spring Boot 4 is not a line in this program. The two pins above stay fixed until a product decision changes them.

The script follows the **CIAO** defensive coding philosophy (Caution • Intentionality • Anti-fragility • Ownership) with heavy comments and `!!! DO NOT MODIFY OR SIMPLIFY !!!` blocks so it survives harsh environments and accidental “cleanup.”

See also [RECOMMENDATION.md](./RECOMMENDATION.md).

## Contributing

Please respect the defensive coding style and protective comments when submitting changes.
Any attempt to "clean up" or simplify the code will likely be rejected in favor of robustness.

## License

MIT. See [`LICENSE.md`](./LICENSE.md).

## Last Update

2026-10-07 — Product version **1.0.1**. The published file is **src/springboot-cli**. The command name stays **springboot3**. Public repository **cloudgen/springboot-cli**. A terminal with no command opens the numbered menu. A pipe with no command sets up Boot 3.3.5. Cache scratch is per login and per process. Line switch remains (`--springboot2`, `--springboot3`, `--boot`, `BOOT_LINE`).
