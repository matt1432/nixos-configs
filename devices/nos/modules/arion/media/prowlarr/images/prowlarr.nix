pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:10e2fca38877b6795a41401aecd816ba3d03bd7cfe3e4d2fb4894a81d45e5aa4";
  sha256 = "1nvz3f3nb8kf4vri9af0zlxdr3z0jasznjrlwarkxzrdr25gp6p9";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
