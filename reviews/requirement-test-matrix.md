# Requirement ↔ test matrix — springboot3

**Updated:** 2026-10-07  
**Suite:** `./tests/run.sh`  
**Ship unit:** `src/springboot-cli` · **VERSION** 1.0.1 · default Spring Boot **3.3.5**, opt-in **2.7.18**

| Requirement key | Area | TP families | Coverage notes |
|-----------------|------|-------------|----------------|
| requirement-class-software-dev | class | TP-CLI-01 · suite residual | Class residual honesty; stack points to peers |
| requirement-domain-springboot3 | domain | TP-DOM-01..11 · TP-LC-01..02 · TP-CURL-02 | Default pin 3.3.5 / Java 21 / port 8080, opt-in 2.7.18 / Java 8 / port 8081, prefix and project-base roots, scaffold, preserve/reset, payload isolation |
| requirement-shell-cli-interface | shell | TP-CLI-01..09,11 · TP-DOM-01,08 | Commands, flags, unknown command/option, help, Environment |
| requirement-shell-cli-zero-arguments | shell | TP-LC-01 · TP-DOM-03 · TP-CURL-02..03 · TP-CLI-09 · TP-MENU-02 | Non-interactive Type O-P combined ensure. A pipe does not draw the menu |
| requirement-shell-cli-default-interaction | shell | TP-MENU-01..05 | Numbered TTY menu in the ship unit. **have** |
| requirement-shell-cli-language | shell | TP-LANG-01 | Thirteen codes and the language leaf. **have** |
| requirement-shell-payload-online-install | shell | TP-LC-01..03 · TP-DOM-04,09 · TP-CLI-03 · TP-CURL-* | Layer split; first pipe |
| requirement-shell-self-management | shell | TP-LC-04..09 · TP-CLI-11 | version-check, self-*, downgrade, bad channel |
| requirement-shell-automatic-checksum | shell | TP-CSUM-02..05 · TP-CLI-01 · TP-CURL-01 | Shape A + B; no help CHECKSUM |
| requirement-shell-output-requirements | shell | TP-CLI-02,04,06,07 · TP-DOM-07 | out_* types; quiet; JSON |
| requirement-shell-cli-storage | shell | TP-CLI-05 · TP-CLI-12 | Cache folder chain, persistence `${HOME}/.local/springboot3`, about fields, mode 0700 |
| requirement-shell-idempotency | shell | TP-LC-05 · TP-CURL-03 · TP-DOM-05 | re-run / second pipe / preserve |
| requirement-shell-interactive-vs-noninteractive | shell | TP-LC-03,07 · TP-CURL-* · TP-U-04 | confirm gates; pipe loudness |
| requirement-shell-modular-function-design | shell | TP-MOD-01 · TP-MOD-02 · TP-U-* | Prefix hygiene + no template authority |
| requirement-shell-script-coding | shell | TP-MOD-01 · TP-MOD-02 · TP-U-01..06 | Specialize-in coding; TTY consume; nounset |

**Absent by design (no Core TP):** Type 1 sudoers elev tables, a `self-install` verb, Termux `pkg`, SSH config backup, Spring Boot 4, real public SDKMAN install. Boot **2.7.18** is the opt-in line (TP-DOM-10), not a retarget of the default.
