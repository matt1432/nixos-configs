pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:25e0f3b3741cf8df6c322d6c9016b5be91ca6e154653b4d01c8c125bf1ce75c0";
  sha256 = "1fbp6b1z4z1d7p3xq1zwsgqrs11siq7mgn8l6b92xmsf16ygwps4";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
