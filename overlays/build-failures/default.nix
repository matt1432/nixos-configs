final: prev: {
  # FIXME: https://pr-tracker.nelim.org/?pr=357699
  nodejs_latest = prev.nodejs_22;

  # FIXME: https://pr-tracker.nelim.org/?pr=368790
  triton-llvm = prev.triton-llvm.override {
    buildTests = false;
  };
}
