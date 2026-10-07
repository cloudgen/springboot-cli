# =============================================================================
# tests/test_domain.sh — Spring Boot domain surface (TP-DOM-*)
# =============================================================================
# Design-time: declare TP-DOM when specializing:
#   requirement-domain-springboot-cli
#   requirement-shell-payload-online-install (payload layer)
#   requirement-shell-cli-zero-arguments (empty argv domain ensure)
# Status map: docs/reviews/test-plan.md · matrix: docs/reviews/requirement-test-matrix.md
# =============================================================================

. "${TESTS_ROOT}/helpers.sh"

run_test_domain() {
    t_header "Domain surface"

    require_cmd sh
    require_cmd grep
    # Line defaults own the port and the folder parent unless a test sets them.
    unset PORT PROJECT_BASE PROJECT_PREFIX || true

    # --- help documents domain (already partially in CLI; reinforce pin + flags) ---
    _out=$(bash "${SCRIPT}" help 2>/dev/null)
    assert_contains "TP-DOM-02 help Spring Boot pin" "$_out" "${SPRINGBOOT_VER}"
    assert_contains "TP-DOM-01 help --no-run" "$_out" "--no-run"
    assert_contains "TP-DOM-01 help --project-dir" "$_out" "--project-dir"
    assert_contains "TP-DOM-01 help --reset" "$_out" "--reset"
    assert_contains "TP-DOM-01 help status" "$_out" "status"
    assert_contains "TP-DOM-01 help reinstall" "$_out" "reinstall"
    assert_contains "TP-DOM-01 help install" "$_out" "install"
    assert_contains "TP-DOM-01 help uninstall" "$_out" "uninstall"
    assert_contains "TP-DOM-01 help --springboot2" "$_out" "--springboot2"
    assert_contains "TP-DOM-01 help --springboot3" "$_out" "--springboot3"
    assert_contains "TP-DOM-10 help Boot 2 pin" "$_out" "2.7.18"
    assert_contains "TP-DOM-11 help --port" "$_out" "--port"
    assert_contains "TP-DOM-11 help --prefix" "$_out" "--prefix"
    assert_contains "TP-DOM-11 help --project-base" "$_out" "--project-base"
    assert_contains "TP-DOM-11 help --base-path" "$_out" "--base-path"

    # --- TP-DOM-12: Bash shebang, this-login SDKMAN tree, Java swap verbs ---
    _shebang=$(head -n 1 "${SCRIPT}")
    assert_eq "TP-DOM-12 shebang is /bin/bash" "#!/bin/bash" "${_shebang}"
    _ship=$(cat "${SCRIPT}")
    assert_contains "TP-DOM-12 SDKMAN dir is the login home" "${_ship}" '${HOME}/.sdkman'
    assert_contains "TP-DOM-12 sdkman-init under that tree" "${_ship}" '${HOME}/.sdkman/bin/sdkman-init.sh'
    assert_contains "TP-DOM-12 sdk use java" "${_ship}" 'sdk use java'
    assert_contains "TP-DOM-12 sdk default java" "${_ship}" 'sdk default java'
    assert_contains "TP-DOM-12 requires bash" "${_ship}" 'requires bash'

    _errf_early=$(mktemp)
    _ec=0
    bash "${SCRIPT}" --port >/dev/null 2>"${_errf_early}" || _ec=$?
    _err=$(cat "${_errf_early}" 2>/dev/null || true)
    assert_eq "TP-DOM-11 missing --port exit 1" 1 "$_ec"
    assert_contains "TP-DOM-11 missing --port text" "$_err" "--port requires"

    _ec=0
    bash "${SCRIPT}" --port 0 version >/dev/null 2>"${_errf_early}" || _ec=$?
    _err=$(cat "${_errf_early}" 2>/dev/null || true)
    assert_eq "TP-DOM-11 port 0 exit 1" 1 "$_ec"
    assert_contains "TP-DOM-11 port 0 text" "$_err" "TCP port"

    _ec=0
    bash "${SCRIPT}" --prefix '../x' version >/dev/null 2>"${_errf_early}" || _ec=$?
    _err=$(cat "${_errf_early}" 2>/dev/null || true)
    assert_eq "TP-DOM-11 bad prefix exit 1" 1 "$_ec"
    assert_contains "TP-DOM-11 bad prefix text" "$_err" "--prefix"
    rm -f "${_errf_early}"

    # --- ship install + payload under isolated HOME ---
    require_cmd curl
    require_cmd python3
    require_cmd sha256sum

    ci_isolated_env
    if ! ci_start_channel; then
        ci_cleanup_env
        return 1
    fi

    _sm_bin="${CI_USER_BIN}/${APP_NAME}"
    _errf="${CI_HOME}/dom-err.txt"
    _proj="${CI_HOME}/my-demo-project"

    ci_stub_domain_toolchain
    # Empty argv places the CLI only. Payload is the setup / install verb.
    HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" NO_RUN=1 \
        bash "${SCRIPT}" </dev/null >/dev/null 2>"${_errf}"
    _ec=$?
    assert_eq "TP-DOM-03 empty-argv ensure exit 0" 0 "$_ec"
    assert_file_exists "TP-DOM-03 binary installed" "${_sm_bin}"

    # help↔dispatcher: status (about alias) under isolation
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" status 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -eq 0 ]; then
        t_pass "TP-DOM-08 status routed"
    else
        t_fail "status advertised in help but dispatcher rejects it (help↔dispatcher Gap): '$(_trunc "$_err$_out")'"
    fi

    # explicit payload install command
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" install --project-dir "${_proj}" 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-DOM-04 payload install exit 0" 0 "$_ec"
    assert_file_exists "TP-DOM-04 payload install pom" "${_proj}/pom.xml"

    # reinstall: force CLI reinstall + domain; use --no-run to stay offline with stubs
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" reinstall --no-run --project-dir "${_proj}" 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -eq 0 ]; then
        t_pass "TP-DOM-08 reinstall routed"
    else
        t_fail "reinstall advertised in help but failed (help↔dispatcher Gap): '$(_trunc "$_err$_out")'"
    fi

    # domain --no-run with custom project dir
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --project-dir "${_proj}" --no-run 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-DOM-04 --no-run --project-dir exit 0" 0 "$_ec"
    assert_file_exists "TP-DOM-04 project dir created" "${_proj}"
    assert_file_exists "TP-DOM-04 pom generated" "${_proj}/pom.xml"
    assert_contains "TP-DOM-04 pom Spring Boot pin" "$(cat "${_proj}/pom.xml")" "${SPRINGBOOT_VER}"
    assert_file_exists "TP-DOM-04 main class" "${_proj}/src/main/java/com/example/HelloApplication.java"
    assert_file_exists "TP-DOM-04 application.properties" "${_proj}/src/main/resources/application.properties"
    if printf '%s' "${_out}${_err}" | grep -qE "setup completed|no-run|${_proj}"; then
        t_pass "TP-DOM-04 setup completion"
    else
        t_fail "domain --no-run missing success signals: '$(_trunc "${_out}${_err}")'"
    fi

    # --- preserve: second --no-run must not wipe custom marker ---
    printf 'KEEP-ME\n' > "${_proj}/USER_MARK.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --project-dir "${_proj}" --no-run 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-05 preserve exit 0" 0 "$_ec"
    assert_file_exists "TP-DOM-05 marker preserved" "${_proj}/USER_MARK.txt"
    _mark=$(cat "${_proj}/USER_MARK.txt" 2>/dev/null || true)
    assert_eq "TP-DOM-05 marker content" "KEEP-ME" "$_mark"

    # --- JSON --no-run ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --json --project-dir "${_proj}" --no-run 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-07 json --no-run exit 0" 0 "$_ec"
    assert_contains "TP-DOM-07 json type success" "$_out" '"type":"out_success"'
    assert_contains "TP-DOM-07 json no_run" "$_out" '"no_run":"true"'
    assert_contains "TP-DOM-07 json project_dir" "$_out" "project_dir"

    # --- --reset flag: advertised; if unwired, project may still preserve (Gap) ---
    # Do not require wipe; document whether --reset regenerates.
    printf 'KEEP-RESET\n' > "${_proj}/USER_MARK.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --reset --project-dir "${_proj}" --no-run 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ ! -e "${_proj}/USER_MARK.txt" ]; then
        t_pass "TP-DOM-06 --reset wiped marker"
    else
        t_fail "--reset advertised but did not reset project (help↔dispatcher / FORCE_REINSTALL Gap); mark still present"
    fi

    # --- TP-DOM-09: payload uninstall isolation (project only; CLI remains) ---
    _proj2="${CI_HOME}/dom-un-proj"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" install --project-dir "${_proj2}" 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-09 payload install for uninstall exit 0" 0 "$_ec"
    assert_file_exists "TP-DOM-09 project before uninstall" "${_proj2}/pom.xml"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --json uninstall --project-dir "${_proj2}" 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_nonzero "TP-DOM-09 uninstall without force non-zero" "$_ec"
    assert_file_exists "TP-DOM-09 project remains without force" "${_proj2}/pom.xml"
    assert_file_exists "TP-DOM-09 CLI remains on uninstall refuse" "${_sm_bin}"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --force uninstall --project-dir "${_proj2}" 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-09 uninstall --force exit 0" 0 "$_ec"
    assert_file_missing "TP-DOM-09 project removed by uninstall --force" "${_proj2}"
    assert_file_exists "TP-DOM-09 CLI remains after payload uninstall" "${_sm_bin}"

    # --- TP-DOM-10: line switch (Boot 2 vs Boot 3), separate folders ---
    _proj2line="${CI_HOME}/line2-explicit"
    _proj3line="${CI_HOME}/line3-explicit"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --springboot2 --no-run --project-dir "${_proj2line}" 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-10 --springboot2 --no-run exit 0" 0 "$_ec"
    assert_contains "TP-DOM-10 pom Boot 2 pin" "$(cat "${_proj2line}/pom.xml")" "2.7.18"
    assert_contains "TP-DOM-10 pom Java 8" "$(cat "${_proj2line}/pom.xml")" "<java.version>1.8</java.version>"
    assert_contains "TP-DOM-10 source Boot 2 greeting" "$(cat "${_proj2line}/src/main/java/com/example/HelloApplication.java")" "2.7.18"
    assert_contains "TP-DOM-10 artifact hello-springboot2" "$(cat "${_proj2line}/pom.xml")" "hello-springboot2"

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" install --springboot3 --project-dir "${_proj3line}" 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-10 install --springboot3 exit 0" 0 "$_ec"
    assert_contains "TP-DOM-10 pom Boot 3 pin" "$(cat "${_proj3line}/pom.xml")" "${SPRINGBOOT_VER}"
    assert_contains "TP-DOM-10 pom Java 21" "$(cat "${_proj3line}/pom.xml")" "<java.version>21</java.version>"
    assert_file_exists "TP-DOM-10 Boot 2 project kept" "${_proj2line}/pom.xml"

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --boot 2 --no-run 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-10 --boot 2 default dir exit 0" 0 "$_ec"
    assert_file_exists "TP-DOM-10 default Boot 2 dir" "${CI_HOME}/springboot-springboot2/pom.xml"
    assert_contains "TP-DOM-10 default Boot 2 pom" "$(cat "${CI_HOME}/springboot-springboot2/pom.xml")" "2.7.18"

    # Default line still uses the Boot 3 folder. A prior Boot 2 folder must remain.
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --no-run 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-10 default line --no-run exit 0" 0 "$_ec"
    assert_file_exists "TP-DOM-10 default Boot 3 dir" "${CI_HOME}/springboot-springboot-cli/pom.xml"
    assert_contains "TP-DOM-10 default Boot 3 pom" "$(cat "${CI_HOME}/springboot-springboot-cli/pom.xml")" "${SPRINGBOOT_VER}"
    assert_contains "TP-DOM-10 Boot 2 dir survives default run" "$(cat "${CI_HOME}/springboot-springboot2/pom.xml")" "2.7.18"

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --json --springboot2 about 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-10 about --springboot2 exit 0" 0 "$_ec"
    assert_contains "TP-DOM-10 about boot_line" "$_out" '"boot_line":"springboot2"'
    assert_contains "TP-DOM-10 about springboot_ver" "$_out" '"springboot_ver":"2.7.18"'
    assert_contains "TP-DOM-10 about java_id" "$_out" '"java_id":"8.0.472-amzn"'

    _err=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --boot 9 version 2>"${_errf}" >/dev/null
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-DOM-10 unknown line exit 1" 1 "$_ec"
    assert_contains "TP-DOM-10 unknown line text" "$_err" "Unknown Spring Boot line"

    # Default roots use different TCP ports so both lines can listen together.
    assert_contains "TP-DOM-11 default Boot 3 port" "$(cat "${CI_HOME}/springboot-springboot-cli/src/main/resources/application.properties")" "server.port=8080"
    assert_contains "TP-DOM-11 default Boot 2 port" "$(cat "${CI_HOME}/springboot-springboot2/src/main/resources/application.properties")" "server.port=8081"

    # Two extra roots under one base, two prefixes, two ports. Neither replaces the other.
    _base="${CI_HOME}/roots"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --project-base "${_base}" --prefix alpha --port 18080 --no-run 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-11 prefix alpha exit 0" 0 "$_ec"
    assert_file_exists "TP-DOM-11 alpha root" "${_base}/springboot-springboot-cli-alpha/pom.xml"
    assert_contains "TP-DOM-11 alpha port" "$(cat "${_base}/springboot-springboot-cli-alpha/src/main/resources/application.properties")" "server.port=18080"
    assert_contains "TP-DOM-11 alpha pin" "$(cat "${_base}/springboot-springboot-cli-alpha/pom.xml")" "${SPRINGBOOT_VER}"

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --base-path "${_base}" --prefix beta --port 18081 --springboot2 --no-run 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-11 prefix beta exit 0" 0 "$_ec"
    assert_file_exists "TP-DOM-11 beta root" "${_base}/springboot-springboot2-beta/pom.xml"
    assert_contains "TP-DOM-11 beta port" "$(cat "${_base}/springboot-springboot2-beta/src/main/resources/application.properties")" "server.port=18081"
    assert_contains "TP-DOM-11 beta pin" "$(cat "${_base}/springboot-springboot2-beta/pom.xml")" "2.7.18"
    assert_file_exists "TP-DOM-11 alpha kept beside beta" "${_base}/springboot-springboot-cli-alpha/pom.xml"

    # --project-dir is the exact root. Prefix must not create a second folder.
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --prefix shop --project-dir "${_proj}" --no-run 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-11 project-dir wins exit 0" 0 "$_ec"
    assert_file_exists "TP-DOM-11 explicit dir kept" "${_proj}/pom.xml"
    assert_file_missing "TP-DOM-11 prefix not applied over project-dir" "${CI_HOME}/springboot-springboot-cli-shop/pom.xml"

    # A later --port updates server.port and keeps a user marker.
    printf 'KEEP-PORT\n' > "${_base}/springboot-springboot-cli-alpha/USER_MARK.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --project-base "${_base}" --prefix alpha --port 18082 --no-run 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-11 retarget port exit 0" 0 "$_ec"
    assert_contains "TP-DOM-11 retarget port" "$(cat "${_base}/springboot-springboot-cli-alpha/src/main/resources/application.properties")" "server.port=18082"
    assert_eq "TP-DOM-11 retarget keeps marker" "KEEP-PORT" "$(cat "${_base}/springboot-springboot-cli-alpha/USER_MARK.txt")"

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_STUB_BIN}:${PATH}" \
        bash "${SCRIPT}" --json --project-base "${_base}" --prefix alpha about 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-DOM-11 about prefix exit 0" 0 "$_ec"
    assert_contains "TP-DOM-11 about prefix" "$_out" '"prefix":"alpha"'
    assert_contains "TP-DOM-11 about port" "$_out" '"port":"18082"'
    assert_contains "TP-DOM-11 about base" "$_out" '"project_base":'
    assert_contains "TP-DOM-11 about composed dir" "$_out" "springboot-springboot-cli-alpha"

    # --- TP-MENU-05: --springboot2 on a TTY still runs line 2, not the menu ---
    rm -rf "${CI_HOME}/springboot-springboot2"
    _errf="${CI_HOME}/menu-05-err.txt"
    _out=$(
        TTY=1 HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
            PATH="${CI_STUB_BIN}:${PATH}" \
            timeout 60 bash "${SCRIPT}" --springboot2 </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -eq 124 ]; then
        t_fail "TP-MENU-05 --springboot2 on a TTY hung"
    else
        t_pass "TP-MENU-05 --springboot2 on a TTY returned"
    fi
    assert_file_exists "TP-MENU-05 Boot 2 project written" "${CI_HOME}/springboot-springboot2/pom.xml"
    assert_contains "TP-MENU-05 Boot 2 pin" "$(cat "${CI_HOME}/springboot-springboot2/pom.xml")" "2.7.18"
    assert_not_contains "TP-MENU-05 not the menu" "${_out}${_err}" "Choose a number"

    # cleanup install
    rm -f "${_sm_bin}"
    ci_stop_channel
    ci_cleanup_env
}
