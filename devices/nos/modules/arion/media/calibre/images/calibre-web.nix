pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:73aa52c663537a21d0b2e5315ba1080aeaecff1fa29dc7c020a4107f64e96490";
  sha256 = "14mzhfq5pybv6dq4wvbgrk2iw3jq2hwyi095ymhb7qzwrvggmidx";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
