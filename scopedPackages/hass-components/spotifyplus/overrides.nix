{
  self,
  smartinspect-src,
  spotifywebapi-src,
  pkgs,
  ...
}: python3Packages: final: prev: rec {
  smartinspect = pkgs.callPackage ./smartinspect.nix {
    inherit python3Packages smartinspect-src;
  };
  spotifywebapi = pkgs.callPackage ./spotifywebapi.nix {
    inherit python3Packages smartinspect spotifywebapi-src;
  };
  urllib3 = self.packages.${pkgs.system}.urllib3.override {
    inherit python3Packages;
  };
}
