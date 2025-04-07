{
  smartinspect-src,
  spotifywebapi-src,
  pkgs,
  ...
}: python3Packages: final: prev: rec {
  smartinspect = python3Packages.callPackage ./smartinspect.nix {
    inherit smartinspect-src;
  };
  spotifywebapi = python3Packages.callPackage ./spotifywebapi.nix {
    inherit smartinspect spotifywebapi-src;
  };
  urllib3 = pkgs.selfPackages.urllib3.override {
    inherit python3Packages;
  };
}
