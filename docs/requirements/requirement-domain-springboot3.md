**file**: docs/requirements/requirement-domain-springboot3.md  
**Status**: Active (Version 1.3.0)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered)

## 1. Purpose

This requirement is the **project Single Source of Truth** for the **Spring Boot domain surface** of springboot3: SDKMAN / Java / Maven toolchain ensure, a **line switch** between Spring Boot 2.7.18 and Spring Boot 3.3.5, demo project create-preserve-reset, build and run, Alpine/bash constraints, and domain flags/commands — **beyond** Type 0 CLI self-management. The ship unit stays `springboot3`. The default line stays Boot 3.3.5 / Java 21. `--springboot2` selects the Boot 2.7.18 / Java 8 profile.

It owns product ops so agents do not treat shell lifecycle files alone as full-product law (see glossary: domain-requirements, requirement-sufficient-check).

**Scope:** Domain pins, helpers, default run path, project preserve/force, domain flags, help↔dispatcher alignment for domain surface.  
**Out of scope (cited, not re-owned):** Binary install / self-update / uninstall detail (`requirement-shell-self-management.md`); empty-argv Type O-P routing when not installed (`requirement-shell-cli-zero-arguments.md` — this domain file owns **payload steps** that empty argv must reach); full Type 0 command catalog (`requirement-shell-cli-interface.md`); automatic companion checksum (`requirement-shell-automatic-checksum.md`); output channel SSOT (`requirement-shell-output-requirements.md`).

**Payload online installer:** springboot3 is Type O-P. Product-class law: `requirement-shell-payload-online-install.md`. Domain helpers below are the **payload content** (what `install` / empty-argv payload layer / `run` ensure). Command names: **`install`/`uninstall` = payload**; **`self-update`/`self-uninstall` = CLI only**.

---

### 1.1 Human-facing

**In one sentence:** This file owns **which Spring Boot demo you get** — Boot 3.3.5 by default, or Boot 2.7.18 when you pass the switch — and how that demo folder and TCP port are chosen so more than one copy can run on the same machine.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Someone running `springboot3` to get a working demo app | `springboot3` or `springboot3 --springboot2` |
| The other role | A future owner who may add a Boot 4 line after an explicit product decision | Do not add a third line as cleanup |
| Not this file | Installing or removing the `springboot3` program itself | `springboot3 self-update` / `self-uninstall` |

| Includes | Excludes |
|----------|----------|
| SDKMAN/Java/Maven ensure, the Boot 2 / Boot 3 line switch, demo `pom.xml`/sources, preserve vs `--reset`, domain help | Placing the CLI binary; companion SHA-256 of the CLI; a Spring Boot 4 line |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./springboot3` | program file people install | domain helpers (`setup_*`, `run_springboot_project`) |
| `springboot3 help` | command | domain flags and verbs |
| Demo `PROJECT_DIR` | `pom.xml`, `HelloApplication.java`, `application.properties` | the generated app |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Run the Boot 3 demo | Installed empty arguments or `run` builds and starts the Boot 3.3.5 app on port 8080. | `springboot3` or `springboot3 --springboot3` |
| Run the Boot 2 demo | The same program sets up Spring Boot 2.7.18 and Java 8 in its own folder, on port 8081 unless you name another port. | `springboot3 --springboot2` or `springboot3 install --springboot2` |
| Run a second copy | A prefix or a base path makes another folder. A port makes another TCP listener. `--project-dir` still names one exact folder and wins. | `springboot3 --prefix shop --port 8088 --no-run` |
| Keep your edits | Re-runs must not wipe `pom.xml` or sources unless you ask. `--reset` is the wipe. An explicit port updates only `server.port`. The two lines do not share a default folder. | `springboot3 --reset` only when you want a clean demo |

### Identity SSOT (this product — do not diverge)

| Field | Live value (ship unit `./springboot3`) |
|-------|----------------------------------------|
| **APP_NAME** | `springboot3` |
| **VERSION** | `1.0.0` |
| **REPO_USER** / **REPO_NAME** | `cloudgen` / `springboot-cli` |
| **SCRIPT_URL** | `https://raw.githubusercontent.com/cloudgen/springboot-cli/main/springboot3` |
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
| **Default project dir** | `${HOME}/springboot-springboot3` | `${HOME}/springboot-springboot2` |
| **Artifact id** | `hello-springboot3` | `hello-springboot2` |

