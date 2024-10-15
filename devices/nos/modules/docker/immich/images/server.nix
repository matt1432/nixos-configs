pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:3c4250f80ef0c38b70fb947c2c6688e07c737d2409c1d715a2f03fb7d75ba036";
  sha256 = "1bfywvvcr8a07z8zxwjdlxfjnaxyzzwnd74cxpfk0dnwlmrw0pv3";
  finalImageName = imageName;
  finalImageTag = "release";
}
