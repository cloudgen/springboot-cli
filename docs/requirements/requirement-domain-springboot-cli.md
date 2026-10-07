**file**: docs/requirements/requirement-domain-springboot-cli.md  
**Status**: Active (Version 1.4.0)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered)

## 1. Purpose

This requirement is the **project Single Source of Truth** for the **Spring Boot domain surface** of springboot-cli: SDKMAN / Java / Maven toolchain ensure, a **line switch** between Spring Boot 2.7.18 and Spring Boot 3.3.5, demo project create-preserve-reset, build and run, Alpine/bash constraints, and domain flags/commands — **beyond** Type 0 CLI self-management. The ship unit stays `springboot-cli`. The default line stays Boot 3.3.5 / Java 21. `--springboot2` selects the Boot 2.7.18 / Java 8 profile.

It owns product ops so agents do not treat shell lifecycle files alone as full-product law (see glossary: domain-requirements, requirement-sufficient-check).

**Scope:** Domain pins, helpers, default run path, project preserve/force, domain flags, help↔dispatcher alignment for domain surface.  
**Out of scope (cited, not re-owned):** Binary install / self-update / uninstall detail (`requirement-shell-self-management.md`); empty-argv Type O-P routing when not installed (`requirement-shell-cli-zero-arguments.md` — this domain file owns **payload steps** that empty argv must reach); full Type 0 command catalog (`requirement-shell-cli-interface.md`); automatic companion checksum (`requirement-shell-automatic-checksum.md`); output channel SSOT (`requirement-shell-output-requirements.md`).

**Payload online installer:** springboot-cli is Type O-P. Product-class law: `requirement-shell-payload-online-install.md`. Domain helpers below are the **payload content** (what `install` / empty-argv payload layer / `run` ensure). Command names: **`install`/`uninstall` = payload**; **`self-update`/`self-uninstall` = CLI only**.

---

### 1.1 Human-facing

**In one sentence:** This file owns which Spring Boot demo you get — Boot 3.3.5 by default, or Boot 2.7.18 when you pass the switch — and it places that demo's Java with SDKMAN in your own home, on Bash, because SDKMAN does not run under `/bin/sh`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Someone running `springboot-cli` to get a working demo app | `springboot-cli` or `springboot-cli --springboot2` |
| The other role | A future owner who may add a Boot 4 line after an explicit product decision | Do not add a third line as cleanup |
| Not this file | Installing or removing the `springboot-cli` program itself | `springboot-cli self-update` / `self-uninstall` |

