{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.roles.desktop;
in {
  config = mkIf cfg.enable {
    programs.bash.shellAliases = {
      # https://wiki.hyprland.org/Contributing-and-Debugging/#lsp-and-formatting
      "mkCMakeFiles" = "${pkgs.cmake}/bin/cmake -S . -B build/ -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON";
    };

    home.packages = [
      (pkgs.writeShellApplication {
        name = "testChanges";
        runtimeInputs = [pkgs.cmake];
        text = ''
          chmod +w -fR /home/matt/git/"$1/''${2:-"."}"/{.cache,build}
          rm -r /home/matt/git/"$1/''${2:-"."}"/{.cache,build}
          cd /home/matt/.nix || return
          nix flake update "$1"
          nh os switch
          cd "/home/matt/git/$1/''${2:-"."}" || return
          nix develop "/home/matt/git/$1" -c cmake -S . -B build/ -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
        '';
      })
    ];
  };

  # For accurate stack trace
  _file = ./dev.nix;
}
