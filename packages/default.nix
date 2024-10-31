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

  libratbag = pkgs.callPackage ./libratbag {
    inherit (inputs) libratbag-src;
  };

  librespot-auth = pkgs.callPackage ./librespot-auth {};

  pam-fprint-grosshack = pkgs.callPackage ./pam-fprint-grosshack {
    inherit (inputs) pam-fprint-grosshack-src;
  };

  piper = pkgs.callPackage ./piper {
    inherit (inputs) piper-src;
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

  some-sass-language-server = pkgs.callPackage ./some-sass-language-server {};

  trash-d = pkgs.callPackage ./trash-d {
    inherit (inputs) trash-d-src;
  };

  urllib3 = pkgs.callPackage ./urllib3 {};
}
