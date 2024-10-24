pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:293517b90ef929178387f07c074c1f88d96d94eac3c1d95944ba2891527c1396";
  sha256 = "142ngzxx3vp59srmxs8ba0xpim2aaxk5scgf0xg3p6ki4rg2zx12";
  finalImageName = imageName;
  finalImageTag = "latest";
}
