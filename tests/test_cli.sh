# =============================================================================
# tests/test_cli.sh — Type 0 CLI surface (no network install required)
# =============================================================================
# Design-time: declare TP-CLI / TP-U / TP-CSUM-05 when specializing:
#   requirement-shell-cli-interface
#   requirement-shell-output-requirements
#   requirement-shell-cli-storage
#   requirement-shell-cli-zero-arguments (TP-CLI-09, TP-U)
#   requirement-shell-self-management (TP-CLI-11)
#   requirement-shell-automatic-checksum (TP-CSUM-05)
#   requirement-shell-interactive-vs-noninteractive
# Status map: reviews/test-plan.md · matrix: reviews/requirement-test-matrix.md
# Modular: TP-MOD-01/02 · requirement-shell-modular-function-design
# Coding: TP-U-06 · requirement-shell-script-coding · requirement-shell-interactive-vs-noninteractive
# =============================================================================

. "${TESTS_ROOT}/helpers.sh"

run_test_cli() {
    t_header "CLI surface"

    require_cmd sh
    require_cmd sha256sum
    require_cmd grep

    # --- syntax ---
    bash -n "${SCRIPT}"
    _syn=$?
    assert_eq "TP-CLI-01 bash -n syntax" 0 "$_syn"

    # --- companion digest (Shape A) ---
    if [ -f "${REPO_ROOT}/${APP_NAME}.sha256" ]; then
        _expected=$(awk '{print $1}' "${REPO_ROOT}/${APP_NAME}.sha256" | tr -d ' \n\r\t')
        _actual=$(sha256sum "${SCRIPT}" | awk '{print $1}')
        assert_eq "TP-CLI-01 sha256 matches ship unit" "$_expected" "$_actual"
    else
        t_fail "TP-CLI-01 sha256 missing"
    fi

    # --- version (human) ---
    _out=$(bash "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 version human version" "$_out" "${PRODUCT_VERSION}"
    assert_contains "TP-CLI-02 version human app" "$_out" "${APP_NAME}"

    # --- version (json) ---
    _out=$(bash "${SCRIPT}" --json version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 version --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 version --json type" "$_out" '"type":"version"'
    assert_contains "TP-CLI-02 version --json app" "$_out" "\"app\":\"${APP_NAME}\""
    assert_contains "TP-CLI-02 version --json version field" "$_out" "\"version\":\"${PRODUCT_VERSION}\""

    # --- help (human): Type 0 + domain surface ---
    _out=$(bash "${SCRIPT}" help 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-03 help exit 0" 0 "$_ec"
    assert_contains "TP-CLI-03 help lists version-check" "$_out" "version-check"
    assert_contains "TP-CLI-03 help lists self-update" "$_out" "self-update"
    assert_contains "TP-CLI-03 help lists self-uninstall" "$_out" "self-uninstall"
    assert_contains "TP-CLI-03 help lists self-upgrade" "$_out" "self-upgrade"
    assert_contains "TP-CLI-03 help lists payload install" "$_out" "install"
    assert_contains "TP-CLI-03 help lists payload uninstall" "$_out" "uninstall"
    assert_contains "TP-CLI-03 help lists about" "$_out" "about"
    assert_contains "TP-CLI-03 help lists --json" "$_out" "--json"
    assert_contains "TP-CLI-03 help lists --no-run" "$_out" "--no-run"
    assert_contains "TP-CLI-03 help lists --project-dir" "$_out" "--project-dir"
    assert_contains "TP-CLI-03 help lists --debug" "$_out" "--debug"
    assert_contains "TP-CLI-03 help lists --force-user" "$_out" "--force-user"
    assert_contains "TP-CLI-03 help lists --force-root" "$_out" "--force-root"
    assert_contains "TP-CLI-03 help lists SCRIPT_URL" "$_out" "SCRIPT_URL"
    assert_contains "TP-CLI-03 help lists REPO_USER" "$_out" "REPO_USER"
    assert_contains "TP-CLI-03 help Environment" "$_out" "Environment"
    assert_contains "TP-CLI-03 help Spring Boot pin" "$_out" "${SPRINGBOOT_VER}"
    assert_contains "TP-CLI-03 help lists --springboot2" "$_out" "--springboot2"
    assert_contains "TP-CLI-03 help lists --springboot3" "$_out" "--springboot3"
    assert_contains "TP-CLI-03 help lists --boot" "$_out" "--boot"
    assert_contains "TP-CLI-03 help lists BOOT_LINE" "$_out" "BOOT_LINE"
    assert_contains "TP-CLI-03 help lists Boot 2 pin" "$_out" "2.7.18"
    assert_contains "TP-CLI-03 help payload vs ship" "$_out" "Payload"
    assert_not_contains "TP-CSUM-05 help must not list CHECKSUM" "$_out" "CHECKSUM"

    # --- TP-CLI-08: unknown option fail-closed (not silently ignored) ---
    _err=$(bash "${SCRIPT}" --not-a-real-flag version 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-CLI-08 unknown option exit 1" 1 "$_ec"
    assert_contains "TP-CLI-08 unknown option text" "$_err" "Unknown option"

    # --- --debug is dispatched (version still succeeds; JSON stays clean) ---
    _out=$(bash "${SCRIPT}" --debug version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-03 --debug version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-03 --debug version text" "$_out" "${PRODUCT_VERSION}"
    _out=$(bash "${SCRIPT}" --json --debug version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-03 --json --debug version exit 0" 0 "$_ec"
    assert_not_contains "TP-CLI-03 --json --debug no [DEBUG] on stdout" "$_out" "[DEBUG]"

    # --- help (json): short object, not full prose ---
    _out=$(bash "${SCRIPT}" --json help 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-04 help --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-04 help --json type" "$_out" '"type":"out_success"'
    assert_contains "TP-CLI-04 help --json human mode" "$_out" "Help text"

    # --- about (json): no CHECKSUM field; storage resolve fields ---
    _out=$(bash "${SCRIPT}" --json about 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-04 about --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-04 about --json type" "$_out" '"type":"about"'
    assert_contains "TP-CLI-04 about --json app" "$_out" "\"app\":\"${APP_NAME}\""
    assert_not_contains "TP-CSUM-05 about no CHECKSUM" "$_out" "CHECKSUM"
    assert_contains "TP-CLI-05 about effective_storage" "$_out" '"effective_storage"'
    assert_contains "TP-CLI-05 about storage_dir" "$_out" '"storage_dir"'
    assert_contains "TP-CLI-05 about cache_used" "$_out" '"cache_used"'
    assert_contains "TP-CLI-05 about cache_preferred" "$_out" '"cache_preferred"'
    assert_contains "TP-CLI-05 about cache_fallback" "$_out" '"cache_fallback"'
    assert_contains "TP-CLI-05 about cache_fallback_2" "$_out" '"cache_fallback_2"'
    assert_contains "TP-CLI-05 about persistence_storage" "$_out" '"persistence_storage"'
    assert_contains "TP-CLI-05 about storage app name" "$_out" "${APP_NAME}"

    # --- per-process cache folder + persistence (STORAGE_DIR is not an override) ---
    ci_isolated_env
    _login=$(id -un 2>/dev/null || echo unknown)
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        bash "${SCRIPT}" --json about 2>/dev/null
    )
    _ec=$?
    assert_eq "TP-CLI-05 about isolated HOME" 0 "$_ec"
    assert_contains "TP-CLI-12 isolated about has app in cache" "$_out" "${APP_NAME}"
    _pref=$(printf '%s' "$_out" | sed -n 's/.*"cache_preferred":"\([^"]*\)".*/\1/p' | head -n1)
    _pid="${_pref##*-}"
    assert_eq "TP-CLI-12 cache_preferred is shm login process leaf" \
        "/dev/shm/cache/cache-${APP_NAME}-${_login}-${_pid}" "${_pref}"
    _fb=$(printf '%s' "$_out" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 cache_fallback 1st" "/tmp/cache/cache-${APP_NAME}-${_login}-${_pid}" "${_fb}"
    _fb2=$(printf '%s' "$_out" | sed -n 's/.*"cache_fallback_2":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 cache_fallback 2nd" "${CI_HOME}/.cache/cache-${APP_NAME}-${_pid}" "${_fb2}"
    _eff=$(printf '%s' "$_out" | sed -n 's/.*"effective_storage":"\([^"]*\)".*/\1/p' | head -n1)
    _used=$(printf '%s' "$_out" | sed -n 's/.*"cache_used":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 cache_used matches effective" "${_eff}" "${_used}"
    assert_eq "TP-CLI-05 storage_dir is 1st fallback" "${_fb}" \
        "$(printf '%s' "$_out" | sed -n 's/.*"storage_dir":"\([^"]*\)".*/\1/p' | head -n1)"
    if [ -n "${_eff}" ] && [ -d "${_eff}" ]; then
        t_pass "TP-CLI-12 effective cache directory exists"
    else
        t_fail "TP-CLI-12 effective cache missing: '${_eff:-empty}'"
    fi
    case "${_eff}" in
        "/dev/shm/${APP_NAME}"|"/dev/shm/${APP_NAME}-${_login}")
            t_fail "TP-CLI-12 effective cache must not be ram-drive project shape: '${_eff}'" ;;
        *) t_pass "TP-CLI-12 effective cache is not a ram-drive project shape" ;;
    esac
    case "${_eff}" in
        *"${_login}"*|*unknown*) t_pass "TP-CLI-05 effective_storage user segment" ;;
        *) t_fail "effective_storage missing user segment for '${_login}': $(_trunc "$_out")" ;;
    esac
    _custom="${CI_HOME}/custom-storage-root"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" STORAGE_DIR="${_custom}" \
        bash "${SCRIPT}" --json about 2>/dev/null
    )
    _ec=$?
    assert_eq "TP-CLI-05 STORAGE_DIR is not an override exit" 0 "$_ec"
    assert_not_contains "TP-CLI-05 storage_dir ignores STORAGE_DIR" "$_out" "custom-storage-root"
    _mode=$(stat -c '%a' "${_eff}" 2>/dev/null || stat -f '%OLp' "${_eff}" 2>/dev/null || echo "")
    assert_eq "TP-CLI-12 effective cache mode 0700" "700" "${_mode}"
    _hum_l=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        bash "${SCRIPT}" about 2>/dev/null
    )
    assert_contains "TP-CLI-12 linux about used" "${_hum_l}" "Cache folder used:"
    assert_contains "TP-CLI-12 linux about preferred path" "${_hum_l}" "/dev/shm/cache/cache-${APP_NAME}-${_login}-"
    assert_contains "TP-CLI-12 linux about 2nd path" "${_hum_l}" "/.cache/cache-${APP_NAME}-"
    assert_contains "TP-CLI-05 human Cache folder preferred" "${_hum_l}" "Cache folder (preferred):"
    assert_contains "TP-CLI-05 human Cache folder 1st fallback" "${_hum_l}" "Cache folder (1st fallback):"
    assert_contains "TP-CLI-05 human Cache folder 2nd fallback" "${_hum_l}" "Cache folder (2nd fallback):"
    assert_contains "TP-CLI-05 human Persistence storage" "${_hum_l}" "Persistence storage:"
    assert_not_contains "TP-CLI-05 no Storage (effective) label" "${_hum_l}" "Storage (effective)"
    assert_not_contains "TP-CLI-05 no Cache fall label" "${_hum_l}" "Cache fall."
    _errf="${CI_HOME}/cache-skip-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SPRINGBOOT3_CACHE_SKIP=preferred \
        bash "${SCRIPT}" --json about 2>"${_errf}"
    )
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_not_contains "TP-CLI-12 silent cache fallback" "${_err}" "fallback"
    assert_not_contains "TP-CLI-12 silent cache fallback error" "${_err}" "Cannot create cache"
    _skip_eff=$(printf '%s' "$_out" | sed -n 's/.*"effective_storage":"\([^"]*\)".*/\1/p' | head -n1)
    _skip_fb=$(printf '%s' "$_out" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 skipped preferred uses 1st fallback" "${_skip_fb}" "${_skip_eff}"
    _gb=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SPRINGBOOT3_CACHE_HOST=gitbash bash "${SCRIPT}" --json about 2>/dev/null)
    _gb_pref=$(printf '%s' "$_gb" | sed -n 's/.*"cache_preferred":"\([^"]*\)".*/\1/p' | head -n1)
    _gb_pid="${_gb_pref##*-}"
    assert_eq "TP-CLI-12 gitbash preferred" "/tmp/cache/cache-${APP_NAME}-${_login}-${_gb_pid}" "${_gb_pref}"
    _gb_fb=$(printf '%s' "$_gb" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 gitbash 1st fallback" "${CI_HOME}/AppData/Local/Temp/cache-${APP_NAME}-${_gb_pid}" "${_gb_fb}"
    _gb_fb2=$(printf '%s' "$_gb" | sed -n 's/.*"cache_fallback_2":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 gitbash no 2nd fallback" "" "${_gb_fb2}"
    _mac=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SPRINGBOOT3_CACHE_HOST=mac bash "${SCRIPT}" --json about 2>/dev/null)
    _mac_pref=$(printf '%s' "$_mac" | sed -n 's/.*"cache_preferred":"\([^"]*\)".*/\1/p' | head -n1)
    _mac_pid="${_mac_pref##*-}"
    assert_eq "TP-CLI-12 mac preferred" "/tmp/cache/cache-${APP_NAME}-${_login}-${_mac_pid}" "${_mac_pref}"
    _mac_fb=$(printf '%s' "$_mac" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 mac 1st fallback" "${CI_HOME}/Library/Caches/cache-${APP_NAME}-${_mac_pid}" "${_mac_fb}"
    _mac_fb2=$(printf '%s' "$_mac" | sed -n 's/.*"cache_fallback_2":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 mac 2nd fallback" "${CI_HOME}/cache/cache-${APP_NAME}-${_mac_pid}" "${_mac_fb2}"
    _hum_gb=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SPRINGBOOT3_CACHE_HOST=gitbash bash "${SCRIPT}" about 2>/dev/null)
    assert_contains "TP-CLI-12 gitbash about 1st" "${_hum_gb}" "AppData/Local/Temp/cache-${APP_NAME}-"
    assert_not_contains "TP-CLI-12 gitbash about omits 2nd" "${_hum_gb}" "Cache folder (2nd fallback)"
    _hum_mac=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SPRINGBOOT3_CACHE_HOST=mac bash "${SCRIPT}" about 2>/dev/null)
    assert_contains "TP-CLI-12 mac about 1st" "${_hum_mac}" "Library/Caches/cache-${APP_NAME}-"
    assert_contains "TP-CLI-12 mac about 2nd path" "${_hum_mac}" "Cache folder (2nd fallback): ${CI_HOME}/cache/cache-${APP_NAME}-"
    _persist=$(printf '%s' "$_gb" | sed -n 's/.*"persistence_storage":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 persistence_storage path" "${CI_HOME}/.local/${APP_NAME}" "${_persist}"
    if [ -d "${_persist}" ]; then
        t_pass "TP-CLI-12 persistence storage directory exists"
    else
        t_fail "TP-CLI-12 persistence storage missing: '${_persist:-empty}'"
    fi
    case "${_persist}" in
        */.local/bin|*/.local/bin/) t_fail "TP-CLI-12 persistence must not be USER_BIN: '${_persist}'" ;;
        *) t_pass "TP-CLI-12 persistence is not the install bin directory" ;;
    esac
    ci_cleanup_env

    # --- unknown command (out_die → exit 1; JSON type "out_error") ---
    _err=$(bash "${SCRIPT}" no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-CLI-06 unknown command exit 1" 1 "$_ec"
    assert_contains "TP-CLI-06 unknown command error text" "$_err" "Invalid command"

    # JSON errors go to stdout via out_json; capture both streams
    _err=$(bash "${SCRIPT}" --json no-such-command 2>&1)
    _ec=$?
    assert_eq "TP-CLI-06 unknown --json exit 1" 1 "$_ec"
    assert_contains "TP-CLI-06 unknown --json type error" "$_err" '"type":"out_error"'

    # --- quiet: version should not print info banners ---
    _out=$(bash "${SCRIPT}" --quiet version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-07 version --quiet exit 0" 0 "$_ec"
    if [ -z "$_out" ]; then
        t_pass "TP-CLI-07 quiet suppresses info"
    else
        _trim=$(printf '%s' "$_out" | tr -d ' \t\n\r')
        if [ -z "$_trim" ]; then
            t_pass "TP-CLI-07 quiet suppresses info"
        else
            t_fail "version --quiet expected empty stdout, got '$(_trunc "$_out")'"
        fi
    fi

    # --- HOME unset under set -u (INC-20260713-001 pattern) ---
    _out=$(env -u HOME bash "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "TP-U-01 env -u HOME version exit 0" 0 "$_ec"
    assert_contains "TP-U-01 env -u HOME reports version" "$_out" "${PRODUCT_VERSION}"

    # --- zero-arg auto-install propagates failure (not exit 0 on download fail) ---
    # Empty argv only (no --json flag — auto-install gate is $# -eq 0).
    ci_isolated_env
    _errf="${CI_HOME}/zero-arg-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        SCRIPT_URL="http://127.0.0.1:1/${APP_NAME}-unreachable" \
        bash "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -ne 0 ]; then
        t_pass "TP-CLI-09 zero-arg fail non-zero"
    else
        t_fail "zero-arg failed install expected non-zero exit, got 0 (stdout='$(_trunc "$_out")' err='$(_trunc "$_err")')"
    fi
    assert_file_missing "TP-CLI-09 zero-arg fail no binary" "${CI_USER_BIN}/${APP_NAME}"
    if [ -n "${_out}${_err}" ]; then
        t_pass "TP-CLI-09 zero-arg fail not silent"
    else
        t_fail "zero-arg failed install silent (no stdout/stderr) — INC-20260720-001"
    fi
    ci_cleanup_env

    # --- INC-20260720-001: bashrc that sources sdkman-init under set -u must not silent-abort ---
    ci_isolated_env
    mkdir -p "${CI_USER_BIN}" "${CI_HOME}/.sdkman/bin"
    cp "${SCRIPT}" "${CI_USER_BIN}/${APP_NAME}"
    chmod +x "${CI_USER_BIN}/${APP_NAME}"
    # Minimal sdkman-init that expands unbound vars when set -u is on (real SDKMAN does this)
    cat > "${CI_HOME}/.sdkman/bin/sdkman-init.sh" <<'EOF'
#!/usr/bin/env bash
if [ -z "$SDKMAN_CANDIDATES_API" ]; then
export SDKMAN_CANDIDATES_API="https://api.sdkman.io/2"
fi
sdk() { return 0; }
EOF
    cat > "${CI_HOME}/.bashrc" <<EOF
export SDKMAN_DIR="\${HOME}/.sdkman"
[ -s "\${HOME}/.sdkman/bin/sdkman-init.sh" ] && . "\${HOME}/.sdkman/bin/sdkman-init.sh"
EOF
    ci_stub_domain_toolchain
    _errf="${CI_HOME}/sdkman-bashrc-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" PATH="${CI_STUB_BIN}:${CI_USER_BIN}:${PATH}" \
        NO_RUN=1 \
        bash "${SCRIPT}" --no-run </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ -n "${_out}${_err}" ]; then
        t_pass "TP-U-03 bashrc+sdkman not silent"
    else
        t_fail "bashrc+sdkman silent abort (0 bytes out) — set -u source bug"
    fi
    # Must not die before any product messaging solely from sourcing bashrc
    if printf '%s' "${_out}${_err}" | grep -qE 'SDKMAN|Payload|setup|Spring|INFO|OK|ERROR|already'; then
        t_pass "TP-U-03 bashrc+sdkman product messages"
    else
        t_fail "bashrc+sdkman no product messages: '$(_trunc "${_out}${_err}")'"
    fi
    ci_cleanup_env

    # --- self-uninstall fail-closed (product law / INC-20260713-002) ---
    # Live Gap: --force does not set FORCE_REINSTALL; JSON cancel uses broken
    # out_json arg order. Assert law: refuse without force; binary remains.
    ci_isolated_env
    mkdir -p "${CI_USER_BIN}"
    cp "${SCRIPT}" "${CI_USER_BIN}/${APP_NAME}"
    chmod +x "${CI_USER_BIN}/${APP_NAME}"
    _errf="${CI_HOME}/un-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        bash "${SCRIPT}" --json self-uninstall 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    # Law: non-zero + confirm_required. Live may wrong-exit 0 with success cancel.
    if [ "$_ec" -ne 0 ]; then
        t_pass "TP-CLI-11 self-uninstall refuse non-zero"
    else
        t_fail "self-uninstall --json without --force expected non-zero (INC-002), got 0 out='$(_trunc "$_out$_err")'"
    fi
    assert_file_exists "TP-CLI-11 binary remains without force" "${CI_USER_BIN}/${APP_NAME}"
    # Must not claim success cancel as machine success with wrong schema only
    if printf '%s' "${_out}${_err}" | grep -q 'confirm_required'; then
        t_pass "TP-CLI-11 confirm_required"
    else
        t_fail "self-uninstall law expects confirm_required code (live Gap if missing): '$(_trunc "${_out}${_err}")'"
    fi
    ci_cleanup_env

    # --- TP-U-05: safe external source helper present (set -u Case C) ---
    if grep -q 'util_source_external_safe' "${SCRIPT}"; then
        t_pass "TP-U-05 util_source_external_safe present"
    else
        t_fail "TP-U-05 missing util_source_external_safe (set -u Case C)"
    fi

    # --- TP-CLI-02 about human (non-json) ---
    _out=$(bash "${SCRIPT}" about 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 about human exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 about human mentions app" "$_out" "${APP_NAME}"

    # --- TP-MOD-01: A-prefix modular families present (product law §3.1 option 1) ---
    for _fn in out_text out_success out_error out_die inst_perform_install inst_maybe_install \
        inst_is_installed app_main app_help app_about util_resolve_storage; do
        if grep -qE "^${_fn}\\(\\)|^${_fn} \\(\\)" "${SCRIPT}" 2>/dev/null \
            || grep -qE "^${_fn}\\(\\)" "${SCRIPT}"; then
            t_pass "TP-MOD-01 ${_fn} present"
        elif grep -q "${_fn}()" "${SCRIPT}"; then
            t_pass "TP-MOD-01 ${_fn} present"
        else
            t_fail "TP-MOD-01 missing modular helper: ${_fn}"
        fi
    done

    # --- TP-MOD-02: product source must not cite template-*/skill-* as behavioral authority ---
    # Allow educational "never cite template" lines in comments; forbid "see template-X as authority" style.
    if grep -nE 'requirement-(class|shell|domain)-' "${SCRIPT}" >/dev/null \
        && ! grep -nE 'as (behavioral )?authority.*template-|cite `?template-|authority: `?template-' "${SCRIPT}" >/dev/null; then
        # Fail if product code treats template/skill as the law path (not merely forbidding it)
        if grep -nE '^\s*#.*(see|per|from|follow)\s+`?(template|skill)-' "${SCRIPT}" >/dev/null; then
            t_fail "TP-MOD-02 product cites template/skill as law: $(grep -nE '^\s*#.*(see|per|from|follow)\s+`?(template|skill)-' "${SCRIPT}" | head -3)"
        else
            t_pass "TP-MOD-02 no template/skill authority cites in ship unit"
        fi
    else
        # Still pass if no bad authority pattern even without requirement cites
        if grep -nE '^\s*#.*(see|per|from|follow)\s+`?(template|skill)-' "${SCRIPT}" >/dev/null; then
            t_fail "TP-MOD-02 product cites template/skill as law"
        else
            t_pass "TP-MOD-02 no template/skill authority cites in ship unit"
        fi
    fi

    # --- TP-U-06: TTY measured outside functions; prompt_* consume TTY ---
    if grep -qE '^\[ -t 0 \] && \[ -t 1 \] && TTY=1' "${SCRIPT}"; then
        t_pass "TP-U-06 script-top TTY measure present"
    else
        t_fail "TP-U-06 missing script-top TTY=1 measure"
    fi
    _prompt_live=$(awk '
        /^prompt_(ask|yes_no)\(\)/ {infn=1}
        infn && /^}/ {infn=0}
        infn && /\[ -t [01] \]/ {print}
    ' "${SCRIPT}" || true)
    if [ -z "${_prompt_live}" ]; then
        t_pass "TP-U-06 prompt_* do not live-retest [ -t"
    else
        t_fail "TP-U-06 prompt_* still live-retest [ -t: ${_prompt_live}"
    fi
    if awk '/^prompt_yes_no\(\)/ {infn=1} infn && /^}/ {infn=0} infn && /TTY/ {found=1} END {exit found?0:1}' "${SCRIPT}"; then
        t_pass "TP-U-06 prompt_yes_no consumes TTY"
    else
        t_fail "TP-U-06 prompt_yes_no does not consume TTY"
    fi

    # --- TP-MENU-01: TTY with no command opens the menu and does not start the payload ---
    ci_isolated_env
    _errf="${CI_HOME}/menu-01-err.txt"
    _out=$(
        printf '9\n' | env -u SPRINGBOOT3_LANG TTY=1 HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
            bash "${SCRIPT}" 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-MENU-01 menu exit 0" 0 "$_ec"
    assert_contains "TP-MENU-01 header" "$_out" "**${APP_NAME}**(*${PRODUCT_VERSION}*)"
    assert_contains "TP-MENU-01 setup row" "$_out" "Setup only"
    assert_contains "TP-MENU-01 choose prompt" "$_out" "Choose a number, or type the command name:"
    assert_contains "TP-MENU-01 exit row" "$_out" "9. Exit"
    assert_not_contains "TP-MENU-01 does not start the payload" "$_out" "Starting Spring Boot"
    assert_file_missing "TP-MENU-01 no project directory" "${CI_HOME}/springboot-${APP_NAME}"
    ci_cleanup_env

    # --- TP-MENU-02: a pipe with no command does not draw the menu ---
    ci_isolated_env
    _errf="${CI_HOME}/menu-02-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
            SCRIPT_URL="http://127.0.0.1:1/${APP_NAME}-unreachable" \
            timeout 25 bash "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -eq 124 ]; then
        t_fail "TP-MENU-02 pipe hung"
    elif [ "$_ec" -ne 0 ]; then
        t_pass "TP-MENU-02 pipe ensure fails loud"
    else
        t_fail "TP-MENU-02 pipe expected non-zero, got 0"
    fi
    assert_not_contains "TP-MENU-02 pipe does not draw the menu" "${_out}${_err}" "Choose a number"
    assert_not_contains "TP-MENU-02 pipe is not the menu die" "${_out}${_err}" "menu requires a terminal"
    ci_cleanup_env

    # --- TP-MENU-03: invalid choice reprints the layer and does not die ---
    ci_isolated_env
    _errf="${CI_HOME}/menu-03-err.txt"
    _out=$(
        printf '4\n9\n' | env -u SPRINGBOOT3_LANG TTY=1 HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
            bash "${SCRIPT}" 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-MENU-03 invalid choice exit 0" 0 "$_ec"
    assert_contains "TP-MENU-03 names the token" "${_err}" "'4' is not on this board"
    _hits=$(printf '%s\n' "$_out" | grep -c 'Spring Boot 3.3.5' || true)
    if [ "${_hits}" -ge 2 ]; then
        t_pass "TP-MENU-03 reprints the front board"
    else
        t_fail "TP-MENU-03 expected the front board twice, saw ${_hits}"
    fi
    ci_cleanup_env

    # --- TP-MENU-04: menu with no TTY dies and does not read ---
    ci_isolated_env
    _errf="${CI_HOME}/menu-04-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
            timeout 5 bash "${SCRIPT}" menu </dev/null >"${CI_HOME}/menu-04-out.txt" 2>"${_errf}"
    )
    _ec=$?
    _out=$(cat "${CI_HOME}/menu-04-out.txt" 2>/dev/null || true)
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -eq 124 ]; then
        t_fail "TP-MENU-04 menu without a TTY hung on read"
    else
        assert_eq "TP-MENU-04 menu without a TTY exit 1" 1 "$_ec"
    fi
    assert_contains "TP-MENU-04 names menu" "${_err}" "menu requires a terminal"
    assert_not_contains "TP-MENU-04 does not draw" "${_out}${_err}" "Choose a number"
    ci_cleanup_env

    # --- TP-LANG-01: language leaf round-trip ---
    ci_isolated_env
    _leaf="${CI_HOME}/.local/${APP_NAME}/language"
    _out=$(
        printf '5\n0\n9\n' | env -u SPRINGBOOT3_LANG TTY=1 HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
            bash "${SCRIPT}" >/dev/null
    )
    assert_file_missing "TP-LANG-01 back does not write the language file" "${_leaf}"
    _out=$(
        printf '5\n59\n9\n' | env -u SPRINGBOOT3_LANG TTY=1 HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
            bash "${SCRIPT}" 2>/dev/null
    )
    _ec=$?
    assert_eq "TP-LANG-01 save de exit 0" 0 "$_ec"
    assert_file_exists "TP-LANG-01 language file exists" "${_leaf}"
    assert_eq "TP-LANG-01 language file is de" "de" "$(head -n 1 "${_leaf}" | tr -d '\r')"
    _mode=$(stat -c '%a' "${_leaf}" 2>/dev/null || stat -f '%OLp' "${_leaf}" 2>/dev/null || echo "")
    assert_eq "TP-LANG-01 language file mode 0600" "600" "${_mode}"
    _help=$(env -u SPRINGBOOT3_LANG HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" bash "${SCRIPT}" help 2>/dev/null)
    assert_contains "TP-LANG-01 German help heading" "${_help}" "Verwendung:"
    ci_cleanup_env
}
