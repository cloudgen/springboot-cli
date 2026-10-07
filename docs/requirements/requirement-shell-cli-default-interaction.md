**file**: docs/requirements/requirement-shell-cli-default-interaction.md
**Status**: Active (Version 1.1.0)
**Area**: shell
**Key**: `requirement-shell-cli-default-interaction`
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the product law for the springboot3 **TTY numbered menu** and for the **dual-mode matrix** that decides when that menu is drawn and when the Type O-P combined ensure still runs.

On a real terminal, a run with no positional verb, no Spring Boot line switch, and no domain payload flag opens a numbered tree: Spring Boot 3.3.5, Spring Boot 2.7.18, setup only, language, self-management, and Exit. A pipe, a missing terminal, `--json`, or `--quiet` with no positional verb stays the combined ensure and must not wait for a key. A line switch or a domain payload flag with no positional verb still runs that payload path, including on a terminal, so `--springboot2` does not turn into the menu.

The language codes and the translated words live in `requirement-shell-cli-language.md`. The payload pins and the demo files live in `requirement-domain-springboot3.md`. Empty-argv detect and the non-interactive ensure live in `requirement-shell-cli-zero-arguments.md`. This file owns the matrix and the numbered tree.

The ship unit `./springboot3` at VERSION 1.0.0 draws this tree. The handlers are in that file. TP-MENU-01 through TP-MENU-05 are have.

### 1.1 Human-facing

**In one sentence:** On a keyboard session, typing `springboot3` with no command shows a numbered board for Boot 3, Boot 2, setup only, language, and self-management; a pipe still installs and sets up the demo without waiting.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Picking a number on a real terminal | `springboot3`, then `1` |
| The other role | A pipe or a script that must not wait | `curl … \| bash` |
| Not this file | The Spring Boot pin tables, and the words of each language | Domain file and language file |

| Includes | Excludes |
|----------|----------|
| Front **1 / 2 / 3 / 5 / 8 / 9**; setup **31 / 32**; language **51–63**; self-management **81–86**; **0** Back | A `self-install` row; a sudoers row; SSH config backup; Termux `pkg`; payload `uninstall` as a numbered row |
| Bold short name and italic explanation on each command row | Help pages; a JSON menu catalog |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./springboot3` | ship unit | the menu, once the handlers exist |
| `springboot3 menu` | command | the same tree on a terminal |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Open the front board | Boot 3, Boot 2, setup only, language, self-management, and Exit. Nothing starts until you pick a row. | `springboot3` on a terminal |
| Start Boot 3 | Set up and run Spring Boot 3.3.5 on Java 21. A successful start replaces this process, so the board does not come back. | `1` |
| Start Boot 2 | Set up and run Spring Boot 2.7.18 on Java 8. Same replacement on success. | `2` |
| Write the project only | A side board, then one line, and you return to the front board. | `3`, then `31` or `32` |
| Change the language | Thirteen languages. **0** goes back and does not save. | `5`, then `51` through `63` |
| Care for this program | Payload install, local version, diagnostics, version check, channel update, remove this program. | `8`, then `81` through `86` |
| Leave | The program returns success. | `9` |
| Keep a pipe automatic | No board and no read. The combined ensure still runs. | `curl -fsSL …/springboot3 \| bash` |

## 2. Core Rules / Requirements (Mandatory)

**Claimed:** yes. A zero-arguments requirement already exists, so non-interactive empty argv stays that file’s combined ensure. This file adds the interactive half and the numbered tree.

### 2.1 Dual-mode matrix (normative)

Empty argv means `$# -eq 0` **before** flag parse, so `--no-run` alone is not empty argv. “No positional verb” is the state **after** flag parse when no command token remains. Both columns below use that distinction.

A **line switch** is `--springboot2`, `--springboot3`, `--boot`, or an operator-set `BOOT_LINE` (`BOOT_LINE_SET=1`). The silent Config default `BOOT_LINE` of `3` is **not** a line switch. If it were, the menu could never open.

