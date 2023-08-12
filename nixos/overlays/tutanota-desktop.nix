final: prev: {
  tutanota-desktop = prev.tutanota-desktop.overrideAttrs (oldAttrs: rec {
    
    pname = "tutanota-desktop";
    version = "3.116.8";

    src = prev.fetchurl {
      url = "https://github.com/tutao/tutanota/releases/download/tutanota-desktop-release-${version}/${pname}-${version}-unpacked-linux.tar.gz";
      name = "tutanota-desktop-${version}.tar.gz";
      sha256 = "sha256-HY0LdiHz8G/v8/zEglRtoDyPFMhMj1Zrc0zpQNJpWr0=";
    };

    patches = [];
  });
}

