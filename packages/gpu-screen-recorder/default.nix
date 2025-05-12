{
  callPackage,
  gpu-screen-recorder-src,
  ...
}: let
  gpu-screen-recorder = callPackage ./gpu-screen-recorder.nix {
    inherit gpu-screen-recorder-src;
  };

  gsr-kms-server = callPackage ./gsr-kms-server.nix {
    inherit gpu-screen-recorder-src;
  };

  gsr-dbus-server = callPackage ./gsr-dbus-server.nix {
    inherit gpu-screen-recorder-src;
  };
in
  gpu-screen-recorder.overrideAttrs (o: {
    passthru =
      o.passthru or {}
      // {
        inherit gsr-kms-server gsr-dbus-server;
      };
  })