A **domain payload flag** is `--no-run`, `--reset`, `--force`, `--project-dir`, `--project-base`, `--base-path`, `--prefix`, `--port`, `--force-user`, or `--force-root`. `--debug` is not one of these.

| Situation | What runs | Menu | `read` |
|-----------|-----------|------|--------|
| Non-interactive, no positional verb: no TTY, a pipe, `curl \| bash`, `--json`, or `--quiet` | Type O-P combined ensure (ship unit if needed, then the payload). `--json` with no command is **not** JSON help and **not** this menu. | no | no; must not hang |
| Interactive TTY, no positional verb, no line switch, no domain payload flag. Examples: `springboot3`, `springboot3 --debug` | This numbered tree. Do not place the CLI and do not start the payload until a leaf that needs them is chosen. | yes | yes, current shell |
| Line switch or domain payload flag, no positional verb, including on a TTY. Examples: `--springboot2`, `--boot 2`, `--no-run`, `--project-dir DIR`, `--prefix shop`, `--port 8088` | That line’s payload path. Not this menu. | no | no, unless an existing confirm on that path already requires one |
| `menu` or `main` on a TTY | This same tree. | yes | yes, current shell |
| `menu` or `main` with no TTY, or with `--quiet` | Fail loud with `out_die`. Name the command. Do not `read`. | no | no |
| A positional verb (`install`, `run`, `help`, …) | That verb, unchanged. | no | only when that verb already confirms |

A second empty argv on a TTY is the menu again. It is not a second payload run. A second empty argv with no TTY stays the payload ensure.

`menu` and `main` are operational verbs. They are not numbered rows. `help` is not a numbered row.

### 2.2 Front board (this product)

| Number | Parent | Short | Long | What it runs | Who sees it |
|--------|--------|-------|------|--------------|-------------|
| **1** | — | Spring Boot 3.3.5 | set up and run Spring Boot 3.3.5 on Java 21 | Leaf: line `springboot3`, then the domain run path | Always |
| **2** | — | Spring Boot 2.7.18 | set up and run Spring Boot 2.7.18 on Java 8 | Leaf: line `springboot2`, then the domain run path | Always |
| **3** | — | Setup only | write the project and do not start it | Setup submenu | Always |
| **5** | — | language | display language for this menu | Language submenu | Always, including Termux, Git Bash, and Windows cmd |
| **8** | — | self-management | payload install, version, update, and remove this CLI | Self-management submenu | Always |
| **9** | — | Exit | leave the program | Return 0 | Always |

Front **4**, **6**, and **7** are not rows. There is no sudoers board. There is no menu-hidden message for a row this product never claims. Picking **4**, **6**, or **7** is an invalid choice on the front board.

**MUST NOT** list `install`, `version`, `about`, `version-check`, `self-update`, `self-uninstall`, `self-install`, `uninstall`, `help`, `menu`, or `main` on the front board.

Rows **1** and **2** are this product’s payload lines. They are not an SSH client board and not an SSH server board.

### 2.3 Setup submenu (parent **3**)

| Number | Short | Long | What it runs |
|--------|-------|------|--------------|
| **31** | Spring Boot 3.3.5 | write the Boot 3 project and do not start it | Line `springboot3` with `--no-run` |
| **32** | Spring Boot 2.7.18 | write the Boot 2 project and do not start it | Line `springboot2` with `--no-run` |
| **0** | Back | return to the front board | Parent |

### 2.4 Self-management submenu (parent **8**)

| Number | Short (English verb in every language) | Long | What it runs |
|--------|----------------------------------------|------|--------------|
| **81** | install | install the Spring Boot payload (default Boot 3.3.5) | Payload `install` on line `springboot3`. This is not a second “place the CLI only” meaning. |
| **82** | version | show the local CLI version | Local version one-liner. **MUST NOT** run `about`. |
| **83** | about | show diagnostics | `about` |
| **84** | version-check | compare local and remote CLI versions | `version-check` |
| **85** | self-update | update this CLI from the channel | `self-update` |
| **86** | self-uninstall | remove this CLI | `self-uninstall`, including the existing confirm rule |
| **0** | Back | return to the front board | Parent |

