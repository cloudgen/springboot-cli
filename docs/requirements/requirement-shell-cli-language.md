**file**: docs/requirements/requirement-shell-cli-language.md
**Status**: Active (Version 1.0.0)
**Area**: shell
**Key**: `requirement-shell-cli-language`
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the product law for **menu language** on springboot-cli: the thirteen codes, the file that remembers the choice, the words the numbered menu prints, and the human text of `help` and `about`.

The numbered tree, Back, and the current-shell `read` stay in `requirement-shell-cli-default-interaction.md`. The scratch directory that `util_resolve_storage` returns stays in `requirement-shell-cli-storage.md`. This file owns the codes, the `language` leaf, and the copy. The leaf is not inside that scratch directory.

The ship unit writes this file. The sentences below are the copy `src/springboot-cli` prints. TP-LANG-01 is have.

### 1.1 Human-facing

**In one sentence:** Menu **5** chooses English, 简体中文, 繁體中文, Español, العربية, Français, Português, Русский, Deutsch, 日本語, 한국어, Nederlands, or Ελληνικά for the numbered menu, for `help`, and for `about`, and the next run opens in that language.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Pick a language on the menu | `5`, then **52** |
| The other role | A script that must not wait | `springboot-cli install` |
| Not this file | What the demo prints, and the version one-liner | Those stay English |

| Includes | Excludes |
|----------|----------|
| Codes `en`, `zh-Hans`, `zh-Hant`, `es`, `ar`, `fr`, `pt`, `ru`, `de`, `ja`, `ko`, `nl`, `el`; rows **51–63**; menu copy; human `help` and human `about` | Translating command output, argv `version`, or JSON about fields |
| File `${HOME}/.local/${APP_NAME}/language` | Putting that file in the cache folder |

| Surface | What you open | What for |
|---------|---------------|----------|
| `springboot-cli` on a terminal | the menu | row **5** |
| `${HOME}/.local/springboot-cli/language` | one-line file, mode 0600 | the saved code |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Keep English | A missing file means English. You do not need to pick **51** first. | `springboot-cli` |
| Switch language | The front board comes back in that language. The next run still uses it. | `5`, then `59` |
| Go back | **0**, an empty line, or EOF does not write the file. | `0` |
| Read help | Headings and the sentence after each command follow the saved language. The command token stays Latin. | `springboot-cli help` |

## 2. Core Rules / Requirements (Mandatory)

**Claimed:** yes. Default language is English. The other twelve codes are the operator’s choice, stored for the next run.

### 2.1 Languages

| Code | Name on the language board | Number | Default |
|------|----------------------------|--------|---------|
| `en` | English | **51** | yes |
| `zh-Hans` | 简体中文 | **52** | no |
| `zh-Hant` | 繁體中文 | **53** | no |
| `es` | Español | **54** | no |
| `ar` | العربية | **55** | no |
| `fr` | Français | **56** | no |
| `pt` | Português | **57** | no |
| `ru` | Русский | **58** | no |
| `de` | Deutsch | **59** | no |
| `ja` | 日本語 | **60** | no |
| `ko` | 한국어 | **61** | no |
| `nl` | Nederlands | **62** | no |
| `el` | Ελληνικά | **63** | no |

**MUST** accept only these thirteen codes in this version. Numbers **50** and **64** through **69** are reserved and are not printed. A pick of one of those reserved numbers warns, reprints this board, and does not write the file. Front **6** is not a row. **MUST NOT** add a fourteenth code without a new revision of this file.

A missing file, an empty file, or a first line that is not one of these codes means English for this process. **MUST NOT** rewrite a file whose first line is not one of these codes.

The short names in the table above are the same words in every language. Each language’s own name stays in that language.

### 2.2 Where the choice is stored

1. The leaf is `${HOME}/.local/${APP_NAME}/language`. **MUST NOT** put it under the cache root from `util_resolve_storage`. **MUST NOT** put it in the demo `PROJECT_DIR`.
2. The file is one line: one of the thirteen codes, then a newline. Mode **0600**. A trailing CR is ignored. Only the first line is read.
3. `app_lang_load` sets `APP_LANG` once, at the start of `app_main`, after this leaf can be resolved and before the dual-mode split. Human `help`, human `about`, and the menu all see that value. **MUST NOT** call it again in that same process.
4. When `SPRINGBOOT3_LANG` is one of the thirteen codes, that value wins over the file at process start. It does not write the file. A menu pick still writes the file and sets `APP_LANG` for the rest of that process.
5. `app_lang_save` writes the line and sets `APP_LANG` only after the write succeeds. A code outside the thirteen returns failure and leaves `APP_LANG` unchanged.
6. Creating the parent directory `${HOME}/.local/${APP_NAME}` uses mode **0700** when this process creates it. The leaf stays **0600**.

### 2.3 Menu numbers and typed names

Front **5** opens `app_cmd_menu_language`. **51** through **63** save the codes in §2.1. Each is a valid leaf: an info line names the language, then the front board redisplays in that language. **0**, an empty line, or EOF is Back and does not write the file.

Typed `language`, `語言`, `语言`, `idioma`, `langue`, `Sprache`, `sprache`, `言語`, `언어`, `لغة`, `язык`, `taal`, and `γλώσσα` on the front board open it. `language` is not an argv verb.

