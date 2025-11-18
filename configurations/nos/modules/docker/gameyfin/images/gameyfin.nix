pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:89a3ebc066c96767d958fac92f97fb3f899cd1231c7b1e666caacb2bc5167e39";
  hash = "sha256-s4RQ9Nd3HLhN+g1b1YMcKPycOmnrp1IMbByT24EKq3g=";
  finalImageName = imageName;
  finalImageTag = "2";
}
