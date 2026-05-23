pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:ab6b363102ccdbc39f6a62db926f567c61a5289bf25ba460f1c34423d8cc1a4d";
  hash = "sha256-B46SOGMpni7bZVu1dbMWj/xUQV8XmVPAZta5P2IULJ0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
