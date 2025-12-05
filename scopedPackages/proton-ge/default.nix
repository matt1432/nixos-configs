{
  lib,
  pkgs,
  ...
}:
lib.makeScope pkgs.newScope (_: let
  mkProtonVersion = {
    versionSuffix ? "-Latest",
    hash ? null,
    desc ? null,
  }:
    (
      if (versionSuffix != "-Latest")
      then
        (
          pkgs.proton-ge-bin.overrideAttrs (o: rec {
            version = "GE-Proton${versionSuffix}";
            src = pkgs.fetchzip {
              url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
              inherit hash;
            };
            meta =
              o
              // {
                description = ''
                  ${o.meta.description} ${desc}
                '';
              };
          })
        )
      else pkgs.proton-ge-bin
    ).override {
      steamDisplayName = "GE-Proton${versionSuffix}";
    };
in {
  latest = mkProtonVersion {};

  v10-20 = mkProtonVersion {
    versionSuffix = "10-20";
    hash = "sha256-sJkaDEnfAuEqcLDBtAfU6Rny3P3lOCnG1DusWfvv2Fg=";
    desc = "This was the last working version for Marvel Rivals afaik.";
  };
})