| Pin | Both lines | Contract |
|-----|------------|----------|
| **Maven** | `MAVEN_VER=3.9.14` | Maven ensure **MUST** install/use this pin via SDKMAN |
| **HTTP port / bind** | Boot 3 default `8080`, Boot 2 default `8081`, `BIND_IP=0.0.0.0` | Written into `application.properties` when generating. `--port` or a pre-set `PORT` **MUST** win over the line default on both lines |
| **Main class** | `MAIN_CLASS=HelloApplication` | Demo source name |
| **Project base** | `PROJECT_BASE` default `${HOME}` | `--project-base` or `--base-path` sets the parent of the generated folder |
| **Instance prefix** | empty | `--prefix <name>` appends `-${name}` to the line folder. It is one path segment, not a URL context path |
| **Explicit project dir** | `--project-dir <path>` or a pre-set `PROJECT_DIR` | **MUST** win over the line folder, `--project-base`, and `--prefix` |

`install`, `run`, non-interactive empty argv, a line switch or domain payload flag with no positional verb, and `--no-run` **MUST** use the line selected for that invocation. A bare interactive TTY with no line switch and no domain payload flag opens the numbered menu (`requirement-shell-cli-default-interaction.md`) and **MUST NOT** start this pipeline until a leaf chooses a line. The silent Config default `BOOT_LINE` of `3` is not a line switch. The two default folders **MUST NOT** be the same path. A Boot 2 setup **MUST NOT** delete or rewrite the Boot 3 default folder, and the reverse **MUST NOT** happen, unless the operator passed the same `--project-dir` for both. Two prefixes or two bases **MUST** produce two directories. Setting up one **MUST NOT** delete the other. The Boot 3 default listen port is **8080**. The Boot 2 default listen port is **8081**. Those defaults exist so both default roots can listen on one machine. `--port` or a pre-set `PORT` selects one port for that invocation and **MUST** be an integer from 1 to 65535. A missing or invalid value **MUST** fail loud. An explicit port on an existing project **MUST** update `server.port` and **MUST NOT** wipe other project files. When the port was not explicit and `application.properties` already has `server.port`, this invocation **MUST** adopt that value so the banner and `about` match the file.

Agents **MUST NOT** change either pin set, or add a third line, as a casual cleanup. Header comments on the ship unit restate this intent.

### 2.2 Domain ensure pipeline (order)

When the domain run path applies (non-interactive empty argv, a line switch or domain payload flag with no positional verb, explicit `run`, or a menu leaf that starts a line), `app_main` **MUST** execute in order:

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

When the demo project is generated, this requirement owns **fixed names** (not a sequenced queue). Filename grammar for those files: no prefix, no `n`; allocator = `setup_springboot_project`. Dest root = `PROJECT_DIR`. With no explicit directory, that root is `${PROJECT_BASE}/${PROJECT_NAME}` and, when `--prefix` is set, `${PROJECT_BASE}/${PROJECT_NAME}-<prefix>`. `PROJECT_NAME` is `springboot-springboot3` or `springboot-springboot2`. Default `PROJECT_BASE` is `${HOME}`. `--project-dir` replaces that composition.

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
  public String hello() { return "Hello from springboot3"; }
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
| **Empty argv when installed** | Non-interactive: domain run pipeline (§2.2) + ship-unit upgrade policy — **not** Type O-S binary no-op. Interactive TTY with no line switch: numbered menu, not this pipeline |
| **Empty argv when not installed** | Non-interactive Type O-P: ship-unit install **then** this domain pipeline. Interactive TTY with no line switch: numbered menu |
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

### 2.5 Alpine / bash

