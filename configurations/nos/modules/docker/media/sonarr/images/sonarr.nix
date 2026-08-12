pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:373159ba768e23a3a1c497d9f2b936addf8fd5b1fdce7dd6a14080ac928bfda0";
  hash = "sha256-vJutyTnLxgcZgqeBfyotW38QZY97TgDySp+KOjRNlzY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
