final: prev: {
  swayosd = prev.swayosd.overrideAttrs (oldAttrs: rec {
    
    src = prev.fetchFromGitHub {
      owner = "ErikReider";
      repo = "SwayOSD";
      rev = "1add33d9ca7d9fa9be3cea39fd300e34ba3417c5";
      hash = "sha256-+shokerDcB12RjWhJVCtM38HUOFxW3CNTRxsWbUnVTs=";
    };
    
    cargoDeps = oldAttrs.cargoDeps.overrideAttrs (prev.lib.const {
      name = "swayosd-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-gRhhPDUFPcDS1xo7JzCpZtd1Al1kEkx2dXf92cc2bUo=";
      #outputHash = prev.lib.fakeHash;
    });

    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
      prev.systemd
    ];

    patches = [
      ./patches/swayosd.patch
    ];
  });
}

