pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:221639a84fae9d9ec5236a50f4980c3cd5332851949f6e989f5f44cc411cf4fa";
  sha256 = "0llhjbr6m33yfbkb3c4xjcwywk7w2p6wahg6xiz73rcsjjgg8lz1";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "8.0.1";
}
