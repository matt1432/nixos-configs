pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:119aaa4a4f7349bcd2a136c5373a0d7925b5479915c7dfe0c0ad352db2a6d438";
  hash = "sha256-OLRKZ3iSj+2vtvbkKj4WmjhC3h1/MaBwGWIHEPKCEGM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
