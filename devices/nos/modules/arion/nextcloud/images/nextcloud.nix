pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:b08377deee6dbecf2d885c278ff711fb6e63d855d8fad4717056246b928cc9da";
  sha256 = "027w6m8mrf1a92mmp68pgf93fmwgjgh5q007f6ff9nblacqdn4zz";
  finalImageName = "nextcloud";
  finalImageTag = "fpm";
}