| Includes | Excludes |
|----------|----------|
| SDKMAN/Java/Maven ensure, Bash instead of `/bin/sh`, the login tree `${HOME}/.sdkman`, `sdk use` / `sdk default` to swap Java, the Boot 2 / Boot 3 line switch, demo `pom.xml`/sources, preserve vs `--reset`, domain help | Placing the CLI binary; companion SHA-256 of the CLI; a Spring Boot 4 line; a system Java from `apt` or `dnf` |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/springboot-cli` | program file people install | domain helpers (`setup_*`, `run_springboot_project`) |
| `springboot-cli help` | command | domain flags and verbs |
| Demo `PROJECT_DIR` | `pom.xml`, `HelloApplication.java`, `application.properties` | the generated app |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Run the Boot 3 demo | Installed empty arguments or `run` builds and starts the Boot 3.3.5 app on port 8080. | `springboot-cli` or `springboot-cli --springboot3` |
| Run the Boot 2 demo | The same program sets up Spring Boot 2.7.18 and Java 8 in its own folder, on port 8081 unless you name another port. | `springboot-cli --springboot2` or `springboot-cli install --springboot2` |
| Run a second copy | A prefix or a base path makes another folder. A port makes another TCP listener. `--project-dir` still names one exact folder and wins. | `springboot-cli --prefix shop --port 8088 --no-run` |
| Keep your edits | Re-runs must not wipe `pom.xml` or sources unless you ask. `--reset` is the wipe. An explicit port updates only `server.port`. The two lines do not share a default folder. | `springboot-cli --reset` only when you want a clean demo |
| See the SDKMAN tree | Java and Maven for this login live under your home, not under `/usr`. A different login has a different tree. | `${HOME}/.sdkman` |
| Swap Java in this terminal | `sdk use` selects that identifier for this shell only. The other candidate stays installed. | `sdk use java 21.0.10-tem` or `sdk use java 8.0.472-amzn` |
| Swap Java for later terminals | `sdk default` is what a new shell picks. It does not have to match the shell you are in until you also `sdk use` it. | `sdk default java 21.0.10-tem` or `sdk default java 8.0.472-amzn` |

### Identity SSOT (this product — do not diverge)

| Field | Live value (ship unit `src/springboot-cli`) |
|-------|----------------------------------------|
| **APP_NAME** | `springboot-cli` |
| **VERSION** | `2.0.0` |
| **REPO_USER** / **REPO_NAME** | `cloudgen` / `springboot-cli` |
| **SCRIPT_URL** | `https://raw.githubusercontent.com/cloudgen/springboot-cli/main/src/springboot-cli` |
| **Shebang / runtime** | `#!/bin/bash` (SDKMAN requires bash) |
| **Dispatcher** | `app_main` (A naming) |
| **Output SSOT** | `out_text` / `out_json` / `out_json_error` (+ wrappers `out_info`/`out_success`/`out_warn`/`out_error`/`out_die`) |
| **Install SSOT** | `inst_perform_install` / `inst_maybe_install` / `inst_is_installed` / `inst_get_version` |
| **Domain helpers** | `check_alpine_requirements`, `setup_sdkman`, `setup_java`, `setup_maven`, `setup_springboot_project`, `run_springboot_project` |

Live scalars and pins are owned by the ship unit Config block and `domain_apply_boot_line`. On conflict with Config, use product identity protocol (ask; do not invent dual owners). The default line is **3.3.5** / Java 21. The second line is **2.7.18** / Java 8. **Do not** add a Spring Boot 4 line, or change either pin set, without an explicit product decision.

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Domain pins (normative for this product)

The ship unit **MUST** offer exactly two payload lines. Unset `BOOT_LINE` and a run with no line switch **MUST** select line `springboot3`. An unknown line **MUST** fail non-zero and **MUST NOT** generate a project.

| Pin | Line `springboot3` (default) | Line `springboot2` |
|-----|------------------------------|--------------------|
| **Switch** | `--springboot3`, `--boot 3`, `--boot springboot3`, `BOOT_LINE=3` or `springboot3` | `--springboot2`, `--boot 2`, `--boot springboot2`, `BOOT_LINE=2` or `springboot2` |
| **Spring Boot** | `3.3.5` | `2.7.18` |
| **Java (SDKMAN id)** | `21.0.10-tem` | `8.0.472-amzn` |
| **Java language level** | `21` | `1.8` |
| **Java label** | Java 21 (Eclipse Temurin) | Java 1.8 (Amazon Corretto) |
| **Default project dir** | `${HOME}/springboot-springboot-cli` | `${HOME}/springboot-springboot2` |
| **Artifact id** | `hello-springboot3` | `hello-springboot2` |

| Pin | Both lines | Contract |
|-----|------------|----------|
| **Maven** | `MAVEN_VER=3.9.14` | Maven ensure **MUST** install/use this pin via SDKMAN |
| **HTTP port / bind** | Boot 3 default `8080`, Boot 2 default `8081`, `BIND_IP=0.0.0.0` | Written into `application.properties` when generating. `--port` or a pre-set `PORT` **MUST** win over the line default on both lines |
| **Main class** | `MAIN_CLASS=HelloApplication` | Demo source name |
| **Project base** | `PROJECT_BASE` default `${HOME}` | `--project-base` or `--base-path` sets the parent of the generated folder |
| **Instance prefix** | empty | `--prefix <name>` appends `-${name}` to the line folder. It is one path segment, not a URL context path |
| **Explicit project dir** | `--project-dir <path>` or a pre-set `PROJECT_DIR` | **MUST** win over the line folder, `--project-base`, and `--prefix` |

