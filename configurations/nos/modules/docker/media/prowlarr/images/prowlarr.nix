pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:25d21c04c7cc39a706217abb77bb60b283d9eaaf16acf539c930e3c797e21f25";
  hash = "sha256-3xqv0yIc2xLKT9PbdLrPCRhdDBgPsOyMjPCARZyUoiU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