The language board accepts:

| Row | Typed tokens |
|-----|----------------|
| **51** | `english`, `en`, `English` |
| **52** | `simplified-chinese`, `zh-hans`, `zh-Hans`, `简体中文` |
| **53** | `traditional-chinese`, `zh-hant`, `zh-Hant`, `繁體中文` |
| **54** | `spanish`, `es`, `Español`, `español` |
| **55** | `arabic`, `ar`, `العربية` |
| **56** | `french`, `fr`, `Français`, `français` |
| **57** | `portuguese`, `pt`, `Português`, `português`, `portugues` |
| **58** | `russian`, `ru`, `Русский`, `русский` |
| **59** | `german`, `de`, `Deutsch`, `deutsch` |
| **60** | `japanese`, `ja`, `日本語` |
| **61** | `korean`, `ko`, `한국어` |
| **62** | `dutch`, `nl`, `Nederlands`, `nederlands` |
| **63** | `greek`, `el`, `Ελληνικά`, `ελληνικά` |

The front board also accepts the displayed category short for rows **3**, **5**, and **8** in the language that is showing. Version tokens `Spring Boot 3.3.5` and `Spring Boot 2.7.18` stay those Latin tokens in every language. Leaf shorts on the self-management board stay the English verbs `install`, `version`, `about`, `version-check`, `self-update`, and `self-uninstall`.

### 2.4 What follows the saved language

**MUST** follow `APP_LANG` on the front board, the setup board, the language board, and the self-management board. That covers the layer title, the category shorts that translate, every long description, Back, Exit, the choose-prompt, the unknown-choice line, the saved-language line, and the failed-write line.

**MUST** follow `APP_LANG` on human `help` and human `about`: the heading, and the sentence after each command token. The command token, the flag, the path, and the environment name stay the Latin spelling (`install`, `--json`, `SCRIPT_URL`, `BOOT_LINE`, `--springboot2`).

**Stays English in this version:** argv `version` (the one-liner from row **82** and from the `version` verb), operational command output, the demo program’s own logs, JSON about keys, JSON about values, and `out_die` lines that are not the menu unknown-choice line.

`app_menu_text` prints the chosen string on stdout. Its body **MUST NOT** call `read`. The caller passes the string to `out_*`. The operator sees `out_*`.

### 2.5 Copy tables

Shorts that stay Latin in every language: `Spring Boot 3.3.5`, `Spring Boot 2.7.18`, `install`, `version`, `about`, `version-check`, `self-update`, `self-uninstall`.

#### Category shorts that change

| Code | Row 3 | Row 5 | Row 8 |
|------|-------|-------|-------|
| `en` | Setup only | language | self-management |
| `zh-Hans` | 仅安装 | 语言 | 自我管理 |
| `zh-Hant` | 僅安裝 | 語言 | 自我管理 |
| `es` | Solo configurar | idioma | autogestión |
| `ar` | إعداد فقط | لغة | إدارة ذاتية |
| `fr` | Configuration seule | langue | autogestion |
| `pt` | Só configurar | idioma | autogestão |
| `ru` | Только настройка | язык | самоуправление |
| `de` | Nur einrichten | Sprache | Selbstverwaltung |
| `ja` | セットアップのみ | 言語 | 自己管理 |
| `ko` | 설정만 | 언어 | 자기관리 |
| `nl` | Alleen inrichten | taal | zelfbeheer |
| `el` | Μόνο εγκατάσταση | γλώσσα | αυτοδιαχείριση |

#### Long descriptions

| Code | Row 1 | Row 2 |
|------|-------|-------|
| `en` | set up and run Spring Boot 3.3.5 on Java 21 | set up and run Spring Boot 2.7.18 on Java 8 |
| `zh-Hans` | 安装并运行 Java 21 上的 Spring Boot 3.3.5 | 安装并运行 Java 8 上的 Spring Boot 2.7.18 |
| `zh-Hant` | 安裝並執行 Java 21 上的 Spring Boot 3.3.5 | 安裝並執行 Java 8 上的 Spring Boot 2.7.18 |
| `es` | preparar y ejecutar Spring Boot 3.3.5 en Java 21 | preparar y ejecutar Spring Boot 2.7.18 en Java 8 |
| `ar` | إعداد وتشغيل Spring Boot 3.3.5 على Java 21 | إعداد وتشغيل Spring Boot 2.7.18 على Java 8 |
| `fr` | installer et lancer Spring Boot 3.3.5 sur Java 21 | installer et lancer Spring Boot 2.7.18 sur Java 8 |
| `pt` | preparar e executar Spring Boot 3.3.5 em Java 21 | preparar e executar Spring Boot 2.7.18 em Java 8 |
| `ru` | установить и запустить Spring Boot 3.3.5 на Java 21 | установить и запустить Spring Boot 2.7.18 на Java 8 |
| `de` | Spring Boot 3.3.5 auf Java 21 einrichten und starten | Spring Boot 2.7.18 auf Java 8 einrichten und starten |
| `ja` | Java 21 で Spring Boot 3.3.5 を用意して起動する | Java 8 で Spring Boot 2.7.18 を用意して起動する |
| `ko` | Java 21에서 Spring Boot 3.3.5를 준비하고 실행한다 | Java 8에서 Spring Boot 2.7.18를 준비하고 실행한다 |
| `nl` | Spring Boot 3.3.5 op Java 21 inrichten en starten | Spring Boot 2.7.18 op Java 8 inrichten en starten |
| `el` | εγκατάσταση και εκτέλεση του Spring Boot 3.3.5 σε Java 21 | εγκατάσταση και εκτέλεση του Spring Boot 2.7.18 σε Java 8 |

