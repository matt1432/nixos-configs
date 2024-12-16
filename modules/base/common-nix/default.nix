self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues filter findFirst hasAttr isAttrs mkIf optionalString;

  inherit (self.inputs) nixd nixpkgs;
  inherit (config.sops.secrets) access-token;

  cfg = config.roles.base;
in {
  config = mkIf cfg.enable {
    nix = {
      # FIXME: infinite recursion if not set
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

      # Minimize dowloads of indirect nixpkgs flakes
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
