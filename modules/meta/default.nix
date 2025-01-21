{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.meta = {
    roleDescription = mkOption {
      type = types.str;
      default = "";
    };

    hardwareDescription = mkOption {
      type = types.str;
      default = "";
    };
  };
}