**87** is reserved and is not printed. This product has no `self-install` verb. Picking **87** is an invalid choice on this layer.

Payload `uninstall` stays a typed verb. It is not a numbered row. A person who types `uninstall` at a prompt still reaches that verb and its confirm rule.

### 2.5 Language submenu (parent **5**)

The block **50–69** holds at most twenty languages. This version assigns **51** through **63**. **50** and **64** through **69** are reserved and are not printed. The codes, the file, and the translated sentences are `requirement-shell-cli-language.md`.

| Number | Saves |
|--------|--------|
| **51** | `en` |
| **52** | `zh-Hans` |
| **53** | `zh-Hant` |
| **54** | `es` |
| **55** | `ar` |
| **56** | `fr` |
| **57** | `pt` |
| **58** | `ru` |
| **59** | `de` |
| **60** | `ja` |
| **61** | `ko` |
| **62** | `nl` |
| **63** | `el` |
| **0** | Back. Does not write the language file. |

### 2.6 Numbering

1. A command number appears once in the whole tree.
2. A child number starts with its parent’s digits, except the language block **50–69** under front **5**.
3. Every submenu prints **0** Back. Empty input on a submenu means Back.
4. A hidden or reserved number stays reserved. Picking it reprints **that** layer.
5. **MUST NOT** restart a submenu at **1**. **MUST NOT** use **9** as submenu Exit. Front Exit stays **9**.

### 2.7 After a finished command

After a valid leaf returns, show the front board again. Do not stay on the submenu that launched it.

**Exception:** rows **1** and **2** start the demo with `exec java -jar` on success. That call replaces this process, so the front board is not drawn again after a successful start. If that start returns instead of replacing the process, show the front board.

After **86** `self-uninstall` succeeds, leave the program (return 0). Do not draw the front board for a CLI that was just removed.

A language pick **51–63** is a valid leaf: show the front board in the language just saved. **0**, an empty line, or EOF on a submenu is Back, not a finished command.

### 2.8 Invalid choice

An invalid choice is any input that is not a listed number, not a listed name, and not this layer’s leave or back token. A reserved number is an invalid choice.

**MUST:** print `out_error` that names the token and tells the operator to choose a listed number or command name, reprint **this** layer, and `read` again in the current shell.

**MUST NOT** `out_die` for that pick. **MUST NOT** exit non-zero only for that pick. **MUST NOT** treat the pick as an unknown command-line verb. EOF or a failed `read` leaves this layer without spinning.

### 2.9 Do not capture `read`

The choice on every layer is `read -r` in the **current shell**, into the choice variable. The same shape applies when an invalid choice reprints the layer.

**MUST NOT** wrap `read`, or a function whose body contains `read`, in `$()` or backticks. A pure string helper that never calls `read` may be used in `$()`.

There is no secret field and no multi-field walk. Payload flags stay operands on the command line. The menu number is this single `read`.

### 2.10 Style

Every command row prints **number**, **bold** short description, and *italic* long description. On a TTY the short name uses SGR 1 and the long description uses SGR 3;37. The header on every layer is the identity token `**springboot3**(*VERSION*)`: bold name, italic version, no space between them. A bare `springboot3` on that header is not enough. The Exit row is plain `9. Exit`.

Off a TTY, and when `JSON=1`, any menu ink that does print is plain text with no CSI. `menu` off a TTY does not print a board; it dies as §2.1 says. `menu --json` on a TTY still draws the tree in plain text and does not emit a JSON menu catalog.

### 2.11 Menu layer

| This layer | Leave / back | Where you land |
|------------|--------------|----------------|
| Front board | **9**, `exit`, `quit`, empty line, EOF | Leave the program (return 0) |
| Setup, language, self-management | **0**, empty line, EOF | Front board |

