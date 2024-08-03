{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;

  cfg = config.programs.adb;
in {
  options.programs.adb = {
    user = mkOption {
      type = types.str;
      default = "root";
      description = ''
        The name of the user who is going to interact with
        the android devices.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user}.extraGroups = ["adbusers"];
  };

  # For accurate stack trace
  _file = ./default.nix;
}
