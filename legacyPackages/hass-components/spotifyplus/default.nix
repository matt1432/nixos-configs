{
  self,
  buildHassComponent,
  smartinspect-src,
  spotifywebapi-src,
  pkgs,
  ...
}: let
  python3Packages = pkgs.python3Packages.override {
    overrides = _: super: rec {
      smartinspect = pkgs.callPackage ./smartinspect.nix {
        inherit python3Packages smartinspect-src;
      };
      spotifywebapi = pkgs.callPackage ./spotifywebapi.nix {
        inherit python3Packages smartinspect spotifywebapi-src;
      };
      urllib3 = self.packages.${pkgs.system}.urllib3.override {
        inherit python3Packages;
      };
    };
  };
in
  buildHassComponent ./spotifyplus.nix {inherit python3Packages;}
