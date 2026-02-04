set -eu

eval "$(env -i /usr/libexec/path_helper)"

is_tcc_permission_granted() {
    sqlite3 "$TCC_DATABASE" "
    SELECT 'granted' FROM access WHERE
        service = '$TCC_SERVICE' AND
        client = '$1' AND
        auth_value != 0
    " | grep -q granted
}

canonicalize_tcc_client() {
    info_path=$(realpath "$1/Contents/Info.plist" 2>/dev/null)
    if defaults read "$info_path" CFBundleIdentifier 2>/dev/null; then
        return 0
    elif [ -e "$1" ]; then
        printf %s "$1"
    else
        return 1
    fi
}

open_prefpane() {
    for _ in {1..5}; do
        killall "System Settings" 2>/dev/null || :
        if open "x-apple.systempreferences:com.apple.preference.security?$PREFPANE" 2>/dev/null; then
            return
        else
            sleep 1
        fi
    done
}

tmp_dir="$HOME/Desktop/.tcc-$RANDOM"
links_dir=$tmp_dir/$PREFPANE
mkdir -p "$links_dir"
trap 'rm -rf "$tmp_dir"' EXIT

tcc_clients=()
for tcc_client_path in "$@"; do
    if ! tcc_client=$(canonicalize_tcc_client "$tcc_client_path"); then
        printf '\e[33m%s\e[0m\n' "$tcc_client_path: could not find tcc client, skipping..." >&2
        continue
    fi

    tcc_clients+=("$tcc_client")
    ln -s "$tcc_client_path" "$links_dir"
done

for tcc_client in "${tcc_clients[@]}"; do
    if ! is_tcc_permission_granted "$tcc_client"; then
        open_prefpane
        open "$links_dir"
        while ! is_tcc_permission_granted "$tcc_client"; do
            sleep 1
        done
    fi
done
