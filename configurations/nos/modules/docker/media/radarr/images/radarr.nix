pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:51a9ac2a9eb47afc833541e5fd6c11b86eb9f810694c22fa2429e3078e9194b2";
  hash = "sha256-M919bjBquzbF8CXqxQfhMV1/m23KqsTSgjOTbjCPKK8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
