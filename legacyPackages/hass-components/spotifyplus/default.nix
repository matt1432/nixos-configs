{
  buildHassComponent,
  smartinspect-src,
  spotifywebapi-src,
  pkgs,
  ...
}: let
  python3Packages = pkgs.python3Packages.override {
    overrides = self: super: rec {
      smartinspect = pkgs.callPackage ./smartinspect.nix {
        inherit python3Packages smartinspect-src;
      };
      spotifywebapi = pkgs.callPackage ./spotifywebapi.nix {
        inherit python3Packages smartinspect spotifywebapi-src;
      };
    };
  };
in
  buildHassComponent ./spotifyplus.nix {inherit python3Packages;}
