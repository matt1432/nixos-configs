pkgs:
pkgs.dockerTools.pullImage {
  imageName = "lscr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:62f8f7ff234da814bf361b5587bd0c9d9edcfb5c9597f069aff56d5f73d212a6";
  sha256 = "13fkfqihjh8znx5ndyz9k397wd7pcidcca4kwcm80bl9a9x1jxjb";
  finalImageName = "lscr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
