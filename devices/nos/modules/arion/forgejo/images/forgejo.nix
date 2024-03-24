pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:0e45daaf937af5ed8579c4306a0b67146c12ce179223ae633c6f0dacc9fb26a7";
  sha256 = "0hh17xyiaxpgr0m2zy7xdw1y7zlhvxzi7mznrd6fx0zf50f2cnlb";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "1.21.8-0";
}
