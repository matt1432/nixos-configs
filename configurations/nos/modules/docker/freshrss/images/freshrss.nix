pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:d18055cc1c2fa807f118accb4ba74f435d381daf96130f87b17d9d9d1d169341";
  hash = "sha256-cYea9mHZhUFyEUNUBnvWnl265thohzlsAiz9aaXeMno=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