| Code | Row 3 | Row 5 | Row 8 |
|------|-------|-------|-------|
| `en` | write the project and do not start it | display language for this menu | payload install, version, update, and remove this CLI |
| `zh-Hans` | 写出项目，不要启动 | 此菜单的显示语言 | 安装 Spring Boot 载荷、查看版本、更新并移除本 CLI |
| `zh-Hant` | 寫出專案，不要啟動 | 此選單的顯示語言 | 安裝 Spring Boot 載荷、查看版本、更新並移除本 CLI |
| `es` | escribir el proyecto y no arrancarlo | idioma de este menú | instalar la carga Spring Boot, ver la versión, actualizar y quitar este CLI |
| `ar` | اكتب المشروع ولا تشغّله | لغة العرض لهذه القائمة | تثبيت حمولة Spring Boot وعرض الإصدار والتحديث وإزالة واجهة الأوامر |
| `fr` | écrire le projet sans le démarrer | langue d'affichage de ce menu | installer la charge Spring Boot, afficher la version, mettre à jour et retirer ce CLI |
| `pt` | escrever o projeto e não o iniciar | idioma deste menu | instalar a carga Spring Boot, ver a versão, atualizar e remover este CLI |
| `ru` | записать проект и не запускать его | язык этого меню | установить нагрузку Spring Boot, показать версию, обновить и удалить этот CLI |
| `de` | das Projekt schreiben und nicht starten | Anzeigesprache dieses Menüs | Spring-Boot-Nutzlast installieren, Version zeigen, aktualisieren und dieses CLI entfernen |
| `ja` | プロジェクトを書き、起動しない | このメニューの表示言語 | Spring Boot のペイロードを導入し、版を表示し、更新し、この CLI を削除する |
| `ko` | 프로젝트를 쓰고 시작하지 않는다 | 이 메뉴의 표시 언어 | Spring Boot 페이로드를 설치하고, 버전을 보고, 갱신하고, 이 CLI를 제거한다 |
| `nl` | het project schrijven en niet starten | weergavetaal van dit menu | Spring Boot-lading installeren, versie tonen, bijwerken en deze CLI verwijderen |
| `el` | γράψτε το έργο και μην το ξεκινήσετε | γλώσσα εμφάνισης αυτού του μενού | εγκατάσταση φορτίου Spring Boot, εμφάνιση έκδοσης, ενημέρωση και αφαίρεση αυτού του CLI |

| Code | Row 31 | Row 32 |
|------|--------|--------|
| `en` | write the Boot 3 project and do not start it | write the Boot 2 project and do not start it |
| `zh-Hans` | 写出 Boot 3 项目，不要启动 | 写出 Boot 2 项目，不要启动 |
| `zh-Hant` | 寫出 Boot 3 專案，不要啟動 | 寫出 Boot 2 專案，不要啟動 |
| `es` | escribir el proyecto Boot 3 y no arrancarlo | escribir el proyecto Boot 2 y no arrancarlo |
| `ar` | اكتب مشروع Boot 3 ولا تشغّله | اكتب مشروع Boot 2 ولا تشغّله |
| `fr` | écrire le projet Boot 3 sans le démarrer | écrire le projet Boot 2 sans le démarrer |
| `pt` | escrever o projeto Boot 3 e não o iniciar | escrever o projeto Boot 2 e não o iniciar |
| `ru` | записать проект Boot 3 и не запускать его | записать проект Boot 2 и не запускать его |
| `de` | das Boot-3-Projekt schreiben und nicht starten | das Boot-2-Projekt schreiben und nicht starten |
| `ja` | Boot 3 のプロジェクトを書き、起動しない | Boot 2 のプロジェクトを書き、起動しない |
| `ko` | Boot 3 프로젝트를 쓰고 시작하지 않는다 | Boot 2 프로젝트를 쓰고 시작하지 않는다 |
| `nl` | het Boot 3-project schrijven en niet starten | het Boot 2-project schrijven en niet starten |
| `el` | γράψτε το έργο Boot 3 και μην το ξεκινήσετε | γράψτε το έργο Boot 2 και μην το ξεκινήσετε |

