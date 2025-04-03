pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:8e93c08ff7112303bf29395520101bf23b08ff7621c3b931672dc6e0a6caae1c";
  hash = "sha256-7b9Ii9LUS6TfAHKiuO2TBYBbkWiMQ3fHF8PxErlG8UA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