`setup`, `install`, `run`, a line switch or domain payload flag with no positional verb, and `--no-run` **MUST** use the line selected for that invocation. A bare non-interactive empty argv **MUST NOT** enter this pipeline. A bare interactive TTY with no line switch and no domain payload flag opens the numbered menu (`requirement-shell-cli-default-interaction.md`) and **MUST NOT** start this pipeline until a leaf chooses a line. The silent Config default `BOOT_LINE` of `3` is not a line switch. The two default folders **MUST NOT** be the same path. A Boot 2 setup **MUST NOT** delete or rewrite the Boot 3 default folder, and the reverse **MUST NOT** happen, unless the operator passed the same `--project-dir` for both. Two prefixes or two bases **MUST** produce two directories. Setting up one **MUST NOT** delete the other. The Boot 3 default listen port is **8080**. The Boot 2 default listen port is **8081**. Those defaults exist so both default roots can listen on one machine. `--port` or a pre-set `PORT` selects one port for that invocation and **MUST** be an integer from 1 to 65535. A missing or invalid value **MUST** fail loud. An explicit port on an existing project **MUST** update `server.port` and **MUST NOT** wipe other project files. When the port was not explicit and `application.properties` already has `server.port`, this invocation **MUST** adopt that value so the banner and `about` match the file.

Agents **MUST NOT** change either pin set, or add a third line, as a casual cleanup. Header comments on the ship unit restate this intent.

### 2.2 Domain ensure pipeline (order)

When the domain run path applies (a line switch or domain payload flag with no positional verb, explicit `run`, or a menu leaf that starts a line), `app_main` **MUST** execute in order:

1. `check_alpine_requirements` — Alpine + bash availability for SDKMAN  
2. `setup_sdkman` — install or reuse SDKMAN  
3. `setup_java` — install/default/use pinned Java  
4. `setup_maven` — install/use pinned Maven  
5. `setup_springboot_project` — create or preserve demo project under `PROJECT_DIR`  
6. Unless `--no-run` / `NO_RUN=1`: `run_springboot_project` (`mvn clean package -DskipTests` then `java -jar` of expected artifact)

Failures **MUST** exit non-zero via output SSOT (`out_die` / `out_error`); **MUST NOT** fake success.

### 2.3 Project preserve vs reset

| Condition | Required behavior |
|-----------|-------------------|
| `PROJECT_DIR` missing | Create directory; generate demo files (pom, main class, `application.properties`, dirs) |
| `PROJECT_DIR` exists, force **off** | **Preserve** existing project files; regenerate only missing pieces; **MUST NOT** delete user edits |
| Force / reinstall policy **on** (`FORCE_REINSTALL=1` or equivalent documented flag) | May remove/regenerate project tree and overwrite demo files as designed |
| Help documents `--reset` | Dispatcher **MUST** parse and honor reset/force project policy **or** help **MUST NOT** advertise it (help↔dispatcher alignment) |

Live code keys full project wipe/regenerate on `FORCE_REINSTALL` from `--force` and/or **`--reset`** (dispatcher sets `FORCE_REINSTALL=1` / `RESET_PROJECT=1`).

### 2.3.1 Demo artifact samples (product-owned files)

When the demo project is generated, this requirement owns **fixed names** (not a sequenced queue). Filename grammar for those files: no prefix, no `n`; allocator = `setup_springboot_project`. Dest root = `PROJECT_DIR`. With no explicit directory, that root is `${PROJECT_BASE}/${PROJECT_NAME}` and, when `--prefix` is set, `${PROJECT_BASE}/${PROJECT_NAME}-<prefix>`. `PROJECT_NAME` is `springboot-springboot-cli` or `springboot-springboot2`. Default `PROJECT_BASE` is `${HOME}`. `--project-dir` replaces that composition.

| Role | Sample basename |
|------|-----------------|
| Maven POM | `pom.xml` |
| Main class | `src/main/java/com/example/HelloApplication.java` |
| App properties | `src/main/resources/application.properties` |

Sample `pom.xml` for the **default** line (parent pin **MUST** match the selected line; Boot 3 sample):

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.3.5</version>
  </parent>
  <artifactId>hello-springboot3</artifactId>
  <properties>
    <java.version>21</java.version>
  </properties>
