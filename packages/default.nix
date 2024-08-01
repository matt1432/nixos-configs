{
  inputs,
  mkVersion,
  pkgs,
  ...
}: {
  coloryou = pkgs.callPackage ./coloryou {};

  gpu-screen-recorder = pkgs.callPackage ./gpu-screen-recorder {
    inherit (inputs) gpu-screen-recorder-src;
  };

  pam-fprint-grosshack = pkgs.callPackage ./pam-fprint-grosshack {
    inherit (inputs) pam-fprint-grosshack-src;
  };

  pokemon-colorscripts = pkgs.callPackage ./pokemon-colorscripts {
    inherit (inputs) pokemon-colorscripts-src;
    inherit mkVersion;
  };

  proton-ge-latest = pkgs.callPackage ./proton-ge-latest {};

  protonhax = pkgs.callPackage ./protonhax {
    inherit (inputs) protonhax-src;
    inherit mkVersion;
  };

  repl = pkgs.callPackage ./repl {};

  trash-d = pkgs.callPackage ./trash-d {
    inherit (inputs) trash-d-src;
  };

  yuzu = pkgs.callPackage ./yuzu {};
}
