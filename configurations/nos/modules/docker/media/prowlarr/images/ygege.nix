pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/uwudev/ygege";
  imageDigest = "sha256:56f28df68c5806ef81e639e826afc004e17e9f43f08848a8aa0d5649316cc49a";
  hash = "sha256-qz8orE31USa7axpHawigGXgf/zeDX9KXwxeQrBye6tI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
