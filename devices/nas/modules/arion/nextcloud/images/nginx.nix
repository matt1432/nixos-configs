pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:c26ae7472d624ba1fafd296e73cecc4f93f853088e6a9c13c0d52f6ca5865107";
  sha256 = "0xqwbwjmcd3zgwv7hl27jxczxv9rfc2d3a49a0230dzw1xg9fnc3";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
