pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:37cfb25fdeaca82e1ad89a1bf664efe41ad481ed56aa069f710ac975cc5c6ecf";
  hash = "sha256-xBoV5ITgLvZd1Y2CDKBYm+LanglKsk9riKRvHUDjtGU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
