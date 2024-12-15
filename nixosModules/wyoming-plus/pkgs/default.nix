{pkgs, ...}: let
  python3Packages = pkgs.python311Packages;
in rec {
  speexdsp-ns = pkgs.callPackage ./speexdsp-ns.nix {
    inherit python3Packages;
  };

  tflite-runtime = pkgs.callPackage ./tflite-runtime.nix {
    inherit python3Packages;
  };

  openwakeword = pkgs.callPackage ./openwakeword.nix {
    inherit python3Packages speexdsp-ns tflite-runtime;
  };

  wyoming-openwakeword = pkgs.callPackage ./wyoming-openwakeword.nix {
    inherit openwakeword python3Packages;
  };
}
