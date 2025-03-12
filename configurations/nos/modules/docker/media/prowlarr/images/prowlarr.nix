pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:2100d2cee89da16e7ce4a1169406c7718e6508c86ddc497dfbfdb7d6be2ea0c2";
  hash = "sha256-VKlQx3BpLvs/Z6vehEdFPXDkiEcU0GIvp5kOPPKGSlM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
