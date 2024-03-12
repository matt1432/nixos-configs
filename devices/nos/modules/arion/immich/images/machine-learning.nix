pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:ac21ed6160c106eb26f704626d1fbf693dd74640131afd4d2ccad5db26aa98c5";
  sha256 = "0k7h17i8741756rlpl5zgmiy0zvwwj9axjygxglvzgkyfhlmdrl5";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.98.2";
}
