{
  callPackage,
  gpu-screen-recorder-src,
  ...
}: let
  pname = "gsr-kms-server";
  gsr = callPackage ./generic.nix {inherit gpu-screen-recorder-src;};
in
  gsr.overrideAttrs (o: {
    inherit pname;

    postFixup = ''
      # This is needed to force gsr to lookup kms in PATH
      # to get the security wrapper
      rm $out/bin/gpu-screen-recorder
      rm $out/bin/.gpu-screen-recorder-wrapped
    '';

    meta = o.meta // {mainProgram = pname;};
  })