A wrong pick stays on this layer (§2.8). Who may run a verb is not a menu layer. This product stays on **normal user privilege**. It does not add an approver and it does not add a dest fence. The class file already records that consider.

### 2.12 Implementation Notes (this project)

| Field | Value |
|-------|--------|
| Product | `springboot3` |
| VERSION named here | `1.0.0` (ship-unit Config). This requirement does not bump it. |
| Shebang | `#!/bin/bash` stays. Do not switch the ship unit to `/bin/sh` to match another product. |
| Claimed | yes |
| Live ship unit | Handlers below are in `./springboot3`. A TTY with no command draws the menu. A pipe stays combined ensure. |
| Handlers (required names) | `app_cmd_menu`, `app_cmd_menu_setup`, `app_cmd_menu_self`, `app_cmd_menu_language` |
| Printer (required name) | `out_menu_choice` |
| Choice read | Current-shell `read -r` |
| Actor / dest | Already considered on the class file: no dest approver, no approval subject, no dest fence. Do not add those files for this menu. |
| Guided input | No secret and no second field. One numbered `read`. |
| Proof | **have** — TP-MENU-01 through TP-MENU-05 in `reviews/test-plan.md` |

#### Worked sample (English front board)

The version token is the live `VERSION`. This fence shows `1.0.0`. Reserved numbers are not printed. The choose-prompt in the program ends with one space; this fence omits that space.

```text
[INFO] **springboot3**(*1.0.0*)
1. **Spring Boot 3.3.5**: *set up and run Spring Boot 3.3.5 on Java 21*
2. **Spring Boot 2.7.18**: *set up and run Spring Boot 2.7.18 on Java 8*
3. **Setup only**: *write the project and do not start it*
5. **language**: *display language for this menu*
8. **self-management**: *payload install, version, update, and remove this CLI*
9. Exit
Choose a number, or type the command name:
```

#### Invocation samples

```text
springboot3
springboot3 --debug
springboot3 menu
springboot3 main
```

On a TTY, each of those opens this tree. These do not:

```text
curl -fsSL https://raw.githubusercontent.com/cloudgen/springboot-cli/main/springboot3 | bash
springboot3 --json
springboot3 --quiet
springboot3 --springboot2
springboot3 --boot 2
springboot3 --no-run
springboot3 install
```

### 2.13 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): A pipe must not block on `read`. An unknown menu number must not kill the process.
- **CIAO Principle 2 – Intentional**: The matrix is written so a line switch and a bare terminal are different acts.
- **CIAO Principle 16 – Interactive vs non-interactive**: The terminal draws the board. Automation keeps the combined ensure.
- **CIAO Principle 21 – Dual policies**: The tree is filled for this product. Reusable molds stay free of these pins.

## Under command line for normal user only

When the program detects Termux, Git Bash, Windows Command Prompt, or the same class (this login only; no root switch):

| MUST | MUST NOT |
|------|----------|
| Draw the same front board, including row **5** | Add a sudoers row, wrap `sudo`, or recommend `sudo curl \| sh` |
| Keep payload leaves as this login’s SDKMAN setup | Wrap `apt`, `dnf`, or Termux `pkg` from a menu row |
| Git Bash and Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or cmd was detected |

**This requirement:** the numbered tree is a keyboard for the existing normal-user installer. It does not gain an admin path.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Fail closed off a TTY for `menu`. Retry a bad number on the same board.
- **Intentional:** Rows **1** and **2** are the two Boot lines already shipped. Row **82** is the version one-liner.
- **Anti-fragile:** Reserved numbers stay reserved so a later language or a refused `self-install` cannot silently renumber **81–86**.
- **Over-protect:** Do not collapse the matrix back into “every empty argv runs the demo” or into “every empty argv is only the menu.”

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Draw this menu on a pipe, under `--json` with no command, or under `--quiet` with no command.
2. Treat `--springboot2`, `--springboot3`, `--boot`, `--no-run`, `--reset`, `--force`, `--project-dir`, `--project-base`, `--base-path`, `--prefix`, or `--port` with no verb as “no command, so show the menu.”
3. Add `self-install`, a front **7** sudoers row, row **87**, Termux `pkg`, or an SSH config backup because a sibling product has them.
4. Make row **82** run `about`.
5. Number payload `uninstall`, or put `install` on the front board.
6. Capture `read` with `$()`.
7. `out_die` on an invalid menu choice.
8. Change the shebang to `/bin/sh` as part of this menu.
9. Mark TP-MENU-* have before a test asserts them.
10. Edit the sibling sshd-cli tree, or the springboot2 / springboot3 sibling trees, to satisfy this file.