| Code | 81 install | 82 version | 83 about |
|------|------------|------------|----------|
| `en` | install the Spring Boot payload (default Boot 3.3.5) | show the local CLI version | show diagnostics |
| `zh-Hans` | 安装 Spring Boot 载荷（默认 3.3.5） | 显示本机 CLI 版本 | 显示诊断信息 |
| `zh-Hant` | 安裝 Spring Boot 載荷（預設 3.3.5） | 顯示本機 CLI 版本 | 顯示診斷資訊 |
| `es` | instalar la carga Spring Boot (Boot 3.3.5 por defecto) | mostrar la versión local del CLI | mostrar el diagnóstico |
| `ar` | تثبيت حمولة Spring Boot (الافتراضي Boot 3.3.5) | عرض إصدار واجهة الأوامر المحلي | عرض التشخيص |
| `fr` | installer la charge Spring Boot (Boot 3.3.5 par défaut) | afficher la version locale du CLI | afficher le diagnostic |
| `pt` | instalar a carga Spring Boot (Boot 3.3.5 por omissão) | mostrar a versão local do CLI | mostrar o diagnóstico |
| `ru` | установить нагрузку Spring Boot (по умолчанию Boot 3.3.5) | показать локальную версию CLI | показать диагностику |
| `de` | Spring-Boot-Nutzlast installieren (Vorgabe Boot 3.3.5) | lokale CLI-Version anzeigen | Diagnose anzeigen |
| `ja` | Spring Boot のペイロードを導入する（既定は Boot 3.3.5） | ローカルの CLI 版を表示する | 診断を表示する |
| `ko` | Spring Boot 페이로드를 설치한다 (기본 Boot 3.3.5) | 로컬 CLI 버전을 표시한다 | 진단을 표시한다 |
| `nl` | Spring Boot-lading installeren (standaard Boot 3.3.5) | lokale CLI-versie tonen | diagnose tonen |
| `el` | εγκατάσταση φορτίου Spring Boot (προεπιλογή Boot 3.3.5) | εμφάνιση της τοπικής έκδοσης CLI | εμφάνιση διάγνωσης |

| Code | 84 version-check | 85 self-update | 86 self-uninstall |
|------|------------------|----------------|-------------------|
| `en` | compare local and remote CLI versions | update this CLI from the channel | remove this CLI |
| `zh-Hans` | 比较本地与远程 CLI 版本 | 从通道更新本 CLI | 移除本 CLI |
| `zh-Hant` | 比較本機與遠端 CLI 版本 | 從通道更新本 CLI | 移除本 CLI |
| `es` | comparar la versión local y la remota del CLI | actualizar este CLI desde el canal | quitar este CLI |
| `ar` | مقارنة إصدار واجهة الأوامر المحلي والبعيد | تحديث واجهة الأوامر من القناة | إزالة واجهة الأوامر |
| `fr` | comparer les versions locale et distante du CLI | mettre à jour ce CLI depuis le canal | retirer ce CLI |
| `pt` | comparar as versões local e remota do CLI | atualizar este CLI a partir do canal | remover este CLI |
| `ru` | сравнить локальную и удалённую версии CLI | обновить этот CLI из канала | удалить этот CLI |
| `de` | lokale und ferne CLI-Version vergleichen | dieses CLI aus dem Kanal aktualisieren | dieses CLI entfernen |
| `ja` | ローカルと遠隔の CLI 版を比べる | チャネルからこの CLI を更新する | この CLI を削除する |
| `ko` | 로컬과 원격 CLI 버전을 비교한다 | 채널에서 이 CLI를 갱신한다 | 이 CLI를 제거한다 |
| `nl` | lokale en externe CLI-versie vergelijken | deze CLI bijwerken vanaf het kanaal | deze CLI verwijderen |
| `el` | σύγκριση τοπικής και απομακρυσμένης έκδοσης CLI | ενημέρωση αυτού του CLI από το κανάλι | αφαίρεση αυτού του CLI |

Language-board long text, same pattern in every code: “use &lt;that language’s own name&gt; for this menu.”

| Code | Long for that row |
|------|-------------------|
| `en` | use English for this menu |
| `zh-Hans` | 此菜单使用简体中文 |
| `zh-Hant` | 此選單使用繁體中文 |
| `es` | usar español en este menú |
| `ar` | استخدم العربية لهذه القائمة |
| `fr` | utiliser le français pour ce menu |
| `pt` | usar português neste menu |
| `ru` | использовать русский для этого меню |
| `de` | Deutsch für dieses Menü verwenden |
| `ja` | このメニューを日本語にする |
| `ko` | 이 메뉴를 한국어로 표시한다 |
| `nl` | Nederlands voor dit menu gebruiken |
| `el` | χρήση ελληνικών για αυτό το μενού |

The short on each language row is the name column in §2.1, in every language.

#### Chrome

| Code | Back | Exit |
|------|------|------|
| `en` | 0. Back | 9. Exit |
| `zh-Hans` | 0. 返回 | 9. 离开 |
| `zh-Hant` | 0. 返回 | 9. 離開 |
| `es` | 0. Atrás | 9. Salir |
| `ar` | 0. رجوع | 9. خروج |
| `fr` | 0. Retour | 9. Quitter |
| `pt` | 0. Voltar | 9. Sair |
| `ru` | 0. Назад | 9. Выход |
| `de` | 0. Zurück | 9. Beenden |
| `ja` | 0. 戻る | 9. 終了 |
| `ko` | 0. 뒤로 | 9. 종료 |
| `nl` | 0. Terug | 9. Afsluiten |
| `el` | 0. Πίσω | 9. Έξοδος |

