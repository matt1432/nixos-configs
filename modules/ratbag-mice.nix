{
  libratbag-src,
  pkgs,
  piper-src,
  ...
}: {
  services.ratbagd = {
    enable = true;

    package = pkgs.libratbag.overrideAttrs {
      version = libratbag-src.shortRev;
      src = libratbag-src;
    };
  };

  environment.systemPackages = with pkgs; [
    (piper.overrideAttrs {
      name = "piper-${piper-src.shortRev}";
      src = piper-src;

      mesonFlags = [
        "-Druntime-dependency-checks=false"
      ];
    })
  ];
}