## 5. Definition of done

1. This file and `requirement-shell-cli-language.md` are registered.
2. Peer law that used to say “interactive empty argv always runs the payload” points at §2.1.
3. `menu` and `main` are named here and in `requirement-shell-cli-interface.md`.
4. The ship unit draws the menu. The handlers are in `./springboot3`.
5. TP-MENU-01 through TP-MENU-05 are **have**. `tests/` asserts them.

### Design-time verification

| TP family / ID | Intent | Suite | Status |
|----------------|--------|-------|--------|
| **TP-MENU-01** | Interactive zero-command opens this menu and does not start the payload | `tests/test_cli.sh` | **have** |
| **TP-MENU-02** | A pipe with no command still runs Type O-P combined ensure and does not `read` | `tests/test_cli.sh` | **have** |
| **TP-MENU-03** | An invalid choice reprints that layer via `out_error` and does not `out_die` | `tests/test_cli.sh` | **have** |
| **TP-MENU-04** | `menu` with no TTY dies and does not `read` | `tests/test_cli.sh` | **have** |
| **TP-MENU-05** | `--springboot2` with no verb still runs line 2 on a TTY | `tests/test_domain.sh` | **have** |

## 6. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-language.md` | Thirteen languages and the language file |
| `docs/requirements/requirement-shell-cli-interface.md` | Dual mention of `menu` and `main` |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Non-interactive empty argv |
| `docs/requirements/requirement-shell-payload-online-install.md` | `install` is the payload |
| `docs/requirements/requirement-domain-springboot3.md` | Line pins and demo run |
| `docs/requirements/requirement-class-software-dev.md` | Residual pointer; no dest approver |
| `reviews/test-plan.md` | TP-MENU-* have rows |
| `./springboot3` | Ship unit. Menu handlers are in the file. |

## Terminologies

### Menu layer

**Definition:** A menu layer is one numbered list that owns the current `read` on a TTY. The main menu is a layer; each nested numbered submenu is another. An invalid choice reprints that layer. Exit leaves only this layer when it is the top layer. Empty input may leave this layer. EOF or a failed `read` leaves this layer without spinning. **0** returns to the parent. A bad token reprints this list and must not abort the process.

**Human daily-life explanation:** A menu layer is this chalkboard, not the whole café. A wrong pick reprints this board. Walking out with **0** returns you to the previous board.

**Daily-life example:** The front board is one layer. A side board you open after picking **3** is another layer. Saying **15** on that side board reprints the side board, not the front board.

### Well-known menu

**Definition:** A well-known menu is the portable numbered TTY membership shared by products that claim a numbered main menu: front **1**, **2**, **8**, and **9**, and self-management **81** through **87** under **8**. Those integers stay reserved. Which rows a product prints is that product’s choice. Domain rows belong on the full board map, not on this shared card. `help` is a word you type, not a numbered row.

**Human daily-life explanation:** A well-known menu is the shared café numbering. The front chalkboard has rooms **1**, **2**, and **8** when those rooms are claimed, plus **9** to leave. The back-office list under **8** keeps the same dish numbers.

**Daily-life example:** In this shop, **1** and **2** are the two Spring Boot lines, **8** is self-care, and **81** stocks the Spring Boot payload. **87** is reserved and is not on the board, because this shop does not file a separate “place the CLI only” dish.

