#!/usr/bin/env bash
# =============================================================================
# curl.sh — xh-powered curl replacement (standalone, sourceable)
#
# Usage:
#   As executable:  ./curl.sh [curl-flags] <url>
#   As function:    source curl.sh && curl [curl-flags] <url>
#
# Backend priority: xh > python3 > wget > error
# =============================================================================

# ── Proxy (inherits from environment, fallback to corporate proxy) ────
: "${HTTP_PROXY:=http://ft.nube.local:5498/}"
: "${HTTPS_PROXY:=http://ft.nube.local:5498/}"
: "${http_proxy:=http://ft.nube.local:5498/}"
: "${https_proxy:=http://ft.nube.local:5498/}"
export HTTP_PROXY HTTPS_PROXY http_proxy https_proxy

# ── Helper: check if command exists ─────────────────────────────────────
_have() { command -v "$1" >/dev/null 2>&1; }

# ── Helper: find a working HTTP backend ─────────────────────────────────
_find_backend() {
    if _have xh; then
        echo "xh"
    elif _have python3; then
        echo "python3"
    elif _have wget; then
        echo "wget"
    else
        echo ""
    fi
}

# ── curl wrapper function (usable when this file is sourced) ────────────
curl() {
    local backend
    backend="$(_find_backend)"

    case "$backend" in
        xh)
            _curl_xh "$@"
            ;;
        python3)
            _curl_python "$@"
            ;;
        wget)
            _curl_wget "$@"
            ;;
        *)
            echo "curl.sh: no HTTP backend found (xh, python3, or wget required)" >&2
            echo "Install xh with: cargo install xh" >&2
            return 1
            ;;
    esac
}

# ── xh backend ──────────────────────────────────────────────────────────
_curl_xh() {
    local silent=false output_file="" xh_args=() url=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -s|--silent) silent=true; shift ;;
            -S|--show-error) shift ;;
            -f|--fail) shift ;;
            -L|--location) xh_args+=(--follow); shift ;;
            -v|--verbose) xh_args+=(--verbose); shift ;;
            -I|--head) xh_args+=(--headers); shift ;;
            -k|--insecure) xh_args+=(--verify no); shift ;;
            -o|--output) output_file="$2"; shift 2 ;;
            -H|--header) xh_args+=("$2"); shift 2 ;;
            -X|--request) shift 2 ;;  # xh auto-detects method
            -d|--data) xh_args+=(--body "$2"); shift 2 ;;
            -u|--user) xh_args+=(-a "$2"); shift 2 ;;
            --connect-timeout|--max-time) xh_args+=(--timeout "$2"); shift 2 ;;
            --proto*|--tlsv*|--sslv*) shift ;;  # xh is HTTPS-only
            -[a-zA-Z0-9][a-zA-Z0-9]*)
                # Unroll combined short flags
                local f="${1:1}"
                shift
                for (( i=${#f}-1; i>=0; i-- )); do
                    set -- "-${f:$i:1}" "$@"
                done
                ;;
            -*) shift ;;  # silently drop unknown flags
            *) url="$1"; shift ;;
        esac
    done

    [[ -z "$url" ]] && { echo "curl: no URL specified" >&2; return 2; }

    if $silent; then
        if [[ -n "$output_file" ]]; then
            xh --follow "${xh_args[@]}" "$url" > "$output_file" 2>/dev/null
        else
            xh --follow "${xh_args[@]}" "$url" 2>/dev/null
        fi
    else
        if [[ -n "$output_file" ]]; then
            xh --follow "${xh_args[@]}" "$url" > "$output_file"
        else
            xh --follow "${xh_args[@]}" "$url"
        fi
    fi
}

# ── python3 backend ─────────────────────────────────────────────────────
_curl_python() {
    python3 -c "
import sys, urllib.request
url = sys.argv[-1]
try:
    req = urllib.request.Request(url, headers={'User-Agent': 'curl.sh'})
    with urllib.request.urlopen(req) as r:
        sys.stdout.buffer.write(r.read())
except Exception as e:
    sys.stderr.write(f'curl.sh: {e}\n')
    sys.exit(1)
" "$@"
}

# ── wget backend ────────────────────────────────────────────────────────
_curl_wget() {
    local args=(-q) output_file=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -s|--silent) args+=(-q); shift ;;
            -L|--location) shift ;;  # wget follows by default
            -o|--output) output_file="$2"; shift 2 ;;
            -O|--remote-name) shift ;;  # wget default
            --connect-timeout) args+=(--timeout="$2"); shift 2 ;;
            --max-time) args+=(--timeout="$2"); shift 2 ;;
            -*) shift ;;
            *) break ;;
        esac
    done

    if [[ -n "$output_file" ]]; then
        wget "${args[@]}" -O "$output_file" "$@"
    else
        wget "${args[@]}" -O - "$@"
    fi
}

# ── If executed directly (not sourced), run curl ────────────────────────
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    curl "$@"
fi
