pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:de82a83c39316ef10024a17e6d0f5238bc27347b39ce4508a633604b4f48302d";
  hash = "sha256-pg886CAboy7RyVd9HIfcBAtYZ/zZnbi9QI8O+H+KfR4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
