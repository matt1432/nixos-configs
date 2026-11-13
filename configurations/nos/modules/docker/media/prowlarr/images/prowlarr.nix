pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:6660787a99b2e58203539583663c973b48979fc00ff2cb78dc0ea17429e1f6ef";
  hash = "sha256-WHhLw9lQb+ZuyMSp17BXCgrGatrTSlC1hyhSoLAnJzE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
