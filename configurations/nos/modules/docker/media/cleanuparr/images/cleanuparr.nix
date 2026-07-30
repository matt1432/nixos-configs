pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:6564af85578254728a9b06ded12836d2773e56f0da703c317cb589b176c4e215";
  hash = "sha256-h8m1nZCC57N5Fg21gjZvzfJzO58tjKs9FuKN9iDw12Q=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
