pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:dbaa9e91e1b5c093d27dccd0a5d717129747ccaa7d2d3e0277de2377f6893b95";
  hash = "sha256-p8QizfEWkXApb21N6EMYa0b1spqj3WvOaPbaqw5uQ6s=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
