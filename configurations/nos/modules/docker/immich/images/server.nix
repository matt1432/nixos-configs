pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:895f5aafb6fa1bca334b694d4aa9e1de6be22ab30e64c1f0f0a0ca0a5e6e67b5";
  hash = "sha256-LZw5QYTxC/vHZ+BR5rPU4afbwMs1GhydMBoyHXhj/JY=";
  finalImageName = imageName;
  finalImageTag = "release";
}
