pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:2ae64259bfca88972deec4cffa3750a454224283515854408e35af480f167cd7";
  sha256 = "0f5ngyak0fmqpgvhrwcal928k74ifm3pq5calpxm5kaxvpz4jgkk";
  finalImageName = imageName;
  finalImageTag = "latest";
}
