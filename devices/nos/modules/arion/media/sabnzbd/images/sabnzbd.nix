pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:36bdeef099e87a0da24e5b87d88abde93cd188a24511a4bfb214372824201f00";
  sha256 = "0n8d1rnc9d4yccgh65hxxp4mfpadhhgsqf5jg4lm4zng03yrnr0x";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