| Code | Choose-prompt |
|------|----------------|
| `en` | Choose a number, or type the command name: |
| `zh-Hans` | 选择编号，或输入命令名： |
| `zh-Hant` | 選擇編號，或輸入命令名稱： |
| `es` | Elija un número o escriba el nombre del comando: |
| `ar` | اختر رقماً أو اكتب اسم الأمر: |
| `fr` | Choisissez un numéro, ou saisissez le nom de la commande : |
| `pt` | Escolha um número ou escreva o nome do comando: |
| `ru` | Выберите номер или введите имя команды: |
| `de` | Wählen Sie eine Nummer oder geben Sie den Befehlsnamen ein: |
| `ja` | 番号を選ぶか、コマンド名を入力してください: |
| `ko` | 번호를 고르거나 명령 이름을 입력하세요: |
| `nl` | Kies een nummer of typ de opdrachtnaam: |
| `el` | Επιλέξτε έναν αριθμό ή πληκτρολογήστε το όνομα της εντολής: |

The unknown-choice line names the token the operator typed. English shape: `'TOKEN' is not on this board. Choose a listed number or command name.`

| Code | Unknown-choice line |
|------|---------------------|
| `en` | 'TOKEN' is not on this board. Choose a listed number or command name. |
| `zh-Hans` | “TOKEN”不在此板上。请选择列出的编号或命令名。 |
| `zh-Hant` | 「TOKEN」不在此板上。請選擇列出的編號或命令名稱。 |
| `es` | «TOKEN» no está en este tablero. Elija un número o un nombre de comando de la lista. |
| `ar` | «TOKEN» ليس على هذه اللوحة. اختر رقماً أو اسم أمر من القائمة. |
| `fr` | « TOKEN » n'est pas sur ce tableau. Choisissez un numéro ou un nom de commande de la liste. |
| `pt` | «TOKEN» não está neste quadro. Escolha um número ou um nome de comando da lista. |
| `ru` | «TOKEN» нет на этой доске. Выберите номер или имя команды из списка. |
| `de` | „TOKEN“ steht nicht auf dieser Tafel. Wählen Sie eine aufgeführte Nummer oder einen Befehlsnamen. |
| `ja` | 「TOKEN」はこの板にありません。一覧の番号かコマンド名を選んでください。 |
| `ko` | 'TOKEN'은 이 판에 없습니다. 나열된 번호나 명령 이름을 고르세요. |
| `nl` | 'TOKEN' staat niet op dit bord. Kies een vermeld nummer of een opdrachtnaam. |
| `el` | Το «TOKEN» δεν είναι σε αυτόν τον πίνακα. Επιλέξτε έναν αριθμό ή ένα όνομα εντολής από τη λίστα. |

| Code | Saved | Failed write |
|------|--------|----------------|
| `en` | Menu language is English | Could not save the menu language |
| `zh-Hans` | 菜单语言是简体中文 | 无法保存菜单语言 |
| `zh-Hant` | 選單語言是繁體中文 | 無法儲存選單語言 |
| `es` | El idioma del menú es español | No se pudo guardar el idioma del menú |
| `ar` | لغة القائمة هي العربية | تعذر حفظ لغة القائمة |
| `fr` | La langue du menu est le français | Impossible d'enregistrer la langue du menu |
| `pt` | O idioma do menu é português | Não foi possível guardar o idioma do menu |
| `ru` | Язык меню — русский | Не удалось сохранить язык меню |
| `de` | Die Menüsprache ist Deutsch | Die Menüsprache konnte nicht gespeichert werden |
| `ja` | メニューの言語は日本語 | メニューの言語を保存できませんでした |
| `ko` | 메뉴 언어는 한국어 | 메뉴 언어를 저장하지 못했습니다 |
| `nl` | De menutaal is Nederlands | De menutaal kon niet worden opgeslagen |
| `el` | Η γλώσσα του μενού είναι ελληνικά | Δεν ήταν δυνατή η αποθήκευση της γλώσσας του μενού |

A failed write uses the language that was current before the failed write, leaves `APP_LANG` unchanged, and still returns to the front board.

#### Human help and human about

| Code | Help heading | About heading | Cache-folder label |
|------|--------------|---------------|--------------------|
| `en` | Usage: | About / Diagnostics | Cache folder used: |
| `zh-Hans` | 用法： | 关于 / 诊断 | 使用中的缓存文件夹： |
| `zh-Hant` | 用法： | 關於 / 診斷 | 使用中的快取資料夾： |
| `es` | Uso: | Acerca de / diagnóstico | Carpeta de caché en uso: |
| `ar` | الاستخدام: | حول / تشخيص | مجلد التخزين المؤقت المستخدم: |
| `fr` | Utilisation : | À propos / diagnostic | Dossier de cache utilisé : |
| `pt` | Uso: | Acerca de / diagnóstico | Pasta de cache em uso: |
| `ru` | Использование: | О программе / диагностика | Используемая папка кэша: |
| `de` | Verwendung: | Über / Diagnose | Verwendeter Cache-Ordner: |
| `ja` | 使い方: | 概要 / 診断 | 使用中のキャッシュフォルダ: |
| `ko` | 사용법: | 개요 / 진단 | 사용 중인 캐시 폴더: |
| `nl` | Gebruik: | Over / diagnose | Gebruikte cachemap: |
| `el` | Χρήση: | Σχετικά / διάγνωση | Φάκελος cache σε χρήση: |