</project>
```

Sample main class:

```java
package com.example;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
@SpringBootApplication
@RestController
public class HelloApplication {
  public static void main(String[] args) { SpringApplication.run(HelloApplication.class, args); }
  @GetMapping("/")
  public String hello() { return "Hello from springboot-cli"; }
}
```

Sample `application.properties` for the **Boot 3** default port. The Boot 2 default writes `server.port=8081`. `--port 9090` writes `server.port=9090` on either line. `server.address` stays `0.0.0.0` unless the file already exists and is kept.

```properties
server.port=8080
server.address=0.0.0.0
```

Boot 2 sample `pom.xml` (selected only by `--springboot2` / `--boot 2` / `BOOT_LINE=springboot2`):

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.7.18</version>
  </parent>
  <artifactId>hello-springboot2</artifactId>
  <properties>
    <java.version>1.8</java.version>
  </properties>
</project>
```

Boot 2 sample greeting inside `HelloApplication.java`:

```java
return "Hello from Spring Boot 2.7.18!<br/>Running on Java 1.8 (Amazon Corretto)";
```

Field tables without these samples are not enough for a domain-file claim. Preserve-without-force **MUST NOT** overwrite user-edited copies of these files. Generating one line **MUST NOT** overwrite the other line's default folder.

### 2.4 Domain flags and commands

| Surface | Contract |
|---------|----------|
| **Default cmd** | `cmd=run` when the dual-mode matrix selects the payload path and no command token is given |
| **Empty argv when installed** | Non-interactive, no line switch, no domain payload flag: ship-unit upgrade policy, then exit. **Not** this pipeline. Interactive TTY with no line switch: numbered menu, not this pipeline |
| **Empty argv when not installed** | Non-interactive, no line switch, no domain payload flag: ship-unit install, then exit. **Not** this pipeline. Interactive TTY with no line switch: numbered menu |
| **`setup` / `install`** | This pipeline through the project step. **MUST NOT** call `run_springboot_project` |
| `--project-dir <path>` | Set `PROJECT_DIR`; required path argument or fail loud; marks the directory explicit so the line switch, `--project-base`, and `--prefix` do not retarget it |
| `--project-base <path>` / `--base-path <path>` | Parent directory for the generated folder. Missing value or a newline **MUST** fail loud. Ignored for the path when `--project-dir` or a pre-set `PROJECT_DIR` is present |
| `--prefix <name>` | One instance segment: letters, digits, `.`, `_`, `-`, starting with a letter or digit, at most 64 characters. Missing or invalid **MUST** fail loud. Folder suffix `-<name>` |
| `--port <1-65535>` | Listen port for this copy. Missing, `0`, or a non-integer **MUST** fail loud. Updates `server.port` without a full project wipe |
| `--springboot3` / `--boot 3` | Select line `springboot3` (Boot 3.3.5 / Java 21). With no positional command, run this line’s payload path, including on a TTY. Not the menu |
| `--springboot2` / `--boot 2` | Select line `springboot2` (Boot 2.7.18 / Java 8). With no positional command, run this line’s payload path, including on a TTY. Not the menu |
| `--boot <value>` | Accepts `2`, `3`, `springboot2`, `springboot3`. Missing value or any other token **MUST** fail loud |
| `BOOT_LINE` | Same tokens as `--boot`. A flag on the same invocation wins over the environment variable |
| `--no-run` | Complete env + project setup; skip `run_springboot_project`; success message / JSON with `no_run` |
| `--force` / force-user / force-root | Privilege and reinstall policy; project regenerate when wired to `FORCE_REINSTALL` |
| `--quiet` / `-q`, `--json` | Same mode contract as shell output requirements; domain messages go through output SSOT |
| `run` | Explicit domain pipeline (same as default) |
| `status` | **Implemented** — routes to `app_about` |
| `reinstall` | **Implemented** — force CLI reinstall then domain pipeline |
| `--reset` | **Implemented** — force project regenerate via `FORCE_REINSTALL` |
| Type 0 cmds | `version`, `version-check`, `self-update`, `self-uninstall`, `about`, `help` exit before domain pipeline |

