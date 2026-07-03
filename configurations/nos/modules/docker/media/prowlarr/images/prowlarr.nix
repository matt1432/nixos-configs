pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:3e9bd62ca90c97c5df75b7012e10a29f6926e62807deeddc1dc89e6e2fd141e1";
  hash = "sha256-BIXa4VaabPd5VYzkZfAuNpQy6KKhn1ilA+FoI33Qj5k=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
