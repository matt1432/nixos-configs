pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:9b8f02e896b1151ea60da05cf3e11fc7bd1c432dc6becee75ceb420f3d162b97";
  hash = "sha256-mNOm9GVoS473zQvcVXxBfiyRaQJFH0QHWJ1QgNfp520=";
  finalImageName = imageName;
  finalImageTag = "16";
}
