pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:76a15e85e391eb2702ac1c6ccd90fc7b7546913065c1504f708ce9bf863aedbf";
  hash = "sha256-YxKOWHfOdotuxYUZQPpP28h+LUIYvpx90hFlpuuEeK4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
