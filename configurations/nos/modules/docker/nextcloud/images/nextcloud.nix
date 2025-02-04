pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:07c4bfc1c38a3326e3ee777cbe6691de74424486bdc21ac31d291902c041296f";
  hash = "sha256-xYqfCZAOBERPerr2Nd0c5dyh6q9UdyGGFtHwMIVVGMY=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
