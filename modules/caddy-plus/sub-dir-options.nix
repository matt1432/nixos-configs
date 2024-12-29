{cfg}: {
  lib,
  name,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options = {
    subDirName = mkOption {
      type = types.str;
      default = name;
      description = "The sub directory name to handle.";
    };

    reverseProxy = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Option to give the parameters to a simple "reverse_proxy" command
        appended after extraConfig.
      '';
    };

    experimental = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Specify if the app being proxied expects to be under a subdirectory.
        If it doesn't, we can attempt to circumvent that but it is not guaranteed
        to work for every app.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional lines of configuration appended to this sub domain in the
        automatically generated `Caddyfile`.
      '';
    };
  };
}
