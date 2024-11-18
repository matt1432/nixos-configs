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

    promptMainColor = mkOption {
      type = types.enum (import ./prompt-schemes.nix {});
      default = "purple";
    };

    promptColors = mkOption {
      description = ''
        Colors used in starship prompt
      '';

      default = import ./prompt-schemes.nix {color = cfg.promptMainColor;};

      readOnly = true;
      type = types.submodule {
        options = let
          inherit (types) str;
        in {
          textColor = mkOption {type = str;};
          firstColor = mkOption {type = str;};
          secondColor = mkOption {type = str;};
          thirdColor = mkOption {type = str;};
          fourthColor = mkOption {type = str;};
        };
      };
    };

    neovimIde = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = {
    environment.variables.FLAKE = mkDefault "/home/${cfg.mainUser}/.nix";
  };
}
