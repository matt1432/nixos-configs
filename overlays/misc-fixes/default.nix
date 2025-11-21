final: prev: {
  wyoming-faster-whisper = prev.wyoming-faster-whisper.override {
    python3Packages =
      (final.python3.override {
        packageOverrides = pyFinal: pyPrev: {
          torch = pyFinal.torch-bin;
        };
      }).pkgs;
  };

  # FIXME: https://hydra.nixos.org/build/314026582/nixlog/1/tail
  starship =
    if final.stdenv.targetPlatform.system == "aarch64-linux"
    then
      (prev.starship.overrideAttrs (o: rec {
        version = "1.24.0";

        src = final.fetchFromGitHub {
          owner = "starship";
          repo = "starship";
          tag = "v${version}";
          hash = "sha256-kb7LHEhtVXzdoRPWMb4JA2REc/V5n21iX+ussWCaaPA=";
        };

        cargoDeps = final.rustPlatform.fetchCargoVendor {
          name = "${o.pname}-${version}-vendor.tar.gz";
          inherit src;
          hash = "sha256-xd3rYRJzJspmaQAsTw0lQifHdzB++BtJAjE12GsrLdE=";
        };
      }))
    else prev.starship;
}
