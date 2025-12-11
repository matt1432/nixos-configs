pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:4aa1e82d1e96ae712095d881b7e3840e6db6ca862c335be5b00001f31156650b";
  hash = "sha256-7VAZfQZBAKMO3qCxWgCU2f592oU9PH3eb7stHbC1UJc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
