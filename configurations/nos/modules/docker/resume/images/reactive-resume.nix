pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:4b7eeee75dde8dbc211aec6eca8761a6d6eb0b7422bfe5bca987e471c953f7cd";
  hash = "sha256-/AWL1HdHu++9D2HyPsTQYwZv9lTFl4SvrUofj8EUY3s=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
