{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (pkgs.writers) writeJSON;

  cfg = osConfig.roles.desktop;

  clangdConf = writeJSON "clangd-hypr-conf" {
    CompileFlags.Add = ["-D__cpp_concepts=202002L"];
  };
in {
  # https://wiki.hyprland.org/Contributing-and-Debugging/#lsp-and-formatting
  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "setupDev";

        runtimeInputs = [
          pkgs.cmake
          osConfig.programs.direnv.nix-direnv.package
          osConfig.programs.git.package
        ];

        text = ''
          if [[ $# -gt 0 ]]; then
              project="$1"
              subproject="''${2:-"."}"

              cd "$HOME/git/$project/$subproject" || return
          fi

          chmod +w -fR ./{.cache,build} || true
          git clean -xdf

          if [ -e .envrc ] || [ -e ../.envrc ]; then
              if [[ $# -gt 0 ]]; then
                  nix develop -c echo "load shellHook"
              else
                  direnv reload
              fi
          fi

          if [ -e CMakeLists.txt ] || [ -e ../CMakeLists.txt ]; then
              nix develop -c cmake -S . -B build/ -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
          fi

          cat ${clangdConf} > .clangd
        '';
      })

      (pkgs.writeShellApplication {
        name = "testChanges";

        runtimeInputs = [
          pkgs.cmake
          osConfig.programs.direnv.nix-direnv.package
          osConfig.programs.git.package
        ];

        text = ''
          project="$1"
          subproject="''${2:-"."}"

          cd "$HOME/git/$project/$subproject" || return

          chmod +w -fR ./{.cache,build} || true
          git clean -xdf

          cd "$FLAKE" || return
          nix flake update "$1"
          nh os switch

          setupDev "$project" "$subproject"
        '';
      })
    ];
  };

  # For accurate stack trace
  _file = ./dev.nix;
}
