final: prev: {
  ctranslate2 = prev.ctranslate2.override {
    withCUDA = true;
    withCuDNN = true;
  };

  # FIXME: remove this if https://github.com/NixOS/nixpkgs/pull/342913 is merged
  spotifyd = prev.spotifyd.override {
    withMpris = false;
    withKeyring = false;
  };
}