The sentence after each command token:

| Token | `en` | `zh-Hans` | `zh-Hant` |
|-------|------|-----------|-----------|
| `install` | Ensure SDKMAN, Java, Maven, and the demo project. Does not download the CLI. | 确保 SDKMAN、Java、Maven 和演示项目。不下载 CLI。 | 確保 SDKMAN、Java、Maven 和示範專案。不下載 CLI。 |
| `uninstall` | Remove the demo project directory. Does not remove the CLI. | 删除演示项目目录。不移除 CLI。 | 刪除示範專案目錄。不移除 CLI。 |
| `run` | Ensure the payload and start the demo. | 确保载荷并启动演示。 | 確保載荷並啟動示範。 |
| `reinstall` | Replace the CLI, then ensure the payload. | 替换 CLI，然后确保载荷。 | 替換 CLI，然後確保載荷。 |
| `version` | Print the local CLI version. | 打印本机 CLI 版本。 | 印出本機 CLI 版本。 |
| `about` | Print diagnostics. | 打印诊断信息。 | 印出診斷資訊。 |
| `status` | Same as about. | 与 about 相同。 | 與 about 相同。 |
| `version-check` | Compare the local CLI version with the channel. | 将本机 CLI 版本与通道比较。 | 將本機 CLI 版本與通道比較。 |
| `self-update` | Replace the CLI from the channel when a newer version exists. | 通道上有较新版本时替换 CLI。 | 通道上有較新版本時替換 CLI。 |
| `self-upgrade` | Same as self-update. | 与 self-update 相同。 | 與 self-update 相同。 |
| `self-uninstall` | Remove the CLI. Does not remove the demo project. | 移除 CLI。不删除演示项目。 | 移除 CLI。不刪除示範專案。 |
| `help` | Show this usage text. | 显示此用法文本。 | 顯示此用法文字。 |
| `menu` | Open the numbered menu on a terminal. | 在终端上打开编号菜单。 | 在終端上打開編號選單。 |
| `main` | Same as menu. | 与 menu 相同。 | 與 menu 相同。 |

| Token | `es` | `fr` | `pt` |
|-------|------|------|------|
| `install` | Asegura SDKMAN, Java, Maven y el proyecto de demostración. No descarga el CLI. | Prépare SDKMAN, Java, Maven et le projet de démo. Ne télécharge pas le CLI. | Garante SDKMAN, Java, Maven e o projeto de demonstração. Não transfere o CLI. |
| `uninstall` | Quita el directorio del proyecto de demostración. No quita el CLI. | Retire le répertoire du projet de démo. Ne retire pas le CLI. | Remove o diretório do projeto de demonstração. Não remove o CLI. |
| `run` | Asegura la carga y arranca la demostración. | Prépare la charge et lance la démo. | Garante a carga e inicia a demonstração. |
| `reinstall` | Sustituye el CLI y luego asegura la carga. | Remplace le CLI, puis prépare la charge. | Substitui o CLI e depois garante a carga. |
| `version` | Muestra la versión local del CLI. | Affiche la version locale du CLI. | Mostra a versão local do CLI. |
| `about` | Muestra el diagnóstico. | Affiche le diagnostic. | Mostra o diagnóstico. |
| `status` | Igual que about. | Identique à about. | Igual a about. |
| `version-check` | Compara la versión local del CLI con el canal. | Compare la version locale du CLI avec le canal. | Compara a versão local do CLI com o canal. |
| `self-update` | Sustituye el CLI desde el canal cuando hay una versión más nueva. | Remplace le CLI depuis le canal lorsqu'une version plus récente existe. | Substitui o CLI a partir do canal quando existe uma versão mais recente. |
| `self-upgrade` | Igual que self-update. | Identique à self-update. | Igual a self-update. |
| `self-uninstall` | Quita el CLI. No quita el proyecto de demostración. | Retire le CLI. Ne retire pas le projet de démo. | Remove o CLI. Não remove o projeto de demonstração. |
| `help` | Muestra este texto de uso. | Affiche ce texte d'utilisation. | Mostra este texto de uso. |
| `menu` | Abre el menú numerado en un terminal. | Ouvre le menu numéroté sur un terminal. | Abre o menu numerado num terminal. |
| `main` | Igual que menu. | Identique à menu. | Igual a menu. |

