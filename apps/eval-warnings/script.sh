usage() {
    cat <<USAGE
Usage: eval-warnings [-a|--all-hosts] [-v|--verbose] [INSTALLABLE...]

Forces a fresh evaluation (no eval cache) of each INSTALLABLE's drvPath
and prints every warning / trace emitted during evaluation.

With no INSTALLABLE, evaluates the current host's NixOS toplevel.
A bare hostname is expanded to its nixosConfigurations toplevel.

  -a, --all-hosts  Evaluate every nixosConfigurations entry of \$FLAKE
  -v, --verbose    Print the full stderr instead of only warnings
USAGE
}

flake="${FLAKE:-.}"
all_hosts=false
verbose=false
targets=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -a | --all-hosts) all_hosts=true ;;
        -v | --verbose) verbose=true ;;
        -h | --help) usage; exit 0 ;;
        *) targets+=("$1") ;;
    esac
    shift
done

toplevel() {
    echo "$flake#nixosConfigurations.$1.config.system.build.toplevel"
}

if [[ "$all_hosts" == true ]]; then
    mapfile -t hosts < <(nix eval --json "$flake#nixosConfigurations" --apply builtins.attrNames | jq -r '.[]')
    for host in "${hosts[@]}"; do
        targets+=("$(toplevel "$host")")
    done
fi

if [[ ${#targets[@]} -eq 0 ]]; then
    targets+=("$(toplevel "$(hostname)")")
fi

# Keep warning/trace lines and their indented continuation lines
filter_warnings() {
    awk '
        /^(evaluation warning|warning|trace):/ { keep = 1; print; next }
        keep && /^[[:space:]]/ { print; next }
        { keep = 0 }
    '
}

total=0
failed=0

for target in "${targets[@]}"; do
    # Expand a bare hostname
    if [[ "$target" != *"#"* && "$target" != */* ]]; then
        target="$(toplevel "$target")"
    fi

    echo -e "\e[1;34m==> $target\e[0m" >&2

    stderr="$(mktemp)"
    if ! nix eval --no-eval-cache --raw "$target.drvPath" 2>"$stderr" >/dev/null; then
        failed=$((failed + 1))
        echo -e "\e[1;31mevaluation failed:\e[0m" >&2
        cat "$stderr" >&2
        rm -f "$stderr"
        continue
    fi

    if [[ "$verbose" == true ]]; then
        output="$(cat "$stderr")"
    else
        output="$(filter_warnings <"$stderr")"
    fi
    rm -f "$stderr"

    if [[ -n "$output" ]]; then
        count="$(grep -cE '^(evaluation warning|warning|trace):' <<<"$output" || true)"
        total=$((total + count))
        echo "$output"
    else
        echo -e "\e[32mno warnings\e[0m" >&2
    fi
done

echo -e "\n\e[1m$total warning(s), $failed failed evaluation(s)\e[0m" >&2
[[ "$failed" -eq 0 ]]
