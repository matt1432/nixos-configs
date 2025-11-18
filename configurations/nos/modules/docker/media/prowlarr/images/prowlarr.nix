pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:484784daaf4c081e55c608de256870184d283762e1b64e8105af487b1510fc4a";
  hash = "sha256-VsfJrazv7DVKniU2omUd+0C1ij1OHE4xEHULriWbnPI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