| Token | `de` | `nl` | `ru` |
|-------|------|------|------|
| `install` | SDKMAN, Java, Maven und das Demoprojekt sicherstellen. Lädt das CLI nicht herunter. | Zorg voor SDKMAN, Java, Maven en het demoproject. Downloadt de CLI niet. | Обеспечить SDKMAN, Java, Maven и демонстрационный проект. Не скачивает CLI. |
| `uninstall` | Das Demoprojektverzeichnis entfernen. Entfernt das CLI nicht. | Verwijdert de map van het demoproject. Verwijdert de CLI niet. | Удалить каталог демонстрационного проекта. Не удаляет CLI. |
| `run` | Die Nutzlast sicherstellen und die Demo starten. | Zorg voor de lading en start de demo. | Обеспечить нагрузку и запустить демонстрацию. |
| `reinstall` | Das CLI ersetzen und dann die Nutzlast sicherstellen. | Vervang de CLI en zorg daarna voor de lading. | Заменить CLI, затем обеспечить нагрузку. |
| `version` | Die lokale CLI-Version ausgeben. | Toont de lokale CLI-versie. | Показать локальную версию CLI. |
| `about` | Die Diagnose ausgeben. | Toont de diagnose. | Показать диагностику. |
| `status` | Gleich wie about. | Hetzelfde als about. | То же, что about. |
| `version-check` | Die lokale CLI-Version mit dem Kanal vergleichen. | Vergelijk de lokale CLI-versie met het kanaal. | Сравнить локальную версию CLI с каналом. |
| `self-update` | Das CLI aus dem Kanal ersetzen, wenn eine neuere Version existiert. | Vervang de CLI vanaf het kanaal wanneer een nieuwere versie bestaat. | Заменить CLI из канала, когда есть более новая версия. |
| `self-upgrade` | Gleich wie self-update. | Hetzelfde als self-update. | То же, что self-update. |
| `self-uninstall` | Das CLI entfernen. Entfernt das Demoprojekt nicht. | Verwijdert de CLI. Verwijdert het demoproject niet. | Удалить CLI. Не удаляет демонстрационный проект. |
| `help` | Diesen Verwendungstext anzeigen. | Toont deze gebruikstekst. | Показать этот текст использования. |
| `menu` | Das nummerierte Menü auf einem Terminal öffnen. | Open het genummerde menu op een terminal. | Открыть нумерованное меню на терминале. |
| `main` | Gleich wie menu. | Hetzelfde als menu. | То же, что menu. |

| Token | `ar` | `ja` | `ko` | `el` |
|-------|------|------|------|------|
| `install` | جهّز SDKMAN وJava وMaven ومشروع العرض. لا ينزّل واجهة الأوامر. | SDKMAN、Java、Maven、デモプロジェクトを整える。CLI はダウンロードしない。 | SDKMAN, Java, Maven, 데모 프로젝트를 갖춘다. CLI는 받지 않는다. | Εξασφαλίζει SDKMAN, Java, Maven και το έργο επίδειξης. Δεν κατεβάζει το CLI. |
| `uninstall` | أزل مجلد مشروع العرض. لا يزيل واجهة الأوامر. | デモプロジェクトのディレクトリを削除する。CLI は削除しない。 | 데모 프로젝트 디렉터리를 지운다. CLI는 지우지 않는다. | Αφαιρεί τον κατάλογο του έργου επίδειξης. Δεν αφαιρεί το CLI. |
| `run` | جهّز الحمولة وابدأ العرض. | ペイロードを整えてデモを起動する。 | 페이로드를 갖추고 데모를 시작한다. | Εξασφαλίζει το φορτίο και ξεκινά την επίδειξη. |
| `reinstall` | استبدل واجهة الأوامر ثم جهّز الحمولة. | CLI を置き換えてからペイロードを整える。 | CLI를 바꾼 다음 페이로드를 갖춘다. | Αντικαθιστά το CLI και έπειτα εξασφαλίζει το φορτίο. |
| `version` | اطبع إصدار واجهة الأوامر المحلي. | ローカルの CLI 版を表示する。 | 로컬 CLI 버전을 출력한다. | Εμφανίζει την τοπική έκδοση CLI. |
| `about` | اطبع التشخيص. | 診断を表示する。 | 진단을 출력한다. | Εμφανίζει τη διάγνωση. |
| `status` | مثل about. | about と同じ。 | about과 같다. | Ίδιο με το about. |
| `version-check` | قارن إصدار واجهة الأوامر المحلي بالقناة. | ローカルの CLI 版をチャネルと比べる。 | 로컬 CLI 버전을 채널과 비교한다. | Συγκρίνει την τοπική έκδοση CLI με το κανάλι. |
| `self-update` | استبدل واجهة الأوامر من القناة عندما توجد نسخة أحدث. | より新しい版があるときチャネルから CLI を置き換える。 | 더 새 버전이 있으면 채널에서 CLI를 바꾼다. | Αντικαθιστά το CLI από το κανάλι όταν υπάρχει νεότερη έκδοση. |
| `self-upgrade` | مثل self-update. | self-update と同じ。 | self-update와 같다. | Ίδιο με το self-update. |
| `self-uninstall` | أزل واجهة الأوامر. لا يزيل مشروع العرض. | CLI を削除する。デモプロジェクトは削除しない。 | CLI를 제거한다. 데모 프로젝트는 지우지 않는다. | Αφαιρεί το CLI. Δεν αφαιρεί το έργο επίδειξης. |
| `help` | أظهر نص الاستخدام هذا. | この使い方の文を表示する。 | 이 사용법을 보인다. | Εμφανίζει αυτό το κείμενο χρήσης. |
| `menu` | افتح القائمة المرقمة على طرفية. | 端末で番号付きメニューを開く。 | 터미널에서 번호 메뉴를 연다. | Ανοίγει το αριθμημένο μενού σε τερματικό. |
| `main` | مثل menu. | menu と同じ。 | menu와 같다. | Ίδιο με το menu. |

