pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:5ed8fcc66f4ed123c1b2560ed708dc148755b6e4cbd8b943fab094f2c6bfa91e";
  hash = "sha256-sH+aeUx4b8iJhHznSnxeJtICQbn/dgg+NFDnzyvTxEE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
