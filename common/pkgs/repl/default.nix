# modified from https://github.com/gytis-ivaskevicius/flake-utils/plus
{
  coreutils,
  gnused,
  writeShellScriptBin,
}: let
  repl = ./repl.nix;
  example = command: desc: ''\n\u001b[33m ${command}\u001b[0m - ${desc}'';
in
  writeShellScriptBin "repl" ''
    case "$1" in
      "-h"|"--help"|"help")
        printf "%b\n\e[4mUsage\e[0m: \
          ${example "repl" "Loads system flake if available."} \
          ${example "repl /path/to/flake.nix" "Loads specified flake."}\n"
      ;;
      *)
        if [ -z "$1" ]; then
          nix repl --arg flakePath $(${coreutils}/bin/readlink -f "/etc/nixos") --file ${repl}
        else
          nix repl --arg flakePath $(${coreutils}/bin/readlink -f $1 | ${gnused}/bin/sed 's|/flake.nix||') --file ${repl}
        fi
      ;;
    esac
  ''
