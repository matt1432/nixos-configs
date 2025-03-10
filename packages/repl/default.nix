{
  # nix build inputs
  writeShellApplication,
  # deps
  coreutils,
  gnused,
  ncurses,
  ...
}: let
  repl = ./repl.nix;

  example = command: desc: ''\n$(tput setaf 3) ${command}$(tput sgr0) - ${desc}'';
in
  writeShellApplication {
    name = "repl";

    runtimeInputs = [coreutils gnused ncurses];

    text = ''
      arg=''${1:-""}

      case "$arg" in
          "-h"|"--help"|"help")
              # shellcheck disable=SC2059
              printf "\n\e[4mUsage\e[0m: \
                  ${example "repl             " "Loads system flake present at $(tput setaf 4)\\$FLAKE$(tput sgr0)."} \
                  ${example "repl <flake path>" "Loads specified flake."}\n"
          ;;

          *)
              if [ -z "$arg" ]; then
                  nix repl \
                      --arg flakePath "$(realpath "$FLAKE")" \
                      --file ${repl}
              else
                  nix repl \
                      --arg flakePath "$(realpath "$arg" | sed 's|/flake.nix||')" \
                      --file ${repl}
              fi
          ;;
      esac
    '';

    meta = {
      homepage = "fork of https://github.com/fufexan/dotfiles/blob/main/pkgs/repl/default.nix";
      description = ''
        A wrapper of `nix repl` with the flake located at `$FLAKE` loaded in. It also attempts
        to load the current system's derivation for both `nixosConfigurations` and
        `nixOnDroidConfigurations`.
      '';
    };
  }
