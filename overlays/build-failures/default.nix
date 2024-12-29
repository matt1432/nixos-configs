final: prev: {
  # FIXME: https://pr-tracker.nelim.org/?pr=357699
  nodejs_latest = prev.nodejs_22;

  # FIXME: https://pr-tracker.nelim.org/?pr=368507
  hplip = prev.hplip.overrideAttrs (o: {
    env.NIX_CFLAGS_COMPILE = prev.lib.concatStringsSep " " [
      "-Wno-error=implicit-int"
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=return-mismatch"
      "-Wno-error=incompatible-pointer-types"
      "-Wno-error=int-conversion"
    ];
  });

  # FIXME: https://pr-tracker.nelim.org/?pr=368790
  triton-llvm = prev.triton-llvm.override {
    buildTests = false;
  };
}
