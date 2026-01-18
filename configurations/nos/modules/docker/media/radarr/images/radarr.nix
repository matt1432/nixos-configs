pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:270f25698624b57b86ca119cc95399d7ff15be8297095b4e1223fd5b549b732c";
  hash = "sha256-FrsFZsHpjFbh0rvnRlM4RzvsKk3qwzv48GESqarnXOw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
