final: prev: {
  swayosd = prev.swayosd.overrideAttrs (oldAttrs: rec {
    
    src = prev.fetchFromGitHub {
      owner = "ErikReider";
      repo = "SwayOSD";
      rev = "c573f5ce94e2017d37b3dd3c2c1363bb1c6f82a3";
      hash = "sha256-cPom4dU+64TdCIi9D+GZN+EJltgXWy8fezEL1r9kUDo=";
    };
    
    cargoDeps = oldAttrs.cargoDeps.overrideAttrs (prev.lib.const {
      name = "swayosd-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-rSz7edA/G446eJGy5qYx9xOpMhsTpA9H43b45bLArHU=";
    });
  });
}

