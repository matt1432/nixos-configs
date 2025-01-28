pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:698b9b2d61eee42578cf268dc1490a136554fb186a448b51430f069431d5e754";
  hash = "sha256-Tc85XpaK3LnyGue8YjzNZzStRUtjF7bU06mkPCPA5pk=";
  finalImageName = imageName;
  finalImageTag = "release";
}
