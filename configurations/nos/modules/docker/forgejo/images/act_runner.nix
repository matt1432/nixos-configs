pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:6190e52b6df100a1ca6be7e2e8331c60422440f98dfd286cc49c6be54d6783b5";
  hash = "sha256-A5zDXAz/PXr7d2GnhTpla6XC3q4I6jG8dBqHN4IOujk=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