### 2.5 SDKMAN, Bash, and the normal-user tree

Java and Maven for this product **MUST** come from SDKMAN for the login that runs the program. **MUST NOT** install those pins with `apt`, `dnf`, `yum`, or Termux `pkg`. **MUST NOT** point the demo at a Java that lives outside this login's SDKMAN tree.

#### Why the shell is `/bin/bash` and not `/bin/sh`

SDKMAN's installer (`https://get.sdkman.io`) and `${HOME}/.sdkman/bin/sdkman-init.sh` are Bash scripts. They use Bash arrays, `[[ ]]`, and Bash functions. `/bin/sh` on Debian and Ubuntu is dash. `/bin/sh` on Alpine is ash. Those shells cannot run that installer or that init script.

| Rule | Contract |
|------|----------|
| Shebang | The ship unit **MUST** start with `#!/bin/bash`. **MUST NOT** change it to `#!/bin/sh`. |
| Started as a file under another shell | When `BASH_VERSION` is empty and bash is on `PATH`, and `$0` is the script file, the process **MUST** `exec bash` on that file. |
| Piped into `sh`, `dash`, `ash`, or `busybox` | There is no script path to re-exec. The process **MUST** exit 1 and say that springboot-cli requires bash. **MUST NOT** continue. |
| Alpine without bash | When `/etc/alpine-release` exists and bash is missing, **MUST** tell the operator `apk add bash` and exit 1. **MUST NOT** continue on ash. |

`SH` defaults to `bash`. The Alpine retry line is `bash <(curl -fsSL <channel>)`, not a pipe into `sh`.

#### SDKMAN path for this login

The tree belongs to the person who typed the command (**normal user privilege**). It is not a host-wide install and not another user's home.

| Piece | Path |
|-------|------|
| `SDKMAN_DIR` | `${HOME}/.sdkman` |
| `sdk` command | `${HOME}/.sdkman/bin/sdk` |
| Init script | `${HOME}/.sdkman/bin/sdkman-init.sh` |
| One Java identifier | `${HOME}/.sdkman/candidates/java/<id>` |
| Java selected for new work | `${HOME}/.sdkman/candidates/java/current` |
| One Maven identifier | `${HOME}/.sdkman/candidates/maven/<id>` |
| Maven selected for new work | `${HOME}/.sdkman/candidates/maven/current` |

`setup_sdkman` **MUST** source the init script through `util_source_external_safe` when the file is non-empty. A missing tree **MUST** install with `curl -fsSL https://get.sdkman.io | bash` as this login. After install, if `sdk` is still not on `PATH`, the helper **MUST** export `SDKMAN_DIR=${HOME}/.sdkman` and prepend `${HOME}/.sdkman/bin` plus the `java/current/bin` and `maven/current/bin` directories. If `sdk` is still missing, **MUST** `out_die`. **MUST NOT** install SDKMAN under `/usr`, `/opt`, or `/usr/local`.

#### Swap Java with SDKMAN

`setup_java` **MUST** run these three commands for the line's `JAVA_ID`, with nounset off so the candidate scripts do not abort the process, then put `${HOME}/.sdkman/candidates/java/current/bin` on `PATH`:

```bash
sdk install java "${JAVA_ID}"
sdk default java "${JAVA_ID}"
sdk use java "${JAVA_ID}"
```

`sdk install` downloads that identifier once into `candidates/java/<id>`. A second run that already has it is still success for this product when the following `sdk` commands can select it. `sdk use` changes **this shell only**. `sdk default` is what a **new** shell selects. The program runs both so the demo process and the next terminal agree. The other line's candidate **MUST** stay on disk. Swapping **MUST NOT** delete it.

Shown swaps for this product (the operator can type these after `. "${HOME}/.sdkman/bin/sdkman-init.sh"`):

| Line | Java identifier | This shell | Later shells |
|------|-----------------|------------|--------------|
| Boot 3.3.5 (default) | `21.0.10-tem` | `sdk use java 21.0.10-tem` | `sdk default java 21.0.10-tem` |
| Boot 2.7.18 | `8.0.472-amzn` | `sdk use java 8.0.472-amzn` | `sdk default java 8.0.472-amzn` |

