{
  # nix build inputs
  lib,
  # deps
  proton-ge-bin,
  rsync,
  ...
}: let
  inherit (lib) elemAt match replaceStrings;
in
  proton-ge-bin.overrideAttrs (o: {
    version = replaceStrings ["-"] ["."] (elemAt (match "^[^0-9]*(.*)" o.version) 0);

    buildInputs = [rsync];

    buildCommand =
      # bash
      ''
        runHook preBuild

        echo "Proton should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

        cat $src/compatibilitytool.vdf > ./compatibilitytool.vdf
        sed -i 's/"GE-Proton[^"]*"/"GE-Proton-Latest"/g' ./compatibilitytool.vdf

        mkdir $steamcompattool
        cp -a ./compatibilitytool.vdf $steamcompattool/
        rsync -ar --exclude='compatibilitytool.vdf' $src/* $steamcompattool/

        runHook postBuild
      '';

    meta = o.meta // {
      description = ''
        ${o.meta.description}
        This derivation overrides the Proton version in Steam so that games using the Proton
        from nix keep using it after every version change.
      '';
    };
  })
