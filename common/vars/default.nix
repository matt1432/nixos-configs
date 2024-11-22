{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkOption types;
  cfg = config.vars;
in {
  options.vars = {
    mainUser = mkOption {
      type = types.str;
      description = ''
        Username that was defined at the initial setup process
      '';
    };
  };

  config = {
    environment.variables.FLAKE = mkDefault "/home/${cfg.mainUser}/.nix";
  };
}
