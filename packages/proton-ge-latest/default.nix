{
  proton-ge-bin,
  rsync,
  ...
}:
proton-ge-bin.overrideAttrs {
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
}