Check the selection with `java -version` and `sdk current java`. Maven uses the same two verbs with identifier `3.9.14` (`sdk use maven 3.9.14`, `sdk default maven 3.9.14`). Domain helpers **MUST** keep user messages on the output helpers (`out_*`). Raw `echo` is not the product message for this section. The Alpine `apk add bash` hint is the existing `out_plain` line in `check_alpine_requirements`.

### 2.6 Help ↔ dispatcher (domain)

1. Every domain command/flag advertised in `app_help` **MUST** be parsed/routed in `app_main` (or help must drop the row).  
2. Help **MUST** state both line pins, the switches (`--springboot2`, `--springboot3`, `--boot`, `BOOT_LINE`), the root switches (`--project-dir`, `--project-base`, `--base-path`, `--prefix`), the listen switch (`--port`), and which line is active for this invocation.  
3. JSON help **MUST NOT** dump long human text (shell output / CLI interface rules apply).

### 2.7 Implementation Notes (live inventory)

| Item | Live value |
|------|------------|
| Domain entry | Default `cmd="run"` in `app_main` after Type 0 cases |
| Auto-install gate | `if ! inst_is_installed && [ $# -eq 0 ]` then install helpers — **not** when already installed |
| Domain chain | `check_alpine_requirements` → `setup_sdkman` → `setup_java` → `setup_maven` → `setup_springboot_project` → optional `run_springboot_project` |
| Project write | `util_write_file_atomic` for demo files |
| Run | `exec java -jar "target/${JAR_NAME}"` after successful package |
| Line apply | `domain_apply_boot_line` after flag parse, before help/about/install/run |
| About extras | Domain-rich diagnostics (boot line, Spring Boot pin, Java id, SDKMAN, project dir, port) via `app_about` |

#### Invocation samples (this topic-owner)

```bash
springboot-cli
springboot-cli run
springboot-cli --springboot3
springboot-cli --springboot2
springboot-cli install --springboot2
springboot-cli install --springboot3
springboot-cli --boot 2 --no-run
springboot-cli --boot 3 --no-run
springboot-cli --no-run
springboot-cli --prefix shop --port 8088 --no-run
springboot-cli --project-base /srv/apps --prefix api --port 9090 --springboot2 --no-run
springboot-cli --base-path /srv/apps --prefix api --port 9090 --no-run
springboot-cli --reset
springboot-cli status
springboot-cli reinstall
```

#### Compliance notes (implementation status) — re-read disk 2026-07-15

| Item | Status |
|------|--------|
| `--springboot2` / `--springboot3` / `--boot` | **Implemented** — `domain_apply_boot_line` |
| `--project-base` / `--base-path` / `--prefix` / `--port` | **Implemented** — separate roots and TCP ports on one machine |
| `--reset` → project regenerate | **Implemented** |
| `status` / `reinstall` routed | **Implemented** |
| `--force` → `FORCE_REINSTALL=1` | **Implemented** |
| Empty argv installed = ship unit only | **Implemented** — no domain pipeline unless `setup`, `run`, a line switch, or a domain payload flag |
| Preserve without force | **Implemented** |
| `install` / `uninstall` (payload) | **Required** — `payload_install` / `payload_uninstall` |
| Empty argv not-installed stops after the CLI | **Required** — `setup` is the payload. A bare pipe does not enter this domain |
| Residual | Real SDKMAN/Java network path not fully mocked beyond suite stubs; production run needs network/toolchain |

### 2.8 Why This Requirement Exists (Direct CIAO Alignment)

