{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.roles.base;
in {
  config = mkIf cfg.enable {
    environment.variables.LANG = "en_CA.UTF-8";
  };
}
