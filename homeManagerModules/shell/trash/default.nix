{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) elem mkIf;

  cfg = config.programs.bash;
  trashPkg = pkgs.selfPackages.trash-d;
  isCorrectPlatform = elem pkgs.stdenv.hostPlatform.system (trashPkg.meta.platforms or [pkgs.stdenv.hostPlatform.system]);
in {
  config = mkIf (cfg.enable && isCorrectPlatform) {
    home.packages = [trashPkg];

    programs.bash.shellAliases.rm = "trash";
  };
}
