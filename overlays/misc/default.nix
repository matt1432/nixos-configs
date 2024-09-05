final: prev: {
  ctranslate2 = prev.ctranslate2.override {
    withCUDA = true;
    withCuDNN = true;
  };
}