English `help` still prints `Usage:` and lists operational verbs apart from any test-purpose verb. This product has no test-purpose verb. The English menu sentence in `help` names front **5** and rows **51** through **63**.

### 2.6 Implementation Notes (this project)

| Field | Value |
|-------|--------|
| Product | `springboot-cli` |
| VERSION named here | `2.0.0`. This requirement's status stays 1.0.0. |
| Leaf | `${HOME}/.local/springboot-cli/language` |
| Override | `SPRINGBOOT3_LANG` |
| Runtime variable | `APP_LANG` |
| Default | `en` |
| Handlers | `app_lang_load`, `app_lang_save`, `app_menu_text`, `app_cmd_menu_language` in `src/springboot-cli` |
| Live ship unit | The language leaf and the thirteen-code copy are in `src/springboot-cli`. |
| Proof | **TP-LANG-01** **have** |

### 2.7 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): The thirteen codes and the sentences are written down, so a later edit does not invent a fourteenth language.
- **CIAO Principle 5 – Single source of output**: Menu words reach the operator through `out_*`.
- **CIAO Principle 22 – File modes**: The language leaf is **0600**.

## Under command line for normal user only

When the program detects Termux, Git Bash, Windows Command Prompt, or the same class:

| MUST | MUST NOT |
|------|----------|
| Keep row **5** and this leaf for this login | Store the language file in a root-owned directory |
| Write the leaf as this login, mode **0600** | Wrap `sudo` to save the language |
| Git Bash and Windows cmd: same file under that login’s home | Invoke Termux `pkg` to install a locale package |

**This requirement:** the language file is a normal-user preference. It is not an admin setting.

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** An unknown code does not rewrite the file. A reserved number does not write the file.
- **Intentional:** Leaf verbs stay Latin so the dispatcher and the board name the same token.
- **Anti-fragile:** A missing file is English, so an old home directory still gets a readable board.
- **Over-protect:** Do not put this leaf in the wipeable cache.

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Add a fourteenth language code without revising this file.
2. Print **50** or **64–69**.
3. Store the leaf under the cache root from `util_resolve_storage`.
4. Translate argv `version`, JSON about fields, or the demo’s own logs in this version.
5. Make row **82** print `about` in order to “translate diagnostics.”
6. Treat **0** on the language board as a save.
7. Mark TP-LANG-01 have before a test round-trips the file.

## 5. Definition of done

1. Registered beside `requirement-shell-cli-default-interaction.md`.
2. Storage law points here for the leaf and does not own the words.
3. The thirteen-code tables above are the copy. `src/springboot-cli` prints those sentences.

### Design-time verification

| TP family / ID | Intent | Suite | Status |
|----------------|--------|-------|--------|
| **TP-LANG-01** | Saving `de` writes `${HOME}/.local/springboot-cli/language` mode 0600, the next human help heading is `Verwendung:`, and **0** on the language board does not write the file | `tests/test_cli.sh` | **have** |

## 6. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-default-interaction.md` | Numbered tree and the matrix |
| `docs/requirements/requirement-shell-cli-interface.md` | `help` / `about` surface |
| `docs/requirements/requirement-shell-cli-storage.md` | Cache root; not this leaf |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_*` |
| `reviews/test-plan.md` | TP-LANG-01 have |
| `src/springboot-cli` | Ship unit. Language handlers are in the file. |

## Terminologies

### Menu layer

**Definition:** A menu layer is one numbered list that owns the current `read` on a TTY. The language board is one layer. An invalid choice reprints that layer. **0** returns to the parent. EOF leaves the layer without spinning.

**Human daily-life explanation:** The language board is its own chalkboard. A wrong number reprints that chalkboard. **0** walks back to the front board and does not save a language.

**Daily-life example:** You open **5**, type **64**, and see the same thirteen languages again. You type **0** and the front board returns in the language you already had.

### Well-known menu

**Definition:** A well-known menu reserves front **5**’s language block as a product extension of the shared card. The shared card itself is front **1 / 2 / 8 / 9** and self-management **81–87**. This product prints **51–63** under front **5** and does not print **87**.

**Human daily-life explanation:** The shared café numbers stay. The language room is an extra room this shop added, with its own numbers **51** through **63**.

**Daily-life example:** **5** opens the language room. **59** saves German. **87** is not a dish in this shop.

### Menu language

**Definition:** Menu language is the saved code that chooses the words on the numbered boards and on human `help` and human `about`. The code is one of thirteen. The file is one line under the login’s `.local` directory for this program, mode **0600**. Command tokens stay Latin. JSON fields stay English.

**Human daily-life explanation:** Menu language is the language of the chalkboard and of the printed usage card. The dishes keep their Latin names. The explanation beside each name changes.

**Daily-life example:** You pick **60**. The next time you open the program, the board and `help` are in Japanese. `springboot-cli version` still prints the version line in the program’s usual English form.

## 7. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-07 | Active 1.0.0 | Thirteen codes **51–63**, language leaf, and copy tables. Ship unit does not implement them yet. |

**Last Updated**: 2026-10-07
**Owner**: springboot-cli project maintainers
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
