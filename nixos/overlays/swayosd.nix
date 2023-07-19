final: prev: {
  swayosd = prev.swayosd.overrideAttrs (oldAttrs: rec {
    
    src = prev.fetchFromGitHub {
      owner = "ErikReider";
      repo = "SwayOSD";
      rev = "b14c83889c7860c174276d05dec6554169a681d9";
      hash = "sha256-MJuTwEI599Y7q+0u0DMxRYaXsZfpksc2csgnK9Ghp/E=";
    };
    
    cargoDeps = oldAttrs.cargoDeps.overrideAttrs (prev.lib.const {
      name = "swayosd-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-gRhhPDUFPcDS1xo7JzCpZtd1Al1kEkx2dXf92cc2bUo=";
      #outputHash = prev.lib.fakeHash;
    });

    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
      prev.systemd
      prev.libevdev
      prev.libinput
    ];
  });
}

