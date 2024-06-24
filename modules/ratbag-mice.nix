{
  libratbag-src,
  pkgs,
  piper-src,
  ...
}: let
  inherit (import ../lib.nix {}) mkVersion;
in {
  services.ratbagd = {
    enable = true;

    package = pkgs.libratbag.overrideAttrs {
      pname = "libratbag";
      version = mkVersion libratbag-src;
      src = libratbag-src;
    };
  };

  environment.systemPackages = [
    (pkgs.piper.overrideAttrs {
      pname = "piper";
      version = mkVersion piper-src;
      src = piper-src;

      mesonFlags = [
        "-Druntime-dependency-checks=false"
      ];
    })
  ];
}