### CLI default interaction

**Definition:** A CLI default interaction is the numbered TTY main menu a product runs when it claims one. Install, self-update, version, and about stay off the front board and may appear under **8**. `help` is not a numbered choice. `menu` and `main` open the tree and are not rows. An invalid choice reprints that layer with `out_error` and does not abort. After a valid leaf returns, the front board is shown again, except where this product’s law says the process was replaced.

**Human daily-life explanation:** A CLI default interaction is the numbered front counter you see when you walk up with no order. Off a real keyboard session it must not hang.

**Daily-life example:** You type the program name on a terminal and see numbered dishes plus Exit. You did not name a dish yet. The board is the default interaction. A pipe is not that walk-up.

### Do not capture `read`

**Definition:** Any function whose body contains `read` must be called in the current shell. Do not wrap that function in `$()` or backticks. `$()` remains allowed for pure-data helpers that never `read`. Sending the prompt to stderr, or reading the terminal inside the helper, does not license `$()`.

**Human daily-life explanation:** Ask the person in this room. Do not send the question into a sealed envelope and then wait for the envelope to talk.

**Daily-life example:** You ask “tea or coffee?” through a closed mailbox slot. Guests speak; you hear nothing. That is `$()` around `read`.

### Invalid-choice retry

**Definition:** An invalid choice at any menu layer stays on that layer: print `out_error`, reprint this layer’s list, and read again in the current shell. Do not terminate the process. Do not treat the pick as unknown argv. EOF or a failed `read` leaves this layer without spinning.

**Human daily-life explanation:** If you point at a number that is not on this board, the host does not throw you out. They say that number is not on the board, show the board again, and let you pick.

**Daily-life example:** The board lists **1**, **2**, and **5**, plus Exit **9**. You say **4**. The host says **4** is not on this board, rewrites the same board, and waits.

### Command-finished front board

**Definition:** After a valid leaf finishes on a nested numbered menu, show the front board again. Do not stay on the submenu that launched the command. **0**, an empty line, or EOF on a submenu still means Back. This is not the invalid-choice retry.

**Human daily-life explanation:** After you finish a dish from a side room, you walk back to the front chalkboard.

**Daily-life example:** You pick **8**, then **85**. When the update finishes, the host shows the front board again. A successful Boot start is the exception in this product: the Java process replaces this one, so there is no board to return to.

### Default CLI main menu style

**Definition:** The header prints a bold program name and an italic version with no space between them, wrapped as `**name**(*version*)`. Every command row is a number, a bold short description, and an italic long description. Off a TTY, and in JSON mode, the same row is plain text with no color codes.

**Human daily-life explanation:** The top line is the shop name and the edition. Each dish is a number, a bold name, and a slanted explanation.

**Daily-life example:** `**springboot3**(*1.0.0*)` then `1. **Spring Boot 3.3.5**: *set up and run Spring Boot 3.3.5 on Java 21*`.

### CLI main menu numbering

**Definition:** A command number is unique in the whole tree. A child number starts with its parent’s number. The front board uses small integers plus Exit **9**. Every submenu uses **0** to go back. A submenu must not start again at **1**.

**Human daily-life explanation:** Side-room dishes keep the front number as a prefix. **0** is the door back. **9** on the front board is leaving.

**Daily-life example:** Front **3** opens **31** and **32**, not another **1**.

## 7. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.1.0 | `--project-base`, `--base-path`, `--prefix`, and `--port` are domain payload flags. A TTY run that only sets a root or a port still takes the payload path. |
| 2026-10-07 | Active 1.0.0 | Dual-mode matrix and Boot-line menu. Confirmed: TTY menu plus pipe ensure; thirteen languages in the peer file; keep `install` as payload; no `self-install`, sudoers, Termux `pkg`, or SSH backup. Ship unit does not implement the menu yet. |

**Last Updated**: 2026-10-07
**Owner**: springboot3 project maintainers
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
