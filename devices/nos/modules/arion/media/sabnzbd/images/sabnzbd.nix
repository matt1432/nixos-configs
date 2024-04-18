pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:9d7c22bb7936fbf96a164f8d4ad50c165d1cbb83adba84f4971ab5f21dd79a93";
  sha256 = "0nm7rgjvzxh71zrk7az0f3cab0n0mncwnka9g2asjm8j00666ycq";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
