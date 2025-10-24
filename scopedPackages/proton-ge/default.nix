{
  lib,
  pkgs,
  ...
}:
lib.makeScope pkgs.newScope (ge: {
  latest = pkgs.proton-ge-bin.override {
    steamDisplayName = "GE-Proton-Latest";
  };

  v10-20 = (pkgs.proton-ge-bin.overrideAttrs (o: rec {
    version = "GE-Proton10-20";
    src = pkgs.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";

      hash = "sha256-sJkaDEnfAuEqcLDBtAfU6Rny3P3lOCnG1DusWfvv2Fg=";
    };
  })).override {
    steamDisplayName = "GE-Proton10-20";
  };
})
