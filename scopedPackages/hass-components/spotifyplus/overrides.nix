{
  smartinspect-src,
  spotifywebapi-src,
  ...
}: python3Packages: final: prev: rec {
  smartinspect = python3Packages.callPackage ./smartinspect.nix {
    inherit smartinspect-src;
  };
  spotifywebapi = python3Packages.callPackage ./spotifywebapi.nix {
    inherit smartinspect spotifywebapi-src;
  };
}
