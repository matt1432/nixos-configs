pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:4d89a309fd08a93649f1ae4a7572ae98f09d66b4c1dfb7916b71d31dec7eda38";
  sha256 = "1xd94gfxvfx49gj5vq6dfjgpvk2man69kxqydadnbhck8awqx7g3";
  finalImageName = imageName;
  finalImageTag = "release";
}