1. Shebang **MUST** remain `#!/bin/bash` while SDKMAN requires bash.  
2. On Alpine (`/etc/alpine-release`), if bash is missing, **MUST** instruct install (`apk add bash`) and fail non-zero — **MUST NOT** continue silently with ash-only assumptions.  
3. Domain helpers **MUST** keep using output SSOT (no raw `echo` for user messages).

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
springboot3
springboot3 run
springboot3 --springboot3
springboot3 --springboot2
springboot3 install --springboot2
springboot3 install --springboot3
springboot3 --boot 2 --no-run
springboot3 --boot 3 --no-run
springboot3 --no-run
springboot3 --prefix shop --port 8088 --no-run
springboot3 --project-base /srv/apps --prefix api --port 9090 --springboot2 --no-run
springboot3 --base-path /srv/apps --prefix api --port 9090 --no-run
springboot3 --reset
springboot3 status
springboot3 reinstall
```

#### Compliance notes (implementation status) — re-read disk 2026-07-15

| Item | Status |
|------|--------|
| `--springboot2` / `--springboot3` / `--boot` | **Implemented** — `domain_apply_boot_line` |
| `--project-base` / `--base-path` / `--prefix` / `--port` | **Implemented** — separate roots and TCP ports on one machine |
| `--reset` → project regenerate | **Implemented** |
| `status` / `reinstall` routed | **Implemented** |
| `--force` → `FORCE_REINSTALL=1` | **Implemented** |
| Empty argv installed = domain pipeline | **Implemented** (hybrid) |
| Preserve without force | **Implemented** |
| `install` / `uninstall` (payload) | **Required** — `payload_install` / `payload_uninstall` |
| Empty argv not-installed continues to domain | **Required (Type O-P)** — ship install then payload (no binary-only exit) |
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
- Non-interactive empty argv is **Type O-P combined ensure**: not installed → ship unit **then** domain; installed → upgrade policy + domain run. A bare interactive TTY opens the numbered menu.  
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
3. Change non-interactive empty argv from domain run back to an install-only no-op, or make a TTY `--springboot2` with no verb open the menu, without updating this file, `requirement-shell-cli-zero-arguments.md`, and `requirement-shell-cli-default-interaction.md`.  
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
5. Alpine/bash §2.5 holds.  
6. Help↔dispatcher §2.6 has no silent drift.  
7. Registered in `docs/requirements/index.md`.  
8. Traceability: implementation changes cite this file path / key `requirement-domain-springboot3`.

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
| `./springboot3` | Implementation under test |

---

**Last Updated**: 2026-10-07  
**Owner**: springboot3 project maintainers  
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

## 7. Revision history

| Date | Change | Author / agent |
|------|--------|----------------|
| 2026-10-07 | Active v1.3.0: `--project-base` / `--base-path`, `--prefix`, and `--port` keep more than one root and more than one TCP port on one machine. `--project-dir` still wins. Boot 2 default port is 8081; Boot 3 stays 8080 | Grok (product decision) |
| 2026-10-07 | Active v1.2.0: A line switch with no verb still runs that line, including on a TTY. A bare TTY opens the numbered menu and does not auto-run this pipeline | Grok (owner confirm) |
| 2026-10-07 | Active v1.1.0: line switch `--springboot2` / `--springboot3` / `--boot` / `BOOT_LINE`; separate default project dirs; Boot 2.7.18 / Java 8 opt-in; default remains 3.3.5 / Java 21 | Grok (product decision) |
| 2026-08-10 | Rename key/path to `requirement-domain-springboot3` (domain naming law) | Grok (fix-all) |
| 2026-07-15 | Initial Active v1.0.0: domain pins, pipeline, preserve/force, flags, Alpine, help↔dispatcher, Gaps | Grok (authorized 1–3) |
| 2026-08-10 | Specialized from bootstrap springboot2: identity + Boot 3.3.5 / Java 21 Temurin pins; Type O-P architecture inherited | Grok council |

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-DOM-01–11** | `tests/test_domain.sh` | have |
| **TP-LC-01** | `tests/test_install_lifecycle.sh` | have |

**Suite map:** `tests/README.md` (TP labels in suite files).
