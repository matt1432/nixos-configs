{
  pkgs,
  mkVersion,
  ...
} @ inputs: {
  coloryou = pkgs.callPackage ./coloryou {};

  curseforge-server-downloader = pkgs.callPackage ./curseforge-server-downloader {
    inherit (inputs) curseforge-server-downloader-src;
    inherit mkVersion;
  };

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

  repl = pkgs.callPackage ./repl {};

  trash-d = pkgs.callPackage ./trash-d {
    inherit (inputs) trash-d-src;
  };
}
