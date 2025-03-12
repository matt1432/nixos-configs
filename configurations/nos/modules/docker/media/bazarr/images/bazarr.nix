pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:0b3e1b888615cbd32cf879963d041abcf863d15160a9ace2928039a7b00590ef";
  hash = "sha256-SmZDwml1K5GXPGo3F1t+I1KPBHEVI6mBHaXOfnFnYvY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
