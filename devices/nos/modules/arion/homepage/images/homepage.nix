pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:13d1bf9c5cf7d2b0f3af90ddfe59302f32374b8f48a56c6f6afc2a475bf919df";
  sha256 = "12kzw2dvlfv78nh6y0iqygjndbizxra39kpsrif5026p2hjm4gyp";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}
