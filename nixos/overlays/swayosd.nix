final: prev: {
  swayosd = prev.swayosd.overrideAttrs (oldAttrs: rec {
    
    src = prev.fetchFromGitHub {
      owner = "ErikReider";
      repo = "SwayOSD";
      rev = "8159c9e9962ce19f6fb78201d4d34e5817f53b45";
      hash = "sha256-kGd4/eQkhvxEL3/LToBDjE/JIR8m6w9vdFUrRTyylCE=";
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