- **Caution:** Preserve existing projects by default; fail loud on Alpine/bash and toolchain failure.  
- **Intentional:** Two pin sets and the pipeline order are deliberate. Boot 3.3.5 stays the default. Boot 2.7.18 is opt-in.  
- **Anti-fragile:** Re-run preserves project; force regenerates; works after self-install.  
- **Over-protect:** Do not drop domain law, collapse pins, or let help advertise unrouted domain commands.  
- **SSOT:** Config owns pins; this file owns domain behavioral law; Type 0 files own binary lifecycle.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- Domain is **additive** to Type 0 — never a reason to delete self-management.  
- Non-interactive empty argv with no line switch and no domain payload flag installs or updates the CLI and stops. `setup` installs the payload and does not start the app. A bare interactive TTY opens the numbered menu.  
- Help, dispatcher, and this requirement stay synchronized.  
- Prefer surgical code changes over “cleanup” that rewrites defensive domain helpers.

---

## Under command line for normal user only

When the program detects Termux, Git Bash, Windows Command Prompt, or the same class (this login only; no root switch):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or a **dedicated system user** |
| SDKMAN/Java/Maven/demo run as this login | Wrap `apt`/`dnf`/`yum` for Java; write `/etc`; recommend `sudo curl \| sh` on that class |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or cmd was detected |

Detect (typical): Termux — `PREFIX` contains `com.termux`. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*`. Windows cmd — `OS` is `Windows_NT` after excluding Git Bash, Cygwin, and WSL.

**This requirement:** domain start/stop and toolchain ensure stay this-login SDKMAN; they are not host package elevation.

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Change either line's Spring Boot / Java / Maven pins, drop the line switch, or add another line without an explicit product decision and requirement revision.  
2. Delete or simplify domain helpers (`setup_*`, `run_springboot_project`, Alpine check) as drive-by cleanup.  
2a. Change the shebang to `#!/bin/sh`, or move SDKMAN out of `${HOME}/.sdkman`, or replace `sdk use` / `sdk default` with a host package manager.  
3. Put the payload back on a bare non-interactive empty argv, or make a TTY `--springboot2` with no verb open the menu, without updating this file, `requirement-shell-cli-zero-arguments.md`, and `requirement-shell-cli-default-interaction.md`.  
4. Advertise domain commands/flags in help without dispatcher wiring (or leave known Gaps untracked).  
5. Default to destroying an existing `PROJECT_DIR` without force/reset policy.  
6. Treat shell lifecycle requirements alone as full-product sufficient law while this domain surface exists.  
7. Reverse-copy this product’s domain pins into unrelated bootstrap seeds as if they were universal.

**Violating this rule is a critical domain regression.**

---

## 5. Definition of done (domain)

This requirement is satisfied when:

1. Both pin rows in §2.1 match `domain_apply_boot_line` (default line matches Config until that function runs).  
2. Domain pipeline §2.2 runs for installed default/`run`.  
3. Project preserve/force rules §2.3 hold.  
4. Domain flags/commands §2.4 are either Implemented or listed as Gap with honest status.  
5. SDKMAN §2.5 holds: shebang stays `#!/bin/bash`, the tree is `${HOME}/.sdkman`, and Java swap is `sdk use` plus `sdk default` for the line's identifier.  
6. Help↔dispatcher §2.6 has no silent drift.  
7. Registered in `docs/requirements/index.md`.  
8. Traceability: implementation changes cite this file path / key `requirement-domain-springboot-cli`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Type O-P empty argv; combined ship unit + payload |
| `docs/requirements/requirement-shell-cli-interface.md` | Type 0 command surface; domain addendum |
| `docs/requirements/requirement-shell-self-management.md` | Binary lifecycle only |
| `docs/requirements/requirement-shell-output-requirements.md` | Output SSOT for domain messages |
| `docs/requirements/requirement-shell-idempotency.md` | Ensure re-run (lifecycle); domain preserve is complementary |
| `docs/requirements/index.md` | Registry SSOT |
| `src/springboot-cli` | Implementation under test |

---

