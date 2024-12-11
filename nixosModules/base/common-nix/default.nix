# FIXME: remove unneeded params and reformat
self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionalString;
  inherit (lib) attrValues filter findFirst isAttrs hasAttr mkDefault mkIf mkOption types;
  inherit (self.inputs) home-manager nh nixd;


  inherit (self.inputs) nixpkgs;
  inherit (config.sops.secrets) access-token;

  cfg = config.roles.base;
in {
  config = mkIf cfg.enable {
    # Minimize dowloads of indirect nixpkgs flakes
    nix = {
      package = let
        nixdInput =
          findFirst
          (x: x.pname == "nix") {}
          nixd.packages.x86_64-linux.nixd.buildInputs;

        throws = x: !(builtins.tryEval x).success;
        hasVersion = x: isAttrs x && hasAttr "version" x;

        nixVersions = filter (x: ! throws x && hasVersion x) (attrValues pkgs.nixVersions);
      in
        findFirst (x: x.version == nixdInput.version) {} nixVersions;

      registry.nixpkgs.flake = nixpkgs;
      nixPath = ["nixpkgs=${nixpkgs}"];

      extraOptions =
        optionalString (hasAttr "sops" config)
        "!include ${access-token.path}";
    };

    # Global hm settings
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };

  # For accurate stack trace
  _file = ./default.nix;
}
