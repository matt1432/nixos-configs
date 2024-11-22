self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) elem mkIf;

  cfg = config.programs.bash;
  trashPkg = self.packages.${pkgs.system}.trash-d;
  isCorrectPlatform = elem pkgs.system (trashPkg.meta.platforms or [pkgs.system]);
in {
  config = mkIf (cfg.enable && isCorrectPlatform) {
    home.packages = [trashPkg];

    programs.bash.shellAliases.rm = "trash";
  };

  # For accurate stack trace
  _file = ./default.nix;
}
