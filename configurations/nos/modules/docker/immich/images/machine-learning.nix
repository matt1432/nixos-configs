pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:6239f9852f2ccd8bef52b161629a8fc62bac7636750c06e5fe021e994bab4781";
  hash = "sha256-LqAISUmtc+gnnvOZmZmImOw5iJu3dONWBFKi7/B6dEA=";
  finalImageName = imageName;
  finalImageTag = "release";
}
