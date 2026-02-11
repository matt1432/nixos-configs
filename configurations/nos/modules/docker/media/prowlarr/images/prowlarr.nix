pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:e74a1e093dcc223d671d4b7061e2b4946f1989a4d3059654ff4e623b731c9134";
  hash = "sha256-ZTUfgAuTpzmTKgxlkPPAHrDXMUN865PxIArDvYHaw3U=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