**Last Updated**: 2026-10-07  
**Owner**: springboot-cli project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO (https://github.com/cloudgen/ciao); CIAO-Lite; default Boot 3.3.5 line plus explicit Boot 2.7.18 switch.

## Terminologies

### Payload installer

**Definition:** A payload installer (also payload online installer) is an online install script whose empty-argv / one-liner contract ensures both the ship unit and payload (toolchains, packages, projects)—not merely a script on disk.

**Human daily-life explanation:** A payload-installer is an online installer whose empty run makes sure both the tool and the extra kits (compilers, packages) are there, not just the script file.

**Daily-life example:** A one-call “send me the mixer and also stock the flour and eggs” service, not “send only the mixer.”

### Domain requirements

**Definition:** Domain requirements are project requirements that specify the specialized product’s domain product law—beyond CLI self-management. They cover specialized commands and flags, specialized features (with real samples when files are allocated), help items, and about items. A product with a domain surface has exactly one Active domain-requirements file.

**Human daily-life explanation:** Domain requirements are this product’s written extra-job law — specialized commands, features (with real samples when files are allocated), help items, and about items — beyond install/self-update. A domain product has exactly one Active file as current law.

**Daily-life example:** A café’s extra-job binder lists how takeout works, with a filled sample ticket — not just “we also serve food.” That binder is domain requirements; opening and closing the shop is a different binder.

### Normal user privilege

**Definition:** Normal user privilege is the layer in which a command runs as the person who typed it, with no root and no switch into a dedicated system account. That login may install this program into their own PATH and may install a toolchain under their own home. Normal user privilege must not change the host OS, write `/etc`, or create a dedicated system account.

**Human daily-life explanation:** You run the command as the ordinary login who typed it. Everyday picture: your own keys — tidy your desk and put a tool in your own drawer. You may not rewrite the building lock list.

**Daily-life example:** You install Java under your home with SDKMAN. You do not need admin privilege to do that.

### Command line for normal user only

**Definition:** A command line for normal user only is a shell environment whose privilege ceiling is normal user privilege. Typical instances are Termux, Git Bash, and Windows Command Prompt. There is no usable root switch and no dedicated system account for this login. When the program detects that class, it must not enable admin privilege or a dedicated system user: no in-tool sudo, no apt or dnf wrap, and no system-user create.

**Human daily-life explanation:** This is a keyboard that only has your keys. Termux on a phone, Git Bash on Windows, and Windows Command Prompt are this kind of room: you can tidy your own drawer; you cannot borrow the building site key.

**Daily-life example:** On that room, Java still comes from SDKMAN in your home. The program does not grow a `sudo apt install` for Java.

## 7. Revision history

| Date | Change | Author / agent |
|------|--------|----------------|
| 2026-10-07 | Active v1.4.0: SDKMAN is the Java and Maven installer for this login. The shell stays `/bin/bash` because SDKMAN does not run under `/bin/sh`. The tree is `${HOME}/.sdkman`. Java swap is `sdk use` for this shell and `sdk default` for later shells (`21.0.10-tem` or `8.0.472-amzn`). | Grok (owner request) |
| 2026-10-07 | Active v1.3.0: `--project-base` / `--base-path`, `--prefix`, and `--port` keep more than one root and more than one TCP port on one machine. `--project-dir` still wins. Boot 2 default port is 8081; Boot 3 stays 8080 | Grok (product decision) |
| 2026-10-07 | Active v1.2.0: A line switch with no verb still runs that line, including on a TTY. A bare TTY opens the numbered menu and does not auto-run this pipeline | Grok (owner confirm) |
| 2026-10-07 | Active v1.1.0: line switch `--springboot2` / `--springboot3` / `--boot` / `BOOT_LINE`; separate default project dirs; Boot 2.7.18 / Java 8 opt-in; default remains 3.3.5 / Java 21 | Grok (product decision) |
| 2026-08-10 | Rename key/path to `requirement-domain-springboot-cli` (domain naming law) | Grok (fix-all) |
| 2026-07-15 | Initial Active v1.0.0: domain pins, pipeline, preserve/force, flags, Alpine, help↔dispatcher, Gaps | Grok (authorized 1–3) |
| 2026-08-10 | Specialized from bootstrap springboot2: identity + Boot 3.3.5 / Java 21 Temurin pins; Type O-P architecture inherited | Grok council |

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-DOM-01–11** | `tests/test_domain.sh` | have |
| **TP-DOM-12** | `tests/test_domain.sh` | have |
| **TP-LC-01** | `tests/test_install_lifecycle.sh` | have |

**Suite map:** `tests/README.md` (TP labels in suite files).
