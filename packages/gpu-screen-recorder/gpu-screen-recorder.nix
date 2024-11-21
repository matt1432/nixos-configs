{
  callPackage,
  gpu-screen-recorder-src,
  ...
}: let
  gsr = callPackage ./generic.nix {inherit gpu-screen-recorder-src;};
in
  gsr.overrideAttrs (o: {
    postFixup = ''
      # This is needed to force gsr to lookup kms in PATH
      # to get the security wrapper
      rm $out/bin/gsr-kms-server
    '';

    meta = o.meta // {mainProgram = o.pname;};
  })
