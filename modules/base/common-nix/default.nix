self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) nixd nixpkgs;
  inherit (self.lib) hasVersion throws;

  inherit (lib) attrValues filter findFirst hasAttr isDerivation mkIf optionalString;

  inherit (config.sops.secrets) access-token;

  cfg = config.roles.base;

  nixdInput =
    findFirst
    (x: x.pname == "nix-main") {}
    nixd.packages.x86_64-linux.nixd.buildInputs;

  nixVersions = filter (x: ! throws x && isDerivation x && hasVersion x) (attrValues pkgs.nixVersions);
in {
  config = mkIf cfg.enable {
    nix = {
      package = findFirst (x: x.version == nixdInput.version) {} nixVersions;

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
