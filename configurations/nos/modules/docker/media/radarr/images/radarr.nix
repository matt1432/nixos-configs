pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:581f159c2b67436863cb4da30e158ef6f6b8878472abbba79ee5d5f7e6b7d28d";
  hash = "sha256-DHG3X9NSoqz590WUfH/FxamGyrLHmdGzrJpHNlwk09w=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
