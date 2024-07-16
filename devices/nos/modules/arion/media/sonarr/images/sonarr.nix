pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:746601dcc9dd95b3e2703c0244e453653d29b064281f7a9174d2d24d2aba81ef";
  sha256 = "0v7rjrz4b1gh2wa5xd0kmvyvgqqzj6ns3c6zksyg5kzzgvv4vqzm";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
